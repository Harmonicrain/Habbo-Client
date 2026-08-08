package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class NumberConditionElement extends DefaultElement
    {
        private var _code:int;
        private var _negativeCode:int;
        private var _section:String;
        private var _input:NumberInputPreset;

        public function NumberConditionElement(_arg_1:int, _arg_2:int, _arg_3:String)
        {
            super();
            this._code = _arg_1;
            this._negativeCode = _arg_2;
            this._section = _arg_3;
        }

        override public function get code():int
        {
            return this._code;
        }

        override public function get negativeCode():int
        {
            return this._negativeCode;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._input = _arg_1.createNumberInput(new NumberInputParam(0, 0, 99999));
            _arg_3.addElements(_arg_1.createSection(this._section, this._input));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._input.value];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._input.value = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
        }
    }
}
