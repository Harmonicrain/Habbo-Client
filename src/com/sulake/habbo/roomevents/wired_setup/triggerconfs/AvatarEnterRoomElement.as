package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

    public class AvatarEnterRoomElement extends DefaultElement
    {
        private var _avatarName:TextInputPreset;
        private var _avatarOptions:RadioGroupPreset;

        public function AvatarEnterRoomElement()
        {
            super();
        }

        override public function get code():int
        {
            return WiredTriggerType.AVATAR_ENTERS_ROOM;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._avatarName = _arg_1.createTextInput(new TextInputParam("", 100));
            this._avatarOptions = _arg_1.createRadioGroup([new RadioButtonParam(0, loc("wiredfurni.params.anyavatar")), new RadioButtonParam(1, l("certainavatar"), this._avatarName)]);
            _arg_3.addElements(_arg_1.createSection(l("picktriggerer"), this._avatarOptions));
        }

        override public function readStringParamFromForm():String
        {
            return (this._avatarOptions.selected == 1) ? this._avatarName.text : "";
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._avatarName.text = _arg_1.stringData;
            this._avatarOptions.selected = (_arg_1.stringData != "") ? 1 : 0;
        }
    }
}
