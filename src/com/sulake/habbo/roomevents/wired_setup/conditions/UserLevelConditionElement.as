package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class UserLevelConditionElement extends DefaultElement
    {
        private var _level:SliderSection;
        private var _comparison:RadioGroupPreset;

        override public function get code():int { return ConditionCodes.USER_LEVEL; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._level = manager.createSliderSection(
                "wiredfurni.params.level_selection", "level",
                new SliderValueEcho(), 1, 30, 1);
            this._level.value = 1;
            this._comparison = manager.createRadioGroup([
                new RadioButtonParam(0, l("comparison.0")),
                new RadioButtonParam(1, l("comparison.1")),
                new RadioButtonParam(2, l("comparison.2"))
            ]);
            builder.addElements(this._level,
                manager.createSection(l("comparison_selection"), this._comparison));
        }

        override public function onEditStart(data:Triggerable):void
        {
            this._level.value = data.intData.length > 0 ? int(data.intData[0]) : 1;
            this._comparison.selected = data.intData.length > 1 ? int(data.intData[1]) : 0;
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._level.value, this._comparison.selected];
        }
    }
}
