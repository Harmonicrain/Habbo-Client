package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class TeamActionElement extends DefaultElement
    {
        private var _code:int;
        protected var _team:RadioGroupPreset;

        public function TeamActionElement(_arg_1:int)
        {
            super();
            this._code = _arg_1;
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
            this._team = createTeamRadio(_arg_1);
            _arg_3.addElements(_arg_1.createSection(l("team"), this._team));
        }

        protected function createTeamRadio(_arg_1:PresetManager):RadioGroupPreset
        {
            return _arg_1.createRadioGroup([new RadioButtonParam(1, l("team.1")), new RadioButtonParam(2, l("team.2")), new RadioButtonParam(3, l("team.3")), new RadioButtonParam(4, l("team.4"))], null, 2);
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._team.selected];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._team.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 1;
        }
    }
}
