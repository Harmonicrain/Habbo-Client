package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class TimeElapsedConditionElement extends DefaultElement
    {
        private var _code:int;
        private var _section:String;
        private var _slider:SliderSection;

        public function TimeElapsedConditionElement(_arg_1:int, _arg_2:String)
        {
            super();
            this._code = _arg_1;
            this._section = _arg_2;
        }

        override public function get code():int
        {
            return this._code;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._slider = _arg_1.createSliderSection(this._section, "seconds", SliderSection.CONVERTER_PULSES, 1, 1200, 1);
            _arg_3.addElements(this._slider);
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._slider.value + 1];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._slider.value = (_arg_1.intData.length > 0) ? (_arg_1.intData[0] - 1) : 1;
        }
    }
}
