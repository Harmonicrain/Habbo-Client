package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * Trigger code 0 (avatar says something) — May/July payload.
     *
     * Wire order: intParams = [hide, matchType, ownerOnly], stringParam = keyword.
     * Arcturus reads, persists and executes this payload
     * (matchType: 0=contains, 1=exact, 2=all text).
     */
    public class AvatarSaysSomethingElement extends DefaultElement
    {
        private var _keywordInput:TextInputPreset;
        private var _matchType:RadioGroupPreset;
        private var _options:CheckboxGroupPreset;

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
            this._keywordInput = _arg_1.createTextInput(new TextInputParam("", 1000, null, -1, null, true, loc("wiredfurni.tooltip.chatinput")));
            this._matchType = _arg_1.createRadioGroup([new RadioButtonParam(0, l("chatcontains")), new RadioButtonParam(1, l("exactmatch")), new RadioButtonParam(2, l("allmatch"))], this.onTriggerTypeChange);
            this._options = _arg_1.createCheckboxGroup([new CheckboxOptionParam(l("chat.hide"), 1), new CheckboxOptionParam(l("chat.onlyowner"), 0)]);
            _arg_3.addElements(_arg_1.createSection(l("whatissaid"), this._keywordInput), _arg_1.createSection(l("chattriggertype"), this._matchType), _arg_1.createSection(l("select_options"), this._options));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._options.get(1).selected ? 1 : 0, this._matchType.selected, this._options.get(0).selected ? 1 : 0];
        }

        override public function readStringParamFromForm():String
        {
            return this._keywordInput.text;
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._keywordInput.text = _arg_1.stringData;
            this._options.get(1).selected = (_arg_1.intData.length > 0) && (_arg_1.intData[0] != 0);
            this._matchType.selected = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 0;
            this._options.get(0).selected = (_arg_1.intData.length > 2) && (_arg_1.intData[2] != 0);
            this.onTriggerTypeChange(this._matchType.selected);
        }

        private function onTriggerTypeChange(_arg_1:int):void
        {
            Util.disableSection(this._keywordInput.window, _arg_1 == 2);
        }
    }
}
