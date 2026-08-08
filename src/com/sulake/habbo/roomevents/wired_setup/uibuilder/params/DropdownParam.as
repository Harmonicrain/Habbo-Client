package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;

    public class DropdownParam
    {
        private var _caption:String;
        private var _options:Vector.<ExpandableDropdownOption>;
        private var _showMoreLocalization:String;
        private var _onChangeCallback:Function;

        public function DropdownParam(_arg_1:String, _arg_2:Vector.<ExpandableDropdownOption> = null, _arg_3:Function = null, _arg_4:String = "")
        {
            super();
            this._caption = _arg_1;
            this._options = _arg_2;
            this._onChangeCallback = _arg_3;
            this._showMoreLocalization = _arg_4;
        }

        public function get onChangeCallback():Function { return this._onChangeCallback; }
        public function get caption():String { return this._caption; }
        public function get options():Vector.<ExpandableDropdownOption> { return this._options; }
        public function get showMoreLocalization():String { return this._showMoreLocalization; }
    }
}
