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

    /**
     * Phase 2 builder smoke type: trigger code 0 (avatar says something).
     *
     * IMPORTANT: keeps the LEGACY wire order the server expects —
     * intParams = [triggererIsMe ? 1 : 0], stringParam = keyword. The May 2026
     * element sends a 3-int payload (hide/matchType/ownerOnly) that the server
     * does not understand yet; do not copy it until the server side moves.
     */
    public class AvatarSaysSomethingElement extends DefaultElement
    {
        private var _keywordInput:TextInputPreset;
        private var _triggererOptions:RadioGroupPreset;

        public function AvatarSaysSomethingElement()
        {
            super();
        }

        override public function get code():int
        {
            return 0;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._keywordInput = _arg_1.createTextInput(new TextInputParam("", 100));
            this._triggererOptions = _arg_1.createRadioGroup([new RadioButtonParam(0, loc("wiredfurni.params.anyavatar")), new RadioButtonParam(1, _roomEvents.userName)]);
            _arg_3.addElements(_arg_1.createSection(l("whatissaid"), this._keywordInput), _arg_1.createSection(l("picktriggerer"), this._triggererOptions));
        }

        override public function readIntParamsFromForm():Array
        {
            return [(this._triggererOptions.selected == 1) ? 1 : 0];
        }

        override public function readStringParamFromForm():String
        {
            return this._keywordInput.text;
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._keywordInput.text = _arg_1.stringData;
            this._triggererOptions.selected = ((_arg_1.intData.length > 0) && (_arg_1.intData[0] == 1)) ? 1 : 0;
        }
    }
}
