package com.sulake.habbo.ui.widget.chatinput.habbiconselector
{
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog.habbicons.HabbiconCollectionData;
    import com.sulake.habbo.catalog.habbicons.HabbiconController;
    import com.sulake.habbo.catalog.habbicons.HabbiconControllerEvent;
    import com.sulake.habbo.catalog.habbicons.HabbiconOwnedItem;
    import com.sulake.habbo.catalog.habbicons.HabbiconShopItem;
    import com.sulake.habbo.catalog.habbicons.HabbiconState;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import com.sulake.habbo.ui.widget.chatinput.RoomChatInputView;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;

    public class HabbiconSelector
    {
        private static const SCREEN_LEFT_BORDER:int = 92;
        private static const CHAT_BAR_POPUP_OFFSET:int = 55;
        private static const MENU_MIN_HEIGHT:int = 91;
        private static const MENU_MAX_HEIGHT:int = 292;
        private static const TOP_BAR_HEIGHT:int = 42;
        private static const BOTTOM_PADDING:int = 6;
        private static const GRID_COLUMNS:int = 5;
        private static const SLOT_SIZE:int = 42;
        private static const SLOT_SPACING:int = 2;
        private static const SLOT_FILLED_COLOR:uint = 0xFF1F1F1F;
        private static const SLOT_EMPTY_COLOR:uint = 0xFF343434;
        private static const SLOT_FILLED_HOVER_COLOR:uint = 0xFF2A2A2A;
        private static const RECENT_LIMIT:int = 10;

        private var _anchor:RoomChatInputView;
        private var _button:IWindow;
        private var _menuContainer:IWindowContainer;
        private var _controller:HabbiconController;
        private var _window:IWindowContainer;
        private var _sectionList:IItemListWindow;
        private var _sectionTemplate:IWindowContainer;
        private var _searchInput:ITextFieldWindow;
        private var _searchPlaceholder:ITextWindow;
        private var _emptyView:IWindow;
        private var _sections:Array;
        private var _searchEntries:Array;
        private var _entriesById:Dictionary;
        private var _entryByWindow:Dictionary;
        private var _disposed:Boolean;
        private var _sectionsDirty:Boolean = true;
        private var _layoutDirty:Boolean = true;
        private var _lastQuery:String = "";

        public function HabbiconSelector(anchor:RoomChatInputView, button:IWindow, menuContainer:IWindowContainer, controller:HabbiconController)
        {
            this._anchor = anchor;
            this._button = button;
            this._menuContainer = menuContainer;
            this._controller = controller;
            this._sections = [];
            this._searchEntries = [];
            this._entriesById = new Dictionary();
            this._entryByWindow = new Dictionary(true);
            this.createWindow();
            if (this._controller != null)
            {
                this._controller.addEventListener(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, this.onControllerDataUpdated);
                this._controller.addEventListener(HabbiconControllerEvent.SHOP_DATA_UPDATED, this.onControllerDataUpdated);
                this._controller.addEventListener(HabbiconControllerEvent.RECENT_HABBICONS_UPDATED, this.onControllerDataUpdated);
                this._controller.addEventListener(HabbiconControllerEvent.STATUS_CHANGED, this.onControllerDataUpdated);
                this._controller.getShopData(true);
            }
        }

        public function get disposed():Boolean
        {
            return this._disposed || this._window == null;
        }

        public function get visible():Boolean
        {
            return this._window != null && this._window.visible;
        }

        public function toggle():void
        {
            if (this._window == null)
            {
                if (this._controller != null)
                {
                    this._controller.openHabbiconHub();
                }
                return;
            }
            if (this._window.visible)
            {
                this.hide();
                return;
            }
            if (this._menuContainer != null)
            {
                this._menuContainer.visible = true;
            }
            this._window.visible = true;
            this.renderIfDirty();
            this.alignToAnchor();
            this._window.activate();
            if (this._searchInput != null)
            {
                this._searchInput.focus();
            }
        }

        public function hide(resetUnseen:Boolean = true):void
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
            if (this._menuContainer != null)
            {
                this._menuContainer.visible = false;
            }
            if (resetUnseen && this._controller != null)
            {
                this._controller.resetUnseenHabbicons();
                this.invalidateLayout();
            }
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            if (this._controller != null)
            {
                this._controller.removeEventListener(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, this.onControllerDataUpdated);
                this._controller.removeEventListener(HabbiconControllerEvent.SHOP_DATA_UPDATED, this.onControllerDataUpdated);
                this._controller.removeEventListener(HabbiconControllerEvent.RECENT_HABBICONS_UPDATED, this.onControllerDataUpdated);
                this._controller.removeEventListener(HabbiconControllerEvent.STATUS_CHANGED, this.onControllerDataUpdated);
            }
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onAssetsLoaded);
            this.clearSections();
            this._sectionTemplate = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._menuContainer != null)
            {
                this._menuContainer.visible = false;
            }
            this._anchor = null;
            this._button = null;
            this._menuContainer = null;
            this._controller = null;
            this._sectionList = null;
            this._searchInput = null;
            this._searchPlaceholder = null;
            this._emptyView = null;
            this._sections = null;
            this._searchEntries = null;
            this._entriesById = null;
            this._entryByWindow = null;
            this._disposed = true;
        }

        private function createWindow():void
        {
            var asset:XmlAsset;
            var close:IWindow;
            var openHub:IWindow;
            var clear:IWindow;
            if (this._anchor == null || this._anchor.widget == null)
            {
                return;
            }
            asset = this._anchor.widget.assets.getAssetByName("habbiconselector_menu_xml") as XmlAsset;
            if (asset == null || asset.content == null)
            {
                return;
            }
            this._window = this._anchor.widget.windowManager.buildFromXML(asset.content as XML) as IWindowContainer;
            if (this._window == null)
            {
                return;
            }
            this._window.visible = false;
            if (this._menuContainer != null)
            {
                this._menuContainer.visible = false;
                this._menuContainer.addChild(this._window);
            }
            this._sectionList = this._window.findChildByName("habbicon_section_list") as IItemListWindow;
            if (this._sectionList != null)
            {
                this._sectionTemplate = this._sectionList.removeListItem(this._sectionList.getListItemByName("habbicon_section_template")) as IWindowContainer;
            }
            this._searchInput = this._window.findChildByName("habbicon_search_input") as ITextFieldWindow;
            this._searchPlaceholder = this._window.findChildByName("habbicon_search_placeholder") as ITextWindow;
            clear = this._window.findChildByName("habbicon_search_clear_button");
            openHub = this._window.findChildByName("habbicon_open_hub_button");
            this._emptyView = this._window.findChildByName("empty_view");
            close = this._window.findChildByTag("close");
            if (this._searchInput != null)
            {
                this._searchInput.procedure = this.onSearch;
            }
            if (this._searchPlaceholder != null)
            {
                this._searchPlaceholder.text = this.localize("generic.search", "search");
                this._searchPlaceholder.procedure = this.onSearchPlaceholder;
            }
            if (clear != null)
            {
                clear.procedure = this.onSearchClear;
            }
            if (openHub != null)
            {
                openHub.procedure = this.onOpenHub;
            }
            if (close != null)
            {
                close.procedure = this.onClose;
            }
            this.setSearchState(false);
            HabbiconAssetManager.addEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onAssetsLoaded);
        }

        private function onControllerDataUpdated(event:Event):void
        {
            this.invalidateSections();
            if (this._window != null && this._window.visible)
            {
                this.renderIfDirty();
                this.alignToAnchor();
            }
        }

        private function onAssetsLoaded(event:Event):void
        {
            this.invalidateLayout();
            if (this._window != null && this._window.visible)
            {
                this.renderIfDirty();
            }
        }

        private function invalidateSections():void
        {
            this._sectionsDirty = true;
            this._layoutDirty = true;
        }

        private function invalidateLayout():void
        {
            this._layoutDirty = true;
        }

        private function renderIfDirty():void
        {
            var query:String = this.normalizedQuery();
            if (this._lastQuery != query)
            {
                this._layoutDirty = true;
            }
            if (this._sectionsDirty)
            {
                this.refreshSections();
                this._sectionsDirty = false;
            }
            if (this._layoutDirty)
            {
                this.refresh(query);
                this._lastQuery = query;
                this._layoutDirty = false;
            }
            this.setSearchState(query.length > 0);
        }

        private function refreshSections():void
        {
            var ownedEntries:Array = [];
            var favouriteEntries:Array = [];
            var recentEntries:Array;
            this._sections = [];
            this._searchEntries = [];
            this._entriesById = new Dictionary();
            if (this._controller == null)
            {
                return;
            }
            this.collectOwnedEntries(ownedEntries, favouriteEntries);
            this.sortEntries(ownedEntries);
            this.sortEntries(favouriteEntries);
            recentEntries = this.buildRecentEntries();
            if (favouriteEntries.length > 0)
            {
                this._sections.push(new HabbiconSelectorSection("favorites", "favorites", this.localize("habbicons.favourites.title", "Favorites"), favouriteEntries));
            }
            if (recentEntries.length > 0)
            {
                this._sections.push(new HabbiconSelectorSection("recent", "recent", this.localize("habbicon.recently.used", "Recently used"), recentEntries));
            }
            this.addOwnedSetSections();
            if (this._sections.length == 0 && ownedEntries.length > 0)
            {
                this._sections.push(new HabbiconSelectorSection("owned", "owned", this.localize("habbicons.owned", "Owned Habbicons"), ownedEntries));
            }
        }

        private function collectOwnedEntries(ownedEntries:Array, favouriteEntries:Array):void
        {
            var owned:HabbiconOwnedItem;
            var entry:HabbiconSelectorEntry;
            var collection:HabbiconCollectionData;
            var shopItem:HabbiconShopItem;
            for each (owned in this._controller.ownedHabbicons)
            {
                if (owned != null && HabbiconState.isUsableState(owned.habbiconState))
                {
                    entry = this.getOrCreateEntry(owned.habbiconId, owned.habbiconState == HabbiconState.FAVOURITE);
                    ownedEntries.push(entry);
                    this._searchEntries.push(entry);
                    if (entry.favorite)
                    {
                        favouriteEntries.push(entry);
                    }
                }
            }
            for each (collection in this._controller.shopCollections)
            {
                if (collection != null && collection.habbicons != null)
                {
                    for each (shopItem in collection.habbicons)
                    {
                        if (shopItem != null && HabbiconState.isUsableState(shopItem.state) && this._entriesById[shopItem.habbiconId] == null)
                        {
                            entry = this.getOrCreateEntry(shopItem.habbiconId, shopItem.state == HabbiconState.FAVOURITE, shopItem.name);
                            ownedEntries.push(entry);
                            this._searchEntries.push(entry);
                            if (entry.favorite)
                            {
                                favouriteEntries.push(entry);
                            }
                        }
                    }
                }
            }
        }

        private function addOwnedSetSections():void
        {
            var collection:HabbiconCollectionData;
            var shopItem:HabbiconShopItem;
            var entries:Array;
            var entry:HabbiconSelectorEntry;
            if (this._controller == null || !this._controller.hasLoadedShopData)
            {
                return;
            }
            for each (collection in this._controller.shopCollections)
            {
                if (collection == null)
                {
                    continue;
                }
                entries = [];
                if (collection.habbicons != null)
                {
                    for each (shopItem in collection.habbicons)
                    {
                        if (shopItem != null)
                        {
                            entry = this._entriesById[shopItem.habbiconId] as HabbiconSelectorEntry;
                            if (entry != null)
                            {
                                entries.push(entry);
                            }
                        }
                    }
                }
                if (collection.rewardHabbiconId > 0)
                {
                    entry = this._entriesById[collection.rewardHabbiconId] as HabbiconSelectorEntry;
                    if (entry != null)
                    {
                        entries.push(entry);
                    }
                }
                if (entries.length > 0)
                {
                    this._sections.push(new HabbiconSelectorSection("collection", "collection:" + collection.collectionId, this.resolveCollectionTitle(collection), entries));
                }
            }
        }

        private function buildRecentEntries():Array
        {
            var id:int;
            var entry:HabbiconSelectorEntry;
            var result:Array = [];
            if (this._controller == null)
            {
                return result;
            }
            for each (id in this._controller.recentHabbiconIds)
            {
                entry = this._entriesById[id] as HabbiconSelectorEntry;
                if (entry != null)
                {
                    result.push(entry);
                    if (result.length >= RECENT_LIMIT)
                    {
                        break;
                    }
                }
            }
            return result;
        }

        private function refresh(query:String):void
        {
            var section:HabbiconSelectorSection;
            var filtered:Array;
            var entry:HabbiconSelectorEntry;
            var count:int = 0;
            if (this._sectionList == null || this._sectionTemplate == null)
            {
                return;
            }
            this.clearSections();
            if (query.length > 0)
            {
                filtered = [];
                for each (entry in this._searchEntries)
                {
                    if (entry.searchName.indexOf(query) >= 0)
                    {
                        filtered.push(entry);
                    }
                }
                if (filtered.length > 0)
                {
                    this.addSection(new HabbiconSelectorSection("search", "search", this.localize("habbicon.search.results", "Search results"), filtered));
                    count++;
                }
            }
            else
            {
                for each (section in this._sections)
                {
                    if (section != null && section.entries != null && section.entries.length > 0)
                    {
                        this.addSection(section);
                        count++;
                    }
                }
            }
            if (this._emptyView != null)
            {
                this._emptyView.visible = count == 0;
            }
            this.setText(this._window, "empty_text", count == 0 ? this.localize("habbicons.selector.empty", "You do not own any Habbicons yet.") : "");
            this.updateHeight();
        }

        private function clearSections():void
        {
            var child:IWindow;
            this._entryByWindow = new Dictionary(true);
            if (this._sectionList == null)
            {
                return;
            }
            while (this._sectionList.numListItems > 0)
            {
                child = this._sectionList.removeListItemAt(0);
                if (child != null)
                {
                    child.dispose();
                }
            }
        }

        private function addSection(section:HabbiconSelectorSection):void
        {
            var sectionWindow:IWindowContainer = this.createSectionWindow(section);
            if (sectionWindow != null)
            {
                this._sectionList.addListItem(sectionWindow);
            }
        }

        private function createSectionWindow(section:HabbiconSelectorSection):IWindowContainer
        {
            var sectionWindow:IWindowContainer = this._sectionTemplate.clone() as IWindowContainer;
            var grid:IItemGridWindow;
            var template:IWindowContainer;
            var rows:int;
            var totalSlots:int;
            var index:int;
            var entry:HabbiconSelectorEntry;
            var tile:IWindowContainer;
            if (sectionWindow == null)
            {
                return null;
            }
            sectionWindow.visible = true;
            this.setText(sectionWindow, "section_title", section.title);
            grid = sectionWindow.findChildByName("habbicon_grid") as IItemGridWindow;
            if (grid == null)
            {
                return sectionWindow;
            }
            template = grid.getGridItemAt(0) as IWindowContainer;
            grid.removeGridItems();
            if (template == null)
            {
                return sectionWindow;
            }
            rows = Math.max(1, Math.ceil(section.entries.length / GRID_COLUMNS));
            totalSlots = rows * GRID_COLUMNS;
            for (index = 0; index < totalSlots; index++)
            {
                entry = index < section.entries.length ? section.entries[index] as HabbiconSelectorEntry : null;
                tile = this.createTile(entry, template);
                grid.addGridItem(tile);
            }
            grid.height = rows * SLOT_SIZE + (rows - 1) * SLOT_SPACING;
            sectionWindow.height = 20 + grid.height + 2;
            template.dispose();
            return sectionWindow;
        }

        private function createTile(entry:HabbiconSelectorEntry, template:IWindowContainer):IWindowContainer
        {
            var tile:IWindowContainer = template.clone() as IWindowContainer;
            var bg:IWindow;
            tile.visible = true;
            bg = tile.findChildByName("habbicon_item_bg");
            if (bg != null)
            {
                bg.color = entry != null ? SLOT_FILLED_COLOR : SLOT_EMPTY_COLOR;
            }
            if (entry != null)
            {
                tile.id = entry.habbiconId;
                tile.name = "habbicon_selector_item_" + entry.habbiconId;
                if (tile is IInteractiveWindow)
                {
                    IInteractiveWindow(tile).toolTipCaption = entry.name;
                }
                tile.procedure = this.onTile;
                this.setTileBitmap(tile, entry);
                this._entryByWindow[tile] = entry;
            }
            else
            {
                tile.id = 0;
                this.setTileBitmap(tile, null);
            }
            return tile;
        }

        private function setTileBitmap(tile:IWindowContainer, entry:HabbiconSelectorEntry):void
        {
            var bitmapWindow:IBitmapWrapperWindow = tile.findChildByName("habbicon_icon") as IBitmapWrapperWindow;
            var bitmap:BitmapData;
            if (bitmapWindow == null)
            {
                return;
            }
            if (bitmapWindow.bitmap != null)
            {
                bitmapWindow.bitmap.dispose();
                bitmapWindow.bitmap = null;
            }
            if (entry == null)
            {
                bitmapWindow.visible = false;
                bitmapWindow.invalidate();
                return;
            }
            bitmap = this.createHabbiconBitmap(entry.habbiconId, entry.color);
            bitmapWindow.bitmap = new BitmapData(bitmapWindow.width, bitmapWindow.height, true, 0);
            bitmapWindow.bitmap.copyPixels(bitmap, bitmap.rect, new Point((bitmapWindow.width - bitmap.width) / 2, (bitmapWindow.height - bitmap.height) / 2), null, null, true);
            bitmap.dispose();
            bitmapWindow.visible = true;
            bitmapWindow.invalidate();
        }

        private function updateHeight():void
        {
            var contentHeight:int;
            var listHeight:int;
            if (this._window == null || this._sectionList == null)
            {
                return;
            }
            contentHeight = int(this._sectionList.scrollableRegion.height);
            listHeight = Math.max(46, contentHeight + 2);
            listHeight = Math.min(listHeight, MENU_MAX_HEIGHT - TOP_BAR_HEIGHT - BOTTOM_PADDING);
            this._sectionList.height = listHeight;
            this._window.height = Math.max(MENU_MIN_HEIGHT, TOP_BAR_HEIGHT + listHeight + BOTTOM_PADDING);
            this._window.invalidate();
        }

        private function alignToAnchor():void
        {
            var rect:Rectangle;
            var global:Point;
            if (this._window == null || this._button == null || this._menuContainer == null)
            {
                return;
            }
            rect = new Rectangle();
            this._button.getGlobalRectangle(rect);
            this._menuContainer.x = rect.x;
            this._menuContainer.y = rect.bottom - CHAT_BAR_POPUP_OFFSET - this._window.height;
            global = new Point();
            this._menuContainer.getGlobalPosition(global);
            if (global.x < SCREEN_LEFT_BORDER)
            {
                this._menuContainer.x += SCREEN_LEFT_BORDER - global.x;
            }
            if (this._menuContainer.y < 0)
            {
                this._menuContainer.y = 0;
            }
        }

        private function onTile(event:WindowEvent, window:IWindow):void
        {
            var entry:HabbiconSelectorEntry;
            if (event.type != WindowMouseEvent.CLICK || window == null || this._controller == null)
            {
                return;
            }
            entry = this._entryByWindow[window] as HabbiconSelectorEntry;
            if (entry == null)
            {
                return;
            }
            this._controller.useHabbiconInRoom(entry.habbiconId);
            if (!(event is WindowMouseEvent) || !WindowMouseEvent(event).shiftKey)
            {
                this.hide(false);
            }
        }

        private function onOpenHub(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK && this._anchor != null)
            {
                if (this._controller != null)
                {
                    this._controller.resetUnseenHabbicons();
                }
                this._anchor.widget._Str_13265.context.createLinkEvent("habbicons/open");
                this.hide(false);
            }
        }

        private function onSearch(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowEvent.WINDOW_EVENT_CHANGE || (event is WindowKeyboardEvent && WindowKeyboardEvent(event).keyCode == Keyboard.ENTER))
            {
                this.invalidateLayout();
                this.renderIfDirty();
                this.alignToAnchor();
            }
        }

        private function onSearchPlaceholder(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.DOWN && this._searchInput != null)
            {
                this._searchInput.focus();
            }
        }

        private function onSearchClear(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK && this._searchInput != null)
            {
                this._searchInput.text = "";
                this.invalidateLayout();
                this.renderIfDirty();
                this.alignToAnchor();
            }
        }

        private function onClose(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this.hide();
            }
        }

        private function normalizedQuery():String
        {
            var value:String = this._searchInput != null ? this._searchInput.text : "";
            return value != null ? value.toLowerCase() : "";
        }

        private function setSearchState(active:Boolean):void
        {
            if (this._searchPlaceholder != null)
            {
                this._searchPlaceholder.visible = !active && (this._searchInput == null || this._searchInput.text.length == 0);
            }
        }

        private function getOrCreateEntry(habbiconId:int, favorite:Boolean, fallbackName:String = null):HabbiconSelectorEntry
        {
            var entry:HabbiconSelectorEntry = this._entriesById[habbiconId] as HabbiconSelectorEntry;
            if (entry == null)
            {
                entry = new HabbiconSelectorEntry(habbiconId, this._controller.resolveHabbiconDisplayName(habbiconId, fallbackName), this.seededColor(habbiconId * 37), favorite);
                this._entriesById[habbiconId] = entry;
            }
            if (favorite)
            {
                entry.favorite = true;
            }
            return entry;
        }

        private function sortEntries(entries:Array):void
        {
            entries.sort(function(a:HabbiconSelectorEntry, b:HabbiconSelectorEntry):int
            {
                if (a.favorite != b.favorite)
                {
                    return a.favorite ? -1 : 1;
                }
                return a.habbiconId - b.habbiconId;
            });
        }

        private function resolveCollectionTitle(collection:HabbiconCollectionData):String
        {
            if (collection.name != null && collection.name.length > 0)
            {
                return this.localize("habbicon_collection_" + collection.name.toLowerCase() + "_name", collection.name);
            }
            return this.localize("habbicons.collection", "Collection");
        }

        private function localize(key:String, fallback:String):String
        {
            return this._controller != null ? this._controller.localize(key, fallback) : fallback;
        }

        private function setText(container:IWindowContainer, name:String, text:String):void
        {
            var field:ITextWindow = container != null ? container.findChildByName(name) as ITextWindow : null;
            if (field != null)
            {
                field.text = text;
            }
        }

        private function createHabbiconBitmap(habbiconId:int, color:uint):BitmapData
        {
            var bitmap:BitmapData = HabbiconAssetManager.getPreviewBitmap(habbiconId, false);
            return bitmap != null ? bitmap.clone() : new BitmapData(40, 40, false, color);
        }

        private function seededColor(seed:int):uint
        {
            switch (seed % 6)
            {
                case 0:
                    return 0x00F9C52F;
                case 1:
                    return 0x00F39D2F;
                case 2:
                    return 0x00EF7F2F;
                case 3:
                    return 0x008EDBFF;
                case 4:
                    return 0x004DC0E8;
                default:
                    return 0x00C384F5;
            }
        }
    }
}
