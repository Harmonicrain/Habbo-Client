package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
{
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedTextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.itemtable.ItemTypeTableObject;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;

    public class ItemTypeSelectionPreset extends WiredUIPreset
    {
        public static const COL_FURNI_CODE:String = "furni_code";
        public static const COL_FURNI_NAME:String = "furni_name";
        public static const COL_FURNI_TYPE:String = "furni_type";

        private static const POSTER_IDS:Array = [
            1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
            21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,
            41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,83,
            500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,
            515,516,517,518,520,521,522,523,1000,1001,1002,1003,1004,
            1005,1006,2000,2001,2002,2003,2004,2005,2006,2007,2008
        ];

        private var _list:IItemListWindow;
        private var _allFurnis:Vector.<ItemTypeTableObject>;
        private var _codeInput:NamedTextInputPreset;
        private var _searchInput:NamedTextInputPreset;
        private var _tableContainer:IWindowContainer;
        private var _table:TableView;
        private var _showCount:TextPreset;
        private var _selectedItem:ChestItemType;
        private var _ignoreListeners:Boolean;
        private var _showingAll:Boolean;
        private var _listeners:Array = [];

        public function ItemTypeSelectionPreset(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle)
        {
            super(roomEvents, presetManager, style);
            this._list = presetManager.createLayout("vertical_list_view") as IItemListWindow;
            this._list.spacing = style.genericVerticalSpacing;
            this.createAllFurnis();
            this._codeInput = presetManager.createNamedTextInput(
                new TextInputParam("", -1,
                    "${wiredcontracts.element.itemtype.furni_code.placeholder}",
                    150, null, false),
                "${wiredcontracts.element.itemtype.furni_code}");
            this._searchInput = presetManager.createNamedTextInput(
                new TextInputParam("", 220, "", 150),
                "${wiredcontracts.element.itemtype.search}");
            this._tableContainer = presetManager.createLayout("container_view") as IWindowContainer;
            this._tableContainer.width = 350;
            this._tableContainer.height = 234;
            this._showCount = presetManager.createText("-", new TextParam(1));
            this._showCount.halfBlend();
            this._list.addListItem(this._codeInput.window);
            this._list.addListItem(this._searchInput.window);
            this._list.addListItem(this._tableContainer);
            this._list.addListItem(this._showCount.window);
            this._searchInput.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE,
                this.onSearchChanged);
            this.createTableView();
            this.refreshShowCount();
        }

        private function refreshShowCount():void
        {
            this._showCount.text = this.localizations.getLocalizationWithParams(
                "wiredcontracts.element.show_count", "", "amount", this._table.rowCount);
        }

        private function createAllFurnis():void
        {
            this._allFurnis = new Vector.<ItemTypeTableObject>();
            var sessionData:ISessionDataManager = this._roomEvents.sessionDataManager;
            var item:IFurnitureData;
            var code:String;
            var name:String;
            for each (item in sessionData.getAllFloorItemDatas())
            {
                code = item.fullName;
                if (code == "") continue;
                name = item.localizedName == "" ? code : item.localizedName;
                this._allFurnis.push(new ItemTypeTableObject(
                    new ChestItemType(false, item.id, null), name, code));
            }

            var posterTypeId:int = -1;
            for each (item in sessionData.getAllWallItemDatas())
            {
                code = item.fullName;
                if (code == "") continue;
                if (item.className == "poster")
                {
                    posterTypeId = item.id;
                    continue;
                }
                name = item.localizedName == "" ? code : item.localizedName;
                this._allFurnis.push(new ItemTypeTableObject(
                    new ChestItemType(true, item.id, null), name, code));
            }

            if (posterTypeId != -1)
            {
                for each (var posterId:int in POSTER_IDS)
                {
                    code = "poster*" + posterId;
                    var key:String = "poster_" + posterId + "_name";
                    name = this._roomEvents.localization.getLocalization(key, key);
                    this._allFurnis.push(new ItemTypeTableObject(
                        new ChestItemType(true, posterTypeId, String(posterId)),
                        name, code));
                }
            }
            this._allFurnis.sort(function(a:ItemTypeTableObject,
                b:ItemTypeTableObject):int
            {
                return a.localizedName.localeCompare(b.localizedName);
            });
        }

        private function createTableView():void
        {
            var tableAsset:XmlAsset = this._roomEvents.assets
                .getAssetByName("table_view_xml") as XmlAsset;
            this._table = new TableView(this._roomEvents.windowManager,
                this._tableContainer, false, false, tableAsset);
            var columns:Array = [
                new TableColumn(COL_FURNI_NAME,
                    "${wiredcontracts.element.itemtype.col.furni_name}", 0.5, "left"),
                new TableColumn(COL_FURNI_CODE,
                    "${wiredcontracts.element.itemtype.col.furni_code}", 0.3, "left"),
                new TableColumn(COL_FURNI_TYPE,
                    "${wiredcontracts.element.itemtype.col.furni_type}", 0.2, "left")
            ];
            this._table.initialize(Vector.<TableColumn>(columns), true, true);
            this._table.onRowClickedCallback = this.onListItemClicked;
            this._table.setObjects(Vector.<ITableObject>(this._allFurnis));
            this._showingAll = true;
        }

        private function onListItemClicked(value:ItemTypeTableObject):void
        {
            if (value != null) this.selectedItem = value.chestItemType;
        }

        public function get selectedItem():ChestItemType { return this._selectedItem; }

        public function get furniDataForSelectedItem():IFurnitureData
        {
            if (this._selectedItem == null) return null;
            var sessionData:ISessionDataManager = this._roomEvents.sessionDataManager;
            return this._selectedItem.isWallItem
                ? sessionData.getWallItemData(this._selectedItem.typeId)
                : sessionData.getFloorItemData(this._selectedItem.typeId);
        }

        public function resetInteractions():void
        {
            this._ignoreListeners = true;
            this._searchInput.text = "";
            this._ignoreListeners = false;
            this.updateFilters(true);
        }

        private function onSearchChanged(event:WindowEvent):void
        {
            if (!this._ignoreListeners) this.updateFilters(false);
        }

        private function updateFilters(resetScroll:Boolean):void
        {
            var query:String = this._searchInput.text.toLowerCase();
            var objects:Vector.<ItemTypeTableObject>;
            if (query.length < 2)
            {
                if (this._showingAll && !resetScroll) return;
                objects = this._allFurnis;
                this._showingAll = true;
            }
            else
            {
                objects = new Vector.<ItemTypeTableObject>();
                var terms:Array = query.split(" ");
                for each (var item:ItemTypeTableObject in this._allFurnis)
                {
                    var matches:Boolean = true;
                    for each (var term:String in terms)
                    {
                        if (term.length > 0 && !item.matchesSubstring(term))
                        {
                            matches = false;
                            break;
                        }
                    }
                    if (matches) objects.push(item);
                }
                this._showingAll = false;
            }
            this._table.setObjects(Vector.<ITableObject>(objects), resetScroll);
            this.refreshShowCount();
        }

        public function set selectedItem(value:ChestItemType):void
        {
            this._selectedItem = value;
            this.notifyListeners(value);
            if (value == null)
            {
                this._codeInput.text = "";
                return;
            }
            var data:IFurnitureData = value.isWallItem
                ? this._roomEvents.sessionDataManager.getWallItemData(value.typeId)
                : this._roomEvents.sessionDataManager.getFloorItemData(value.typeId);
            if (data == null)
            {
                this._selectedItem = null;
                this._codeInput.text = "";
                this.notifyListeners(null);
                return;
            }
            this._codeInput.text =
                value.isWallItem && data.className == "poster"
                    ? "poster*" + value.legacyPosterId : data.fullName;
        }

        public function addListener(listener:Function):void { this._listeners.push(listener); }
        private function notifyListeners(value:ChestItemType):void
        {
            for each (var listener:Function in this._listeners) listener(value);
        }

        override public function get window():IWindow { return this._list; }
        override public function resizeToWidth(width:int):void
        {
            super.resizeToWidth(width);
            this._list.width = width;
            this._codeInput.resizeToWidth(width);
            this._searchInput.resizeToWidth(width);
            this._showCount.resizeToWidth(width);
            if (this._tableContainer.width != width)
            {
                this._tableContainer.width = width;
                this._table.resizeHorizontally();
            }
        }

        override protected function get childPresets():Array
        {
            return [this._codeInput, this._searchInput, this._showCount];
        }

        override public function dispose():void
        {
            if (disposed) return;
            if (this._table != null) this._table.dispose();
            this._table = null;
            super.dispose();
            this._list.dispose();
            this._list = null;
            this._allFurnis = null;
            this._codeInput = null;
            this._searchInput = null;
            this._tableContainer = null;
            this._showCount = null;
            this._selectedItem = null;
            this._listeners = null;
        }
    }
}
