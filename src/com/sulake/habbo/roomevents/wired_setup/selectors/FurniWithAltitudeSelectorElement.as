package com.sulake.habbo.roomevents.wired_setup.selectors
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueHundredth;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class FurniWithAltitudeSelectorElement extends DefaultElement
    {
        private var _height:SliderSection;
        private var _operator:RadioGroupPreset;

        override public function get code():int { return SelectorCodes.FURNI_WITH_ALTITUDE; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(k:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._operator = k.createRadioGroup([new RadioButtonParam(0, l("comparison.0")), new RadioButtonParam(1, l("comparison.1")), new RadioButtonParam(2, l("comparison.2"))]);
            this._height = k.createSliderSection("wiredfurni.params.setaltitude", "altitude", new SliderValueHundredth(), 0, 8000, 1);
            _arg_3.addElements(k.createSection(l("comparison_selection"), this._operator), this._height);
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._height.value, this._operator.selected];
        }

        override public function onEditStart(k:Triggerable):void
        {
            this._height.value = (k.intData.length > 0) ? k.intData[0] : 0;
            this._operator.selected = (k.intData.length > 1) ? k.intData[1] : 0;
        }
    }
}
