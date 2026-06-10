package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class BotFollowAvatarElement extends BotNameActionElement
    {
        private var _followMode:RadioGroupPreset;

        public function BotFollowAvatarElement()
        {
            super(ActionTypeCodes.BOT_FOLLOW_AVATAR);
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._botName = _arg_1.createTextInput(new TextInputParam("", 32, null, -1, null, true, loc("wiredfurni.tooltip.bot.name")));
            this._followMode = _arg_1.createRadioGroup([new RadioButtonParam(1, l("start.following")), new RadioButtonParam(0, l("stop.following"))]);
            _arg_3.addElements(_arg_1.createSection(l("bot.name"), _arg_1.createSimpleListView(true, [this._botName, this._followMode])));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._followMode.selected];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._botName.text = _arg_1.stringData;
            this._followMode.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 1;
        }
    }
}
