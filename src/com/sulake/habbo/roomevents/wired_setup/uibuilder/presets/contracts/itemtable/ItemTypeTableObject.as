package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.itemtable
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

    public class ItemTypeTableObject implements ITableObject
    {
        private var _chestItemType:ChestItemType;
        private var _localizedName:String;
        private var _lowerName:String;
        private var _displayCode:String;

        public function ItemTypeTableObject(chestItemType:ChestItemType,
            localizedName:String, displayCode:String)
        {
            this._chestItemType = chestItemType;
            this._localizedName = localizedName;
            this._displayCode = displayCode;
            this._lowerName = localizedName.toLowerCase();
        }

        public function get identifier():String
        {
            return (this._chestItemType.isWallItem ? "1-" : "0-") + this._displayCode;
        }

        public function getTableCell(columnId:String):TableCell
        {
            switch (columnId)
            {
                case "furni_name":
                    return new TableCell(TableCell.TYPE_TEXT, this._localizedName, false, true);
                case "furni_code":
                    return new TableCell(TableCell.TYPE_TEXT, this._displayCode, false, true);
                case "furni_type":
                    return new TableCell(TableCell.TYPE_TEXT,
                        this._chestItemType.isWallItem
                            ? "${inventory.filter.placement.wall}"
                            : "${inventory.filter.placement.floor}");
            }
            return null;
        }

        public function isPropertyUpdated(columnId:String, previous:Object):Boolean { return false; }
        public function isUpdated(previous:Object):Boolean { return false; }
        public function get chestItemType():ChestItemType { return this._chestItemType; }
        public function get localizedName():String { return this._localizedName; }
        public function get displayCode():String { return this._displayCode; }
        public function matchesSubstring(value:String):Boolean
        {
            return this._lowerName.indexOf(value) != -1 ||
                this._displayCode.toLowerCase().indexOf(value) != -1;
        }
    }
}
