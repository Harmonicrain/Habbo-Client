package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

    /**
     * Small typed adapter for July menu data displayed by the clean client's
     * existing TableView. Packet strings remain text and are never parsed as XML.
     */
    public final class WiredMenuTableObject implements ITableObject
    {
        private var _identifier:String;
        private var _cells:Object;
        private var _data:Object;

        public function WiredMenuTableObject(identifier:String, cells:Object,
                                             data:Object=null)
        {
            this._identifier = identifier;
            this._cells = cells == null ? {} : cells;
            this._data = data;
        }

        public function get identifier():String
        {
            return this._identifier;
        }

        public function get data():Object
        {
            return this._data;
        }

        public function getTableCell(columnId:String):TableCell
        {
            var value:Object = this._cells[columnId];
            if (value is TableCell)
            {
                return value as TableCell;
            }
            return new TableCell(TableCell.TYPE_TEXT,
                value == null ? "" : String(value));
        }

        public function isPropertyUpdated(columnId:String,
                                          previous:Object):Boolean
        {
            var old:WiredMenuTableObject = previous as WiredMenuTableObject;
            return old == null ||
                String(this._cells[columnId]) != String(old._cells[columnId]);
        }

        public function isUpdated(previous:Object):Boolean
        {
            var old:WiredMenuTableObject = previous as WiredMenuTableObject;
            if (old == null)
            {
                return true;
            }
            for (var key:String in this._cells)
            {
                if (this.isPropertyUpdated(key, old))
                {
                    return true;
                }
            }
            return false;
        }
    }
}
