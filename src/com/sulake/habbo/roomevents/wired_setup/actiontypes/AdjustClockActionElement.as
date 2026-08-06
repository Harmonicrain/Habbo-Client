package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValuePulses;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July action 38: adjust a counter by minutes and half-second pulses. */
    public class AdjustClockActionElement extends DefaultElement
    {
        private var _seconds:SliderSection;
        private var _minutes:SliderSection;
        private var _operator:RadioGroupPreset;

        override public function get code():int { return ActionTypeCodes.ADJUST_CLOCK; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._seconds = manager.createSliderSection(
                "wiredfurni.params.clock_seconds", "seconds",
                new SliderValuePulses(), 0, 119, 1, false);
            this._minutes = manager.createSliderSection(
                "wiredfurni.params.clock_minutes", "minutes",
                new SliderValueEcho(), 0, 99, 1, false);
            this._operator = manager.createRadioGroup([
                new RadioButtonParam(0, l("operator.0")),
                new RadioButtonParam(1, l("operator.1")),
                new RadioButtonParam(2, l("operator.2"))
            ]);
            builder.addElements(
                manager.createSection(l("choose_type"), this._operator),
                this._minutes, this._seconds);
        }

        override public function onEditStart(data:Triggerable):void
        {
            var halfSeconds:int = data.intData.length > 0 ? int(data.intData[0]) : 0;
            var minutes:int = data.intData.length > 1 ? int(data.intData[1]) : 0;
            var remainder:int = data.intData.length > 2 ? int(data.intData[2]) : 0;
            this._seconds.value = halfSeconds * 2 + remainder;
            this._minutes.value = minutes;
            this._operator.selected = data.intData.length > 3 ? int(data.intData[3]) : 0;
        }

        override public function readIntParamsFromForm():Array
        {
            var seconds:int = this._seconds.value;
            return [Math.floor(seconds / 2), this._minutes.value, seconds % 2,
                this._operator.selected];
        }
    }
}
