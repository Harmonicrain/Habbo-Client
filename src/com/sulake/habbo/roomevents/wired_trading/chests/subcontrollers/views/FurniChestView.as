package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IScrollableGridWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestStorage;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.FurniChestSubController;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.window.widgets.ProductImageWidget;
    import __AS3__.vec.Vector;

    public class FurniChestView implements IDisposable
    {
        private static const SEARCH_THRESHOLD:int = 31;
        private static const SEARCH_OFFSET:int = 28;
        private var _disposed:Boolean;
        private var _controller:FurniChestSubController;
        private var _container:IWindowContainer;
        private var _itemTemplate:IRegionWindow;
        private var _groupedViews:Map;
        private var _storageViews:Map;
        private var _selected:FurniChestItemView;
        private var _views:Vector.<FurniChestItemView>;
        private var _search:String = "";

        public function FurniChestView(controller:FurniChestSubController)
        {
            this._controller = controller;
            this._container = this.roomEvents.getXmlWindow("furni_chest_contents")
                as IWindowContainer;
            if (this._container != null && this._container.parent != null)
            {
                this._container.parent = null;
            }
            this._itemTemplate = this.itemGrid.removeGridItemAt(0) as IRegionWindow;
            this._groupedViews = new Map();
            this._storageViews = new Map();
            this._views = new Vector.<FurniChestItemView>();
            this.withdrawInput.restrict = "0-9";
            this.withdrawButton.addEventListener("WME_CLICK", this.onWithdrawClick);
            this.viewLogsButton.addEventListener("WME_CLICK", this.onViewLogsClick);
            this.searchInput.addEventListener("WE_CHANGE", this.onSearchChanged);
            this.searchInput.addEventListener("WKE_KEY_DOWN", this.onSearchKeyDown);
            this.searchClearButton.addEventListener("WME_CLICK", this.onClearSearch);
        }
        public static function itemTypeKey(type:ChestItemType):String
        {
            return (type.isWallItem ? "1" : "0") + "-" + type.typeId + "-"
                + type.legacyPosterId;
        }
        public static function getStorageName(storage:ChestStorage,
            localization:IHabboLocalizationManager, session:ISessionDataManager):String
        {
            var data:IFurnitureData;
            if (storage.type.isWallItem)
            {
                if (storage.specialType == 6 && storage.type.legacyPosterId != "")
                {
                    return localization.getLocalization("poster_"
                        + storage.type.legacyPosterId + "_name");
                }
                data = session.getWallItemData(storage.type.typeId);
            }
            else
            {
                data = session.getFloorItemData(storage.type.typeId);
            }
            return data == null ? "(missing item name)" : data.localizedName;
        }
        private function onWithdrawClick(event:WindowMouseEvent):void
        {
            var amount:Number = parseInt(this.withdrawInput.text);
            if (!isNaN(amount) && amount > 0 && this._selected != null
                && this._selected.peek() != null)
            {
                this._controller.withdrawItemsWithType(this._selected.peek().type, int(amount));
            }
        }
        private function onViewLogsClick(event:WindowMouseEvent):void
        {
            if (this._selected != null && this._selected.peek() != null)
            {
                this._controller.viewLogsWithType(this._selected.peek().type);
            }
        }
        private function onSearchChanged(event:WindowEvent):void
        {
            this.searchPlaceholder.visible = this.searchInput.text.length == 0;
            this.searchClearButton.visible = this.searchInput.text.length > 0;
        }
        private function onSearchKeyDown(event:WindowKeyboardEvent):void
        {
            if (event.keyCode == 13)
            {
                this._search = this.searchInput.text;
                this.updateGrid();
            }
            else if (event.keyCode == 27)
            {
                this.clearSearch();
                this.updateGrid();
            }
        }
        private function onClearSearch(event:WindowMouseEvent):void
        {
            this.clearSearch();
            this.updateGrid();
        }
        private function clearSearch():void
        {
            this.searchInput.text = "";
            this.searchClearButton.visible = false;
            this.searchPlaceholder.visible = true;
            this._search = "";
        }
        public function itemsInitialize(storages:Vector.<ChestStorage>):void
        {
            this.clear();
            for each (var storage:ChestStorage in storages) { this.addStorage(storage); }
            this.updateGrid();
            this.selectFirstIfNeeded();
        }
        public function itemsUpdated(removed:Vector.<ChestStorage>,
            added:Vector.<ChestStorage>):void
        {
            for each (var oldStorage:ChestStorage in removed)
            {
                this.removeStorage(oldStorage);
            }
            for each (var newStorage:ChestStorage in added) { this.addStorage(newStorage); }
            this.updateGrid();
            this.selectFirstIfNeeded();
            this._controller.wrapperView.updateUI();
        }
        private function addStorage(storage:ChestStorage):void
        {
            var groupKey:String = itemTypeKey(storage.type);
            if (storage.stuffData.uniqueSerialNumber > 0)
            {
                groupKey += "-limited-" + storage.inventoryId;
            }
            else if (storage.specialType == 19)
            {
                groupKey += "-rarity-" + storage.stuffData.rarityLevel;
            }
            var view:FurniChestItemView = this._groupedViews.getValue(groupKey);
            if (view == null)
            {
                var group:Vector.<ChestStorage> = new Vector.<ChestStorage>();
                group.push(storage);
                view = new FurniChestItemView(this._itemTemplate);
                view.initialize(this, group);
                this._groupedViews.add(groupKey, view);
                this._views.push(view);
            }
            else
            {
                view.add(storage);
            }
            this._storageViews.add(storage.inventoryId, view);
        }
        private function removeStorage(storage:ChestStorage):void
        {
            var view:FurniChestItemView = this._storageViews.remove(storage.inventoryId)
                as FurniChestItemView;
            if (view == null) { return; }
            view.remove(storage);
            if (view.numItems == 0)
            {
                if (this._selected == view) { this.selectItemView(null); }
                var index:int = this._views.indexOf(view);
                if (index >= 0) { this._views.removeAt(index); }
                var keys:Array = this._groupedViews.getKeys();
                for each (var key:Object in keys)
                {
                    if (this._groupedViews.getValue(key) == view)
                    {
                        this._groupedViews.remove(key);
                        break;
                    }
                }
                view.dispose();
            }
        }
        public function clear():void
        {
            this.itemGrid.removeGridItems();
            for each (var view:FurniChestItemView in this._views) { view.dispose(); }
            this._views = new Vector.<FurniChestItemView>();
            this._groupedViews.reset();
            this._storageViews.reset();
            this.selectItemView(null);
            this.updatePreviewUI();
        }
        public function updateGrid():void
        {
            this.updateSearchVisibility();
            this.itemGrid.removeGridItems();
            var words:Array = this._search.length > 0
                ? this._search.toLowerCase().split(" ") : null;
            for each (var view:FurniChestItemView in this._views)
            {
                if (words != null)
                {
                    var name:String = this.getChestStorageName(view.peek()).toLowerCase();
                    var matches:Boolean = true;
                    for each (var word:String in words)
                    {
                        if (name.indexOf(word) < 0) { matches = false; break; }
                    }
                    if (!matches) { continue; }
                }
                this.itemGrid.addGridItem(view.window);
            }
            this.noItemsText.visible = this.itemGrid.numGridItems == 0;
        }
        private function updateSearchVisibility():void
        {
            if (!this.searchBorder.visible && this._views.length >= SEARCH_THRESHOLD)
            {
                this.searchBorder.visible = true;
                this.clearSearch();
                this.itemGrid.y += SEARCH_OFFSET;
                this.itemGrid.height -= SEARCH_OFFSET;
            }
            else if (this.searchBorder.visible && this._views.length < SEARCH_THRESHOLD)
            {
                this.searchBorder.visible = false;
                this.clearSearch();
                this.itemGrid.y -= SEARCH_OFFSET;
                this.itemGrid.height += SEARCH_OFFSET;
            }
        }
        public function selectItemView(view:FurniChestItemView):void
        {
            if (this._selected != null) { this._selected.deactivate(); }
            this._selected = view;
            if (this._selected != null) { this._selected.activate(); }
            this.updatePreviewUI();
        }
        private function selectFirstIfNeeded():void
        {
            if (this._selected == null && this._views.length > 0)
            {
                this.selectItemView(this._views[0]);
            }
        }
        public function updatePreviewUI():void
        {
            var widget:ProductImageWidget = this.previewWidget.widget as ProductImageWidget;
            if (this._selected == null || this._selected.peek() == null)
            {
                this.previewFurniName.text = "";
                if (widget != null) { widget.clearPreviewer(); }
                this.viewLogsButton.disable();
                this.withdrawButton.disable();
                this.placeholderPreviewImage.visible = true;
                return;
            }
            var storage:ChestStorage = this._selected.peek();
            this.placeholderPreviewImage.visible = false;
            Util.disableSection(this.viewLogsButton, !this._controller.canRead);
            Util.disableSection(this.withdrawButton, !this._controller.canWithdraw);
            this.previewFurniName.text = this.getChestStorageName(storage);
            if (widget != null)
            {
                widget.productInfo = new ChestItemTypeRenderableWrapper(storage.type);
            }
        }
        public function getChestStorageName(storage:ChestStorage):String
        {
            return getStorageName(storage, this._controller.localization,
                this._controller.parentController.sessionDataManager);
        }
        public function updateUI():void { this.updatePreviewUI(); }
        public function get container():IWindowContainer { return this._container; }
        private function get roomEvents():HabboUserDefinedRoomEvents { return this._controller.roomEvents; }
        public function dispose():void
        {
            if (this._disposed) { return; }
            this.clear();
            this._container.dispose();
            this._container = null;
            this._itemTemplate.dispose();
            this._itemTemplate = null;
            this._groupedViews.dispose();
            this._storageViews.dispose();
            this._groupedViews = null;
            this._storageViews = null;
            this._controller = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
        private function get itemGrid():IScrollableGridWindow
        { return this._container.findChildByName("grid_items") as IScrollableGridWindow; }
        private function get searchBorder():IBorderWindow
        { return this._container.findChildByName("search_border") as IBorderWindow; }
        private function get searchPlaceholder():ITextWindow
        { return this._container.findChildByName("search_placeholder") as ITextWindow; }
        private function get searchInput():ITextFieldWindow
        { return this._container.findChildByName("search_input") as ITextFieldWindow; }
        private function get searchClearButton():IRegionWindow
        { return this._container.findChildByName("clear_search_button") as IRegionWindow; }
        private function get noItemsText():ITextWindow
        { return this._container.findChildByName("no_items_text") as ITextWindow; }
        private function get previewFurniName():ITextWindow
        { return this._container.findChildByName("furni_name") as ITextWindow; }
        private function get previewWidget():IWidgetWindow
        { return this._container.findChildByName("preview_image") as IWidgetWindow; }
        private function get placeholderPreviewImage():IStaticBitmapWrapperWindow
        { return this._container.findChildByName("placeholder_preview_image") as IStaticBitmapWrapperWindow; }
        private function get withdrawInput():ITextFieldWindow
        { return this._container.findChildByName("withdraw_input") as ITextFieldWindow; }
        private function get withdrawButton():IButtonWindow
        { return this._container.findChildByName("withdraw_btn") as IButtonWindow; }
        private function get viewLogsButton():IButtonWindow
        { return this._container.findChildByName("view_logs_by_furni_btn") as IButtonWindow; }
    }
}
