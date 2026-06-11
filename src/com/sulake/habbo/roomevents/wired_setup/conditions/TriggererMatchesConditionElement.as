package com.sulake.habbo.roomevents.wired_setup.conditions
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
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class TriggererMatchesConditionElement extends DefaultElement
    {
        private var _userType:RadioGroupPreset;
        private var _nameMode:RadioGroupPreset;
        private var _name:TextInputPreset;

        override public function get code():int { return ConditionCodes.TRIGGERER_MATCHES; }
        override public function get negativeCode():int { return ConditionCodes.NOT_TRIGGERER_MATCHES; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._userType = _arg_1.createRadioGroup([new RadioButtonParam(1, l("usertype.1")), new RadioButtonParam(2, l("usertype.2")), new RadioButtonParam(4, l("usertype.4"))]);
            this._name = _arg_1.createTextInput(new TextInputParam("", 32, null, -1, null, true, loc("wiredfurni.tooltip.avatarname")));
            this._nameMode = _arg_1.createRadioGroup([new RadioButtonParam(0, l("anyavatar")), new RadioButtonParam(1, l("certainavatar"), null, this._name)]);
            _arg_3.addElements(_arg_1.createSection(l("usertype"), this._userType), _arg_1.createSection(l("picktriggerer"), this._nameMode));
        }

        override public function readIntParamsFromForm():Array { return [this._userType.selected]; }
        override public function readStringParamFromForm():String { return (this._nameMode.selected == 1) ? this._name.text : ""; }
        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._userType.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 1;
            this._name.text = _arg_1.stringData;
            this._nameMode.selected = (_arg_1.stringData != "") ? 1 : 0;
        }
    }
}
