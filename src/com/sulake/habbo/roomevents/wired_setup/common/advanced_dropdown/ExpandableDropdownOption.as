package com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown
{
    public class ExpandableDropdownOption
    {
        private var _id:int;
        private var _displayString:String;
        private var _isAdvanced:Boolean;

        public function ExpandableDropdownOption(_arg_1:int, _arg_2:String, _arg_3:Boolean = false)
        {
            super();
            this._id = _arg_1;
            this._displayString = _arg_2;
            this._isAdvanced = _arg_3;
        }

        public function get id():int { return this._id; }
        public function get displayString():String { return this._displayString; }
        public function get isAdvanced():Boolean { return this._isAdvanced; }
    }
}
