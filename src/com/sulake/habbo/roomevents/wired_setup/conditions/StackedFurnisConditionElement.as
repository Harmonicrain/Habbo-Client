package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class StackedFurnisConditionElement extends DefaultElement
    {
        private var _code:int;
        private var _negativeCode:int;
        private var _section:String;
        private var _optionPrefix:String;
        private var _eval:RadioGroupPreset;

        public function StackedFurnisConditionElement(_arg_1:int = 7, _arg_2:int = -1, _arg_3:String = "requireall", _arg_4:String = "requireall")
        {
            super();
            this._code = _arg_1;
            this._negativeCode = _arg_2;
            this._section = _arg_3;
            this._optionPrefix = _arg_4;
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

        override public function get requiresFurniSelection():Boolean
        {
            return true;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._eval = _arg_1.createRadioGroup([new RadioButtonParam(0, l(this._optionPrefix + ".0")), new RadioButtonParam(1, l(this._optionPrefix + ".1"))]);
            _arg_3.addElements(_arg_1.createSection(l(this._section), this._eval));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._eval.selected];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._eval.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
        }
    }
}
