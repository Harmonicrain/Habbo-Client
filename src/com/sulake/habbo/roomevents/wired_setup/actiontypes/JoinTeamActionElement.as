package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class JoinTeamActionElement extends TeamActionElement
    {
        private var _teamType:RadioGroupPreset;

        public function JoinTeamActionElement()
        {
            super(ActionTypeCodes.JOIN_TEAM);
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._team = createTeamRadio(_arg_1);
            this._teamType = _arg_1.createRadioGroup([new RadioButtonParam(0, l("team_type.0")), new RadioButtonParam(1, l("team_type.1")), new RadioButtonParam(2, l("team_type.2"))]);
            _arg_3.addElements(_arg_1.createSection(l("team"), this._team), _arg_1.createSection(l("choose_type"), this._teamType));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._team.selected, this._teamType.selected];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._team.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 1;
            this._teamType.selected = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 0;
        }
    }
}
