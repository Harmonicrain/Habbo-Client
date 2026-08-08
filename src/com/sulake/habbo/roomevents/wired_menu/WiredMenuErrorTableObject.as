package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

    /** One official July Monitor diagnostic row. */
    public final class WiredMenuErrorTableObject implements ITableObject
    {
        private var _error:Object;
        private var _latest:String;
        private var _openCallback:Function;

        public function WiredMenuErrorTableObject(
            error:Object, latest:String, openCallback:Function)
        {
            this._error = error;
            this._latest = latest;
            this._openCallback = openCallback;
        }

        public function get identifier():String
        {
            return String(this._error.id);
        }

        public function get data():Object
        {
            return this._error;
        }

        public function getTableCell(columnId:String):TableCell
        {
            switch (columnId)
            {
                case "name":
                    return new TableCell(TableCell.TYPE_LINK,
                        String(this._error.name), false, false, null,
                        this.open);
                case "category":
                    return new TableCell(TableCell.TYPE_TEXT,
                        String(this._error.category));
                case "count":
                    return new TableCell(TableCell.TYPE_TEXT,
                        String(this._error.count));
                case "latest":
                    return new TableCell(TableCell.TYPE_TEXT, this._latest);
            }
            return new TableCell(TableCell.TYPE_TEXT, "");
        }

        public function isPropertyUpdated(columnId:String,
                                          previous:Object):Boolean
        {
            var old:WiredMenuErrorTableObject =
                previous as WiredMenuErrorTableObject;
            if (old == null)
            {
                return true;
            }
            switch (columnId)
            {
                case "name":
                    return String(this._error.name)
                        != String(old._error.name);
                case "category":
                    return String(this._error.category)
                        != String(old._error.category);
                case "count":
                    return int(this._error.count) != int(old._error.count);
                case "latest":
                    return this._latest != old._latest;
            }
            return false;
        }

        public function isUpdated(previous:Object):Boolean
        {
            return this.isPropertyUpdated("name", previous)
                || this.isPropertyUpdated("category", previous)
                || this.isPropertyUpdated("count", previous)
                || this.isPropertyUpdated("latest", previous);
        }

        private function open():void
        {
            if (this._openCallback != null)
            {
                this._openCallback(this._error);
            }
        }
    }
}
