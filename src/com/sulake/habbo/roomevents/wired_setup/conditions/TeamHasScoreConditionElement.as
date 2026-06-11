package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class TeamHasScoreConditionElement extends DefaultElement
    {
        private var _team:RadioGroupPreset;
        private var _operator:RadioGroupPreset;
        private var _score:SliderSection;

        override public function get code():int { return ConditionCodes.TEAM_HAS_SCORE; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._team = _arg_1.createRadioGroup([new RadioButtonParam(0, l("team.triggerer"), null, null, true), new RadioButtonParam(1, l("team.1")), new RadioButtonParam(2, l("team.2")), new RadioButtonParam(3, l("team.3")), new RadioButtonParam(4, l("team.4"))], null, 2);
            this._operator = _arg_1.createRadioGroup([new RadioButtonParam(0, l("comparison.0")), new RadioButtonParam(1, l("comparison.1")), new RadioButtonParam(2, l("comparison.2"))]);
            this._score = _arg_1.createSliderSection("wiredfurni.params.setscore2", "points", new SliderValueEcho(), 0, 1000, 1);
            _arg_3.addElements(_arg_1.createSection(l("team"), this._team), _arg_1.createSection(l("comparison_selection"), this._operator), this._score);
        }

        override public function readIntParamsFromForm():Array { return [this._team.selected, this._score.value, this._operator.selected]; }
        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._team.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
            this._score.value = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 1;
            this._operator.selected = (_arg_1.intData.length > 2) ? _arg_1.intData[2] : 0;
        }
    }
}
