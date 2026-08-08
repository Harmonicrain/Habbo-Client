package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueCountOrUnlimited;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class ScoreActionElement extends DefaultElement
    {
        private var _code:int;
        private var _includeTeam:Boolean;
        private var _score:SliderSection;
        private var _times:SliderSection;
        private var _operation:RadioGroupPreset;
        private var _team:RadioGroupPreset;

        public function ScoreActionElement(_arg_1:int, _arg_2:Boolean = false)
        {
            super();
            this._code = _arg_1;
            this._includeTeam = _arg_2;
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
            this._score = _arg_1.createSliderSection("wiredfurni.params.setpoints2", "", new SliderValueEcho(), 1, 1000, 1);
            this._times = _arg_1.createSliderSection("wiredfurni.params.settimesingame", "times", new SliderValueCountOrUnlimited(11), 1, 11, 1, false);
            this._operation = _arg_1.createRadioGroup([new RadioButtonParam(0, l("points_operation.0")), new RadioButtonParam(1, l("points_operation.1"))]);
            _arg_3.addElements(this._score, this._times, _arg_1.createSection(l("points_operation"), this._operation));
            if (this._includeTeam)
            {
                this._team = _arg_1.createRadioGroup([new RadioButtonParam(1, l("team.1")), new RadioButtonParam(2, l("team.2")), new RadioButtonParam(3, l("team.3")), new RadioButtonParam(4, l("team.4"))], null, 2);
                _arg_3.addElements(_arg_1.createSection(l("team"), this._team));
            }
        }

        override public function readIntParamsFromForm():Array
        {
            var _local_2:int = this._score.value;
            if (this._operation.selected == 1)
            {
                _local_2 = -_local_2;
            }
            var _local_1:Array = [_local_2, (this._times.value == 11) ? 0 : this._times.value];
            if (this._includeTeam)
            {
                _local_1.push(this._team.selected);
            }
            return _local_1;
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            var _local_1:int = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 1;
            this._operation.selected = (_local_1 < 0) ? 1 : 0;
            this._score.value = Math.abs(_local_1);
            this._times.value = ((_arg_1.intData.length > 1) && (_arg_1.intData[1] == 0)) ? 11 : ((_arg_1.intData.length > 1) ? _arg_1.intData[1] : 1);
            if (this._includeTeam)
            {
                this._team.selected = (_arg_1.intData.length > 2) ? _arg_1.intData[2] : 1;
            }
        }
    }
}
