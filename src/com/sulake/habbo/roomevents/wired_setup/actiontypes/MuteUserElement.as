package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class MuteUserElement extends DefaultElement
    {
        private var _message:TextInputPreset;
        private var _minutes:SliderSection;

        public function MuteUserElement()
        {
            super();
        }

        override public function get code():int
        {
            return ActionTypeCodes.MUTE_USER;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._minutes = _arg_1.createSliderSection("wiredfurni.params.length.minutes", "minutes", new SliderValueEcho(), 0, 10, 1);
            this._message = _arg_1.createTextInput(new TextInputParam("", 100));
            _arg_3.addElements(this._minutes, _arg_1.createSection(l("message"), this._message));
        }

        override public function readStringParamFromForm():String
        {
            return this._message.text;
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._minutes.value];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._message.text = _arg_1.stringData;
            this._minutes.value = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 1;
        }

        override public function validate():String
        {
            if (this._message.text.length > 100)
            {
                return loc("wiredfurni.chatmsgtoolong");
            }
            return null;
        }
    }
}
