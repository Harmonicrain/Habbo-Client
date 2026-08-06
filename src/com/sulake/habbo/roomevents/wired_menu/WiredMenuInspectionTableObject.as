package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

    /** One live variable row in the July Inspection table. */
    public final class WiredMenuInspectionTableObject implements ITableObject
    {
        private var _variable:WiredVariable;
        private var _value:int;
        private var _canModify:Boolean;
        private var _highlightChanges:Boolean;
        private var _roomEvents:HabboUserDefinedRoomEvents;

        public function WiredMenuInspectionTableObject(
            variable:WiredVariable,
            value:int,
            canModify:Boolean,
            highlightChanges:Boolean,
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._variable = variable;
            this._value = value;
            this._canModify = canModify;
            this._highlightChanges = highlightChanges;
            this._roomEvents = roomEvents;
        }

        public function get identifier():String
        {
            return this._variable.variableId;
        }

        public function get variable():WiredVariable
        {
            return this._variable;
        }

        public function get value():int
        {
            return this._value;
        }

        public function get canModify():Boolean
        {
            return this._canModify;
        }

        public function getTableCell(columnId:String):TableCell
        {
            if (columnId == "variable")
            {
                return new TableCell(TableCell.TYPE_TEXT,
                    this._variable.variableName, false, true,
                    this._variable.variableName);
            }
            if (columnId == "value")
            {
                return this.createValueCell();
            }
            return new TableCell(TableCell.TYPE_TEXT, "");
        }

        public function isPropertyUpdated(columnId:String,
                                          previous:Object):Boolean
        {
            var old:WiredMenuInspectionTableObject =
                previous as WiredMenuInspectionTableObject;
            if (old == null)
            {
                return true;
            }
            if (columnId == "variable")
            {
                return this._variable.variableName !=
                    old._variable.variableName;
            }
            if (columnId == "value")
            {
                return this._canModify != old._canModify
                    || this._variable.hasValue != old._variable.hasValue
                    || (this._variable.hasValue
                        && (this._value != old._value
                            || this.connectedText() != old.connectedText()));
            }
            return false;
        }

        public function isUpdated(previous:Object):Boolean
        {
            return this.isPropertyUpdated("variable", previous)
                || this.isPropertyUpdated("value", previous);
        }

        private function createValueCell():TableCell
        {
            if (!this._variable.hasValue)
            {
                return new TableCell(TableCell.TYPE_TEXT, "");
            }
            if (this._value == 2147483647
                || this._value == -2147483648)
            {
                return new TableCell(TableCell.TYPE_TEXT,
                    this.loc("wiredmenu.inspection.flash_restriction.text"),
                    false, false, null, null, false,
                    this.loc("wiredmenu.inspection.flash_restriction.desc"),
                    16734003);
            }
            var connected:String = this.connectedText();
            var display:String = String(this._value)
                + (connected == null ? "" : " (" + connected + ")");
            return new TableCell(TableCell.TYPE_TEXT, display,
                this._variable.canWriteValue && this._canModify, true,
                String(this._value), null, this._highlightChanges);
        }

        private function connectedText():String
        {
            if (!this._variable.hasTextConnector
                || this._variable.textConnector == null)
            {
                return null;
            }
            var value:Object =
                this._variable.textConnector.getValue(this._value);
            return value == null ? null : String(value);
        }

        private function loc(key:String):String
        {
            return this._roomEvents.localization.getLocalization(key, key);
        }
    }
}
