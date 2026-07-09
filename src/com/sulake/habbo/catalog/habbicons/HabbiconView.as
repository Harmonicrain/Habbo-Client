package com.sulake.habbo.catalog.habbicons
{
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class HabbiconView
    {
        private static const TAB_ALL:int = 0;
        private static const TAB_OWNED:int = 1;
        private static const TAB_FAVOURITED:int = 2;
        private static const EMPTY_TILE_COUNT:int = 20;
        private static const HABBICON_LOCKED_TRANSFORM:ColorTransform = new ColorTransform(0.35, 0.35, 0.35, 0.65, 90, 85, 80, 0);
        private static const PROGRESS_INCOMPLETE_COLOR:uint = 0xFF54A8E8;
        private static const PROGRESS_COMPLETE_COLOR:uint = 0xFF78C95C;

        private var _controller:HabbiconController;
        private var _window:IWindowContainer;
        private var _setRowTemplate:IWindowContainer;
        private var _tileTemplate:IWindowContainer;
        private var _emptyTileTemplate:IWindowContainer;
        private var _trayGroupTemplate:IWindowContainer;
        private var _trayTileTemplate:IWindowContainer;
        private var _selectedCollectionId:int = 0;
        private var _selectedHabbiconId:int = 0;
        private var _activeTile:IWindowContainer;
        private var _activeTab:int = 0;
        private var _disposed:Boolean;

        public function HabbiconView(controller:HabbiconController)
        {
            this._controller = controller;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        public function show():void
        {
            if (this._window == null)
            {
                this.createWindow();
            }
            if (this._window == null)
            {
                return;
            }
            this.refresh();
            this._window.visible = true;
            this._window.center();
            this._window.activate();
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            if (this._controller != null)
            {
                this._controller.removeEventListener(HabbiconControllerEvent.SHOP_DATA_UPDATED, this.onControllerUpdated);
                this._controller.removeEventListener(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, this.onControllerUpdated);
                this._controller.removeEventListener(HabbiconControllerEvent.STATUS_CHANGED, this.onControllerUpdated);
            }
            this._setRowTemplate = null;
            this._tileTemplate = null;
            this._emptyTileTemplate = null;
            this._trayGroupTemplate = null;
            this._trayTileTemplate = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._controller = null;
            this._disposed = true;
        }

        private function createWindow():void
        {
            var asset:XmlAsset = this._controller.assets.getAssetByName("habbicon_view_xml") as XmlAsset;
            if (asset == null || asset.content == null)
            {
                return;
            }
            this._window = this._controller.windowManager.buildFromXML(asset.content as XML, 1) as IWindowContainer;
            if (this._window == null)
            {
                return;
            }
            this._window.name = "habbicon_hub";
            this.extractTemplates();
            this.wireStaticControls();
            this.clearSetPage();
            this.hidePopup();
            this._controller.addEventListener(HabbiconControllerEvent.SHOP_DATA_UPDATED, this.onControllerUpdated);
            this._controller.addEventListener(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, this.onControllerUpdated);
            this._controller.addEventListener(HabbiconControllerEvent.STATUS_CHANGED, this.onControllerUpdated);
        }

        private function extractTemplates():void
        {
            var trayGrid:IItemGridWindow;
            this._setRowTemplate = this.extractTemplate("set_row_template");
            if (this._setRowTemplate != null)
            {
                this._setRowTemplate.visible = false;
            }
            this._tileTemplate = this.extractTemplate("tile_template");
            this._emptyTileTemplate = this.extractTemplate("empty_tile_template");
            if (this._tileTemplate != null)
            {
                this._tileTemplate.visible = false;
            }
            if (this._emptyTileTemplate != null)
            {
                this._emptyTileTemplate.visible = false;
            }
            this._trayGroupTemplate = this.extractTemplate("tray_group_template");
            if (this._trayGroupTemplate != null)
            {
                this._trayGroupTemplate.visible = false;
                trayGrid = this._trayGroupTemplate.findChildByName("tray_group_grid") as IItemGridWindow;
                if (trayGrid != null)
                {
                    this._trayTileTemplate = this.extractTemplateFromParent(this._trayGroupTemplate, "tray_tile_template");
                    if (this._trayTileTemplate != null)
                    {
                        this._trayTileTemplate.visible = false;
                    }
                }
            }
        }

        private function extractTemplate(name:String):IWindowContainer
        {
            return this.extractTemplateFromParent(this._window, name);
        }

        private function extractTemplateFromParent(parent:IWindowContainer, name:String):IWindowContainer
        {
            var template:IWindowContainer = parent == null ? null : parent.findChildByName(name) as IWindowContainer;
            var templateParent:IWindowContainer;
            if (template == null)
            {
                return null;
            }
            templateParent = template.parent as IWindowContainer;
            if (templateParent != null)
            {
                templateParent.removeChild(template);
            }
            template.visible = false;
            return template;
        }

        private function wireStaticControls():void
        {
            this.setProcedureByTag("close", this.onClose);
            this.setProcedure("tab_all_sets", this.onTabAll);
            this.setProcedure("tab_owned", this.onTabOwned);
            this.setProcedure("tab_favourited", this.onTabFavourited);
            this.setProcedure("reward_action_button", this.onRewardAction);
            this.setProcedure("reward_buy_button", this.onBuyCollection);
            this.setProcedure("habbicon_popup_action_button", this.onPopupAction);
            this.setProcedure("habbicon_popup_buy_button", this.onPopupBuy);
        }

        private function refresh():void
        {
            if (this._window == null)
            {
                return;
            }
            this.ensureSelectedCollection();
            this.setText("album_title", this._controller.localize("habbicons.hub.title", "Habbicons"));
            this.setText("album_subtitle", this._controller.localize("habbicons.hub.subtitle", "Collect sets, unlock animated Habbicons, and use them inside rooms!"));
            this.setText("owned_habbicons_label", this._controller.localize("habbicons.owned", "Owned habbicons"));
            this.setText("sets_completed_label", this._controller.localize("habbicons.sets", "Sets completed"));
            this.setText("owned_habbicons_value", this.countOwned().toString());
            this.setText("sets_completed_value", this.countCompletedSets().toString());
            this.updateOverallProgress();
            this.updateTabs();
            if (this._activeTab == TAB_ALL)
            {
                this.populateSetRail();
                if (this.getSelectedCollection() != null)
                {
                    this.populateSetPage(this.getSelectedCollection());
                }
                else
                {
                    this.clearSetPage();
                }
            }
            else
            {
                this.populateTray();
            }
            this.hidePopup();
        }

        private function updateTabs():void
        {
            var allSets:IWindow = this._window.findChildByName("all_sets_container");
            var tray:IWindow = this._window.findChildByName("tray_container");
            if (allSets != null)
            {
                allSets.visible = this._activeTab == TAB_ALL;
            }
            if (tray != null)
            {
                tray.visible = this._activeTab != TAB_ALL;
            }
            this.setText("tray_title", this._activeTab == TAB_OWNED ? this._controller.localize("habbicons.tab.owned", "Owned") : this._controller.localize("habbicons.tab.favourited", "Favorited"));
            this.setText("tray_summary", this._activeTab == TAB_OWNED ? this._controller.localize("habbicons.tray.owned.summary", "All Habbicons you own.") : this._controller.localize("habbicons.tray.favourited.summary", "Your favourite Habbicons."));
        }

        private function populateSetRail():void
        {
            var list:IItemListWindow = this._window.findChildByName("set_rail_list") as IItemListWindow;
            var collection:HabbiconCollectionData;
            if (list == null || this._setRowTemplate == null)
            {
                return;
            }
            list.removeListItems();
            for each (collection in this._controller.shopCollections)
            {
                list.addListItem(this.createSetRow(collection));
            }
        }

        private function createSetRow(collection:HabbiconCollectionData):IWindowContainer
        {
            var row:IWindowContainer = this._setRowTemplate.clone() as IWindowContainer;
            var progress:Object = this.getCollectionProgress(collection);
            row.visible = true;
            row.id = collection.collectionId;
            row.name = "set_row_" + collection.collectionId;
            row.procedure = this.onSetRowEvent;
            this.setChildText(row, "set_row_title", this.collectionName(collection));
            this.setChildBitmap(row, "set_icon", this.getCollectionRailIcon(collection));
            this.setChildProgress(row, "set_row_progress_bar", progress.owned, progress.total);
            this.setChildText(row, "set_row_progress_text", progress.owned + "/" + progress.total);
            this.tintRow(row, collection.collectionId == this._selectedCollectionId);
            return row;
        }

        private function populateSetPage(collection:HabbiconCollectionData):void
        {
            var grid:IItemGridWindow = this._window.findChildByName("set_grid") as IItemGridWindow;
            var item:HabbiconShopItem;
            var reward:HabbiconShopItem;
            var progress:Object;
            var count:int;
            if (collection == null || grid == null || this._tileTemplate == null)
            {
                this.clearSetPage();
                return;
            }
            progress = this.getCollectionProgress(collection);
            grid.removeGridItems();
            this.setText("set_title", this.collectionName(collection));
            this.setText("set_description", this.collectionDescription(collection));
            this.setProgress("set_progress_bar", progress.owned, progress.total);
            this.setText("set_progress_text", progress.owned + " / " + progress.total);
            for each (item in collection.habbicons)
            {
                if (item == null || item.state == HabbiconState.REWARD_MARKER)
                {
                    reward = item;
                    continue;
                }
                grid.addGridItem(this.createTile(item, false));
                count++;
            }
            while (count < EMPTY_TILE_COUNT && this._emptyTileTemplate != null)
            {
                var empty:IWindowContainer = this._emptyTileTemplate.clone() as IWindowContainer;
                empty.visible = true;
                grid.addGridItem(empty);
                count++;
            }
            this.populateRewardPanel(collection, reward);
            this.populateBuyPanel(collection, progress);
        }

        private function populateRewardPanel(collection:HabbiconCollectionData, reward:HabbiconShopItem):void
        {
            var panel:IWindow = this._window.findChildByName("reward_panel");
            var rewardId:int;
            var rewardState:int;
            var button:IWindow;
            if (panel == null)
            {
                return;
            }
            rewardId = reward != null ? reward.habbiconId : collection.rewardHabbiconId;
            rewardState = reward != null ? reward.state : collection.rewardState;
            panel.visible = rewardId > 0;
            if (!panel.visible)
            {
                return;
            }
            this.setText("reward_title", this._controller.localize("habbicons.reward.title", "Set reward"));
            if (HabbiconState.isUsableState(rewardState))
            {
                this.setText("reward_description", this._controller.localize("habbicon_book.reward.claimed", "Reward claimed."));
            }
            else if (rewardState == HabbiconState.CLAIMABLE)
            {
                this.setText("reward_description", this._controller.localize("habbicon_book.reward.claimable", "Reward ready to claim."));
            }
            else
            {
                this.setText("reward_description", this._controller.localize("habbicons.reward.description", "Complete this set to unlock the reward."));
            }
            this.setBitmap("reward_habbicon", HabbiconAssetManager.getPreviewBitmap(rewardId, false));
            button = this._window.findChildByName("reward_action_button");
            if (button != null)
            {
                button.id = rewardId;
                button.visible = rewardState == HabbiconState.CLAIMABLE || HabbiconState.isUsableState(rewardState);
                button.enable();
                button.caption = rewardState == HabbiconState.CLAIMABLE ? this._controller.localize("habbicon_reward.claim", "Claim") : this._controller.localize("habbicon_reward.claimed", "Claimed");
                if (rewardState != HabbiconState.CLAIMABLE)
                {
                    button.disable();
                }
            }
        }

        private function clearSetPage():void
        {
            var grid:IItemGridWindow = this._window == null ? null : this._window.findChildByName("set_grid") as IItemGridWindow;
            var panel:IWindow = this._window == null ? null : this._window.findChildByName("reward_panel");
            var buyPanel:IWindow = this._window == null ? null : this._window.findChildByName("reward_buy_container");
            if (grid != null)
            {
                grid.removeGridItems();
            }
            this.setText("set_title", "");
            this.setText("set_description", "");
            this.setProgress("set_progress_bar", 0, 0);
            this.setText("set_progress_text", "0 / 0");
            if (panel != null)
            {
                panel.visible = false;
            }
            if (buyPanel != null)
            {
                buyPanel.visible = false;
            }
        }

        private function populateBuyPanel(collection:HabbiconCollectionData, progress:Object):void
        {
            var panel:IWindow = this._window.findChildByName("reward_buy_container");
            var button:IWindow;
            if (panel == null)
            {
                return;
            }
            panel.visible = progress.owned < progress.total && (collection.priceCredits > 0 || collection.priceActivityPoints > 0);
            if (!panel.visible)
            {
                return;
            }
            this.setText("reward_buy_description", this._controller.localize("habbicons.buy_set", "Buy the full set"));
            this.setText("reward_buy_price", this.formatPrice(collection.priceCredits, collection.priceActivityPoints));
            button = this._window.findChildByName("reward_buy_button");
            if (button != null)
            {
                button.id = collection.collectionId;
            }
        }

        private function populateTray():void
        {
            var list:IItemListWindow = this._window.findChildByName("tray_group_list") as IItemListWindow;
            var collection:HabbiconCollectionData;
            var group:IWindowContainer;
            if (list == null || this._trayGroupTemplate == null || this._trayTileTemplate == null)
            {
                return;
            }
            list.removeListItems();
            for each (collection in this._controller.shopCollections)
            {
                group = this.createTrayGroup(collection);
                if (group != null)
                {
                    list.addListItem(group);
                }
            }
        }

        private function createTrayGroup(collection:HabbiconCollectionData):IWindowContainer
        {
            var group:IWindowContainer = this._trayGroupTemplate.clone() as IWindowContainer;
            var grid:IItemGridWindow = group.findChildByName("tray_group_grid") as IItemGridWindow;
            var item:HabbiconShopItem;
            var count:int;
            if (grid == null)
            {
                return null;
            }
            grid.removeGridItems();
            for each (item in collection.habbicons)
            {
                if (item == null || !HabbiconState.isUsableState(item.state))
                {
                    continue;
                }
                if (this._activeTab == TAB_FAVOURITED && item.state != HabbiconState.FAVOURITE)
                {
                    continue;
                }
                grid.addGridItem(this.createTile(item, true));
                count++;
            }
            if (count == 0)
            {
                group.dispose();
                return null;
            }
            group.visible = true;
            this.setChildText(group, "tray_group_title", this.collectionName(collection));
            return group;
        }

        private function createTile(item:HabbiconShopItem, tray:Boolean):IWindowContainer
        {
            var template:IWindowContainer = tray ? this._trayTileTemplate : this._tileTemplate;
            var tile:IWindowContainer = template.clone() as IWindowContainer;
            tile.visible = true;
            tile.id = item.habbiconId;
            tile.name = "habbicon_tile_" + item.habbiconId;
            tile.procedure = this.onTileEvent;
            this.setChildBitmap(tile, "bitmap", HabbiconAssetManager.getPreviewBitmap(item.habbiconId, false), this.isUnownedTileState(item.state) ? HABBICON_LOCKED_TRANSFORM : null);
            this.setChildVisible(tile, "favorite_icon", item.state == HabbiconState.FAVOURITE);
            this.setChildVisible(tile, "claimable_icon", item.state == HabbiconState.CLAIMABLE);
            this.setChildVisible(tile, "locked_overlay", this.isUnownedTileState(item.state) || item.state == HabbiconState.REWARD_MARKER);
            this.tintTile(tile, HabbiconState.isUsableState(item.state), false);
            return tile;
        }

        private function onTileEvent(event:WindowEvent, window:IWindow):void
        {
            var item:HabbiconShopItem;
            var tile:IWindowContainer = window as IWindowContainer;
            if (window == null || tile == null)
            {
                return;
            }
            item = this._controller.tryGetShopItem(window.id);
            if (event.type == WindowMouseEvent.OVER)
            {
                if (tile != this._activeTile)
                {
                    this.tintTile(tile, item != null && HabbiconState.isUsableState(item.state), true);
                }
                return;
            }
            if (event.type == WindowMouseEvent.OUT)
            {
                if (tile != this._activeTile)
                {
                    this.tintTile(tile, item != null && HabbiconState.isUsableState(item.state), false);
                }
                return;
            }
            if (event.type == WindowMouseEvent.CLICK)
            {
                this._selectedHabbiconId = window.id;
                this.showPopup(window, item);
            }
        }

        private function showPopup(anchor:IWindow, item:HabbiconShopItem):void
        {
            var popup:IWindow = this._window.findChildByName("habbicon_item_popup");
            var popupRoot:IWindowContainer = this._window.findChildByName("habbicon_popup_layer") as IWindowContainer;
            var anchorRect:Rectangle;
            var rootRect:Rectangle;
            var maxX:int;
            var maxY:int;
            var action:IWindow = this._window.findChildByName("habbicon_popup_action_button");
            var buy:IWindow = this._window.findChildByName("habbicon_popup_buy_button");
            var bottom:IWindow = this._window.findChildByName("habbicon_popup_bottom_bar");
            if (popup == null || item == null)
            {
                return;
            }
            if (popupRoot == null)
            {
                popupRoot = this._window;
            }
            this.setActiveTile(anchor as IWindowContainer, item);
            popup.visible = true;
            anchorRect = new Rectangle();
            rootRect = new Rectangle();
            anchor.getGlobalRectangle(anchorRect);
            popupRoot.getGlobalRectangle(rootRect);
            maxX = Math.max(4, popupRoot.width - popup.width - 4);
            maxY = Math.max(0, popupRoot.height - popup.height);
            popup.x = Math.max(4, Math.min(maxX, anchorRect.x - rootRect.x + int((anchorRect.width - popup.width) * 0.5)));
            popup.y = Math.max(0, Math.min(maxY, anchorRect.y - rootRect.y - popup.height + 2));
            this.setText("habbicon_popup_title", this._controller.resolveHabbiconDisplayName(item.habbiconId, item.name));
            if (HabbiconState.isUsableState(item.state))
            {
                this.setText("habbicon_popup_description", this._controller.localize("habbicons.popup.owned", "Use this Habbicon in the room, or mark it as a favourite."));
                if (action != null)
                {
                    action.visible = true;
                    action.id = item.habbiconId;
                    action.caption = item.state == HabbiconState.FAVOURITE ? this._controller.localize("habbicons.unfavorite", "Unfavorite") : this._controller.localize("habbicons.favorite", "Favorite");
                }
                if (bottom != null)
                {
                    bottom.visible = false;
                }
            }
            else if (item.state == HabbiconState.CLAIMABLE)
            {
                this.setText("habbicon_popup_description", this._controller.localize("habbicons.popup.claimable", "Claim this set reward."));
                if (action != null)
                {
                    action.visible = true;
                    action.id = item.habbiconId;
                    action.caption = this._controller.localize("habbicons.claim", "Claim");
                }
                if (bottom != null)
                {
                    bottom.visible = false;
                }
            }
            else
            {
                this.setText("habbicon_popup_description", this._controller.localize("habbicons.popup.not_owned", "Not owned"));
                if (action != null)
                {
                    action.visible = false;
                }
                if (bottom != null)
                {
                    bottom.visible = item.priceCredits > 0 || item.priceActivityPoints > 0;
                }
                if (buy != null)
                {
                    buy.id = item.habbiconId;
                }
                this.setText("habbicon_popup_price", this.formatPrice(item.priceCredits, item.priceActivityPoints));
            }
        }

        private function hidePopup():void
        {
            var popup:IWindow = this._window == null ? null : this._window.findChildByName("habbicon_item_popup");
            if (popup != null)
            {
                popup.visible = false;
            }
            this.clearActiveTile();
        }

        private function setActiveTile(tile:IWindowContainer, item:HabbiconShopItem):void
        {
            this.clearActiveTile();
            this._activeTile = tile;
            if (this._activeTile != null && item != null)
            {
                this.tintTile(this._activeTile, HabbiconState.isUsableState(item.state), true);
            }
        }

        private function clearActiveTile():void
        {
            var item:HabbiconShopItem;
            if (this._activeTile == null)
            {
                return;
            }
            item = this._controller == null ? null : this._controller.tryGetShopItem(this._activeTile.id);
            this.tintTile(this._activeTile, item != null && HabbiconState.isUsableState(item.state), false);
            this._activeTile = null;
        }

        private function onPopupAction(event:WindowEvent, window:IWindow):void
        {
            var item:HabbiconShopItem;
            if (event.type != WindowMouseEvent.CLICK || window == null)
            {
                return;
            }
            item = this._controller.tryGetShopItem(window.id);
            if (item == null)
            {
                return;
            }
            if (item.state == HabbiconState.CLAIMABLE)
            {
                this._controller.claimHabbicon(item.habbiconId);
            }
            else if (item.state == HabbiconState.FAVOURITE)
            {
                this._controller.unfavoriteHabbicon(item.habbiconId);
            }
            else if (item.state == HabbiconState.OWNED)
            {
                this._controller.favoriteHabbicon(item.habbiconId);
            }
        }

        private function onPopupBuy(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK && window != null)
            {
                this._controller.buyHabbicon(window.id);
            }
        }

        private function onRewardAction(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK && window != null && window.id > 0)
            {
                this._controller.claimHabbicon(window.id);
            }
        }

        private function onBuyCollection(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK && window != null && window.id > 0)
            {
                this._controller.buyHabbiconCollection(window.id);
            }
        }

        private function onSetRowEvent(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK && window != null)
            {
                this._selectedCollectionId = window.id;
                this.refresh();
            }
        }

        private function onTabAll(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this._activeTab = TAB_ALL;
                this.refresh();
            }
        }

        private function onTabOwned(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this._activeTab = TAB_OWNED;
                this.refresh();
            }
        }

        private function onTabFavourited(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this._activeTab = TAB_FAVOURITED;
                this.refresh();
            }
        }

        private function ensureSelectedCollection():void
        {
            var collection:HabbiconCollectionData;
            if (this._selectedCollectionId > 0 && this.getSelectedCollection() != null)
            {
                return;
            }
            for each (collection in this._controller.shopCollections)
            {
                this._selectedCollectionId = collection.collectionId;
                return;
            }
        }

        private function getSelectedCollection():HabbiconCollectionData
        {
            var collection:HabbiconCollectionData;
            for each (collection in this._controller.shopCollections)
            {
                if (collection.collectionId == this._selectedCollectionId)
                {
                    return collection;
                }
            }
            return null;
        }

        private function getCollectionProgress(collection:HabbiconCollectionData):Object
        {
            var total:int;
            var owned:int;
            var item:HabbiconShopItem;
            if (collection == null || collection.habbicons == null)
            {
                return {owned:0, total:0};
            }
            for each (item in collection.habbicons)
            {
                if (item == null || item.state == HabbiconState.REWARD_MARKER || item.habbiconId == collection.rewardHabbiconId)
                {
                    continue;
                }
                total++;
                if (HabbiconState.isUsableState(item.state))
                {
                    owned++;
                }
            }
            return {owned:owned, total:total};
        }

        private function countOwned():int
        {
            var count:int;
            var item:HabbiconOwnedItem;
            for each (item in this._controller.ownedHabbicons)
            {
                if (HabbiconState.isUsableState(item.habbiconState))
                {
                    count++;
                }
            }
            return count;
        }

        private function countTotal():int
        {
            var total:int;
            var collection:HabbiconCollectionData;
            var item:HabbiconShopItem;
            for each (collection in this._controller.shopCollections)
            {
                for each (item in collection.habbicons)
                {
                    if (item != null && item.state != HabbiconState.REWARD_MARKER && item.habbiconId != collection.rewardHabbiconId)
                    {
                        total++;
                    }
                }
            }
            return total;
        }

        private function countCompletedSets():int
        {
            var count:int;
            var collection:HabbiconCollectionData;
            var progress:Object;
            for each (collection in this._controller.shopCollections)
            {
                progress = this.getCollectionProgress(collection);
                if (progress.total > 0 && progress.owned >= progress.total)
                {
                    count++;
                }
            }
            return count;
        }

        private function updateOverallProgress():void
        {
            var owned:int = this.countOwned();
            var total:int = this.countTotal();
            this.setProgress("album_progress_bar", owned, total);
            this.setText("album_progress_text", owned + " / " + total);
        }

        private function setProgress(name:String, value:int, total:int):void
        {
            var container:IWindowContainer = this._window.findChildByName(name) as IWindowContainer;
            this.renderProgress(container, value, total);
        }

        private function setChildProgress(parent:IWindowContainer, name:String, value:int, total:int):void
        {
            var container:IWindowContainer = parent.findChildByName(name) as IWindowContainer;
            this.renderProgress(container, value, total);
        }

        private function renderProgress(container:IWindowContainer, value:int, total:int):void
        {
            var progress:IWindow;
            var fill:IWindow;
            var highlight:IWindow;
            var progressWidth:int;
            var cappedWidth:int;
            if (container == null)
            {
                return;
            }
            progress = container.findChildByName("progress");
            if (progress != null)
            {
                progressWidth = total <= 0 ? 0 : Math.max(0, Math.min(container.width, Math.round(container.width * value / total)));
                cappedWidth = progressWidth >= container.width - 4 ? container.width : progressWidth + 4;
                progress.width = progressWidth;
                progress.visible = progressWidth > 0;
                fill = (progress as IWindowContainer).findChildByName("fill");
                if (fill != null)
                {
                    fill.width = Math.max(0, cappedWidth);
                    fill.color = total > 0 && value >= total ? PROGRESS_COMPLETE_COLOR : PROGRESS_INCOMPLETE_COLOR;
                }
                highlight = (progress as IWindowContainer).findChildByName("highlight");
                if (highlight != null)
                {
                    highlight.width = Math.max(0, cappedWidth - 2);
                }
                container.invalidate();
            }
        }

        private function setText(name:String, text:String):void
        {
            var field:ITextWindow = this._window.findChildByName(name) as ITextWindow;
            if (field != null)
            {
                field.text = text;
            }
        }

        private function setChildText(parent:IWindowContainer, name:String, text:String):void
        {
            var field:ITextWindow = parent.findChildByName(name) as ITextWindow;
            if (field != null)
            {
                field.text = text;
            }
        }

        private function setBitmap(name:String, bitmap:BitmapData):void
        {
            var bitmapWindow:IBitmapWrapperWindow = this._window.findChildByName(name) as IBitmapWrapperWindow;
            this.applyBitmap(bitmapWindow, bitmap);
        }

        private function setChildBitmap(parent:IWindowContainer, name:String, bitmap:BitmapData, colorTransform:ColorTransform = null):void
        {
            var bitmapWindow:IBitmapWrapperWindow = parent.findChildByName(name) as IBitmapWrapperWindow;
            this.applyBitmap(bitmapWindow, bitmap, colorTransform);
        }

        private function applyBitmap(bitmapWindow:IBitmapWrapperWindow, bitmap:BitmapData, colorTransform:ColorTransform = null):void
        {
            var copy:BitmapData;
            if (bitmapWindow == null)
            {
                return;
            }
            if (bitmap == null)
            {
                bitmapWindow.bitmap = new BitmapData(Math.max(1, bitmapWindow.width), Math.max(1, bitmapWindow.height), true, 0);
                bitmapWindow.invalidate();
                HabbiconAssetManager.addEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onAssetsLoaded);
                return;
            }
            bitmapWindow.bitmap = new BitmapData(bitmapWindow.width, bitmapWindow.height, true, 0);
            copy = bitmap;
            if (colorTransform != null)
            {
                copy = bitmap.clone();
                copy.colorTransform(copy.rect, colorTransform);
            }
            bitmapWindow.bitmap.copyPixels(copy, copy.rect, new Point((bitmapWindow.width - copy.width) / 2, (bitmapWindow.height - copy.height) / 2), null, null, true);
            if (copy != bitmap)
            {
                copy.dispose();
            }
            bitmapWindow.invalidate();
        }

        private function setChildVisible(parent:IWindowContainer, name:String, visible:Boolean):void
        {
            var child:IWindow = parent.findChildByName(name);
            if (child != null)
            {
                child.visible = visible;
            }
        }

        private function setProcedure(name:String, callback:Function):void
        {
            var window:IWindow = this._window.findChildByName(name);
            if (window != null)
            {
                window.procedure = callback;
            }
        }

        private function setProcedureByTag(tag:String, callback:Function):void
        {
            var window:IWindow = this._window.findChildByTag(tag);
            if (window != null)
            {
                window.procedure = callback;
            }
        }

        private function tintRow(row:IWindowContainer, active:Boolean):void
        {
            var background:IWindow = row.findChildByName("set_row_background");
            row.color = active ? 0xFFFFFFFF : 0xFFF2ECD5;
            if (background != null)
            {
                background.color = active ? 0xFFF0CF86 : 0xFFF8EBD6;
            }
        }

        private function tintTile(tile:IWindowContainer, owned:Boolean, active:Boolean):void
        {
            var background:IWindow = tile.findChildByName("tile_background");
            var border:IWindow = tile.findChildByName("tile_border");
            if (background != null)
            {
                background.color = owned ? (active ? 0xFFD4E4B9 : 0xFFC3D3A7) : (active ? 0xFFEBDFCB : 0xFFE0D6C2);
            }
            if (border != null)
            {
                border.color = owned ? (active ? 0xFFD3E8BD : 0xFF99C176) : (active ? 0xFFEADFCD : 0xFFD4C6AD);
            }
        }

        private function getCollectionRailIcon(collection:HabbiconCollectionData):BitmapData
        {
            var item:HabbiconShopItem;
            if (collection != null)
            {
                for each (item in collection.habbicons)
                {
                    if (item != null && item.state != HabbiconState.REWARD_MARKER && item.habbiconId != collection.rewardHabbiconId)
                    {
                        return HabbiconAssetManager.getPreviewBitmap(item.habbiconId, false);
                    }
                }
            }
            return HabbiconAssetManager.getCollectionIconBitmap(collection == null ? 0 : collection.collectionId);
        }

        private function isUnownedTileState(state:int):Boolean
        {
            return state == HabbiconState.NONE || state == HabbiconState.LOCKED;
        }

        private function collectionName(collection:HabbiconCollectionData):String
        {
            var key:String = "habbicon_collection_" + collection.name.toLowerCase().split(" ").join("_") + "_name";
            return this._controller.localize(key, collection.name);
        }

        private function collectionDescription(collection:HabbiconCollectionData):String
        {
            var key:String = "habbicon_collection_" + collection.name.toLowerCase().split(" ").join("_") + "_description";
            return this._controller.localize(key, "");
        }

        private function formatPrice(credits:int, points:int):String
        {
            if (credits > 0 && points > 0)
            {
                return credits + " + " + points;
            }
            if (credits > 0)
            {
                return credits.toString();
            }
            return points.toString();
        }

        private function onControllerUpdated(event:HabbiconControllerEvent):void
        {
            this.refresh();
        }

        private function onAssetsLoaded(event:Event):void
        {
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onAssetsLoaded);
            this.refresh();
        }

        private function onClose(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK && this._window != null)
            {
                this._window.visible = false;
            }
        }
    }
}
