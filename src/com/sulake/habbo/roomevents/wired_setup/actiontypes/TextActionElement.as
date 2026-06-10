package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class TextActionElement extends DefaultElement
    {
        private var _code:int;
        private var _section:String;
        private var _input:TextInputPreset;

        public function TextActionElement(_arg_1:int, _arg_2:String)
        {
            super();
            this._code = _arg_1;
            this._section = _arg_2;
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
            this._input = _arg_1.createTextInput(new TextInputParam("", 100));
            _arg_3.addElements(_arg_1.createSection(this._section, this._input));
        }

        override public function readStringParamFromForm():String
        {
            return this._input.text;
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._input.text = _arg_1.stringData;
        }

        override public function validate():String
        {
            if (this._input.text.length > 100)
            {
                return loc("wiredfurni.chatmsgtoolong");
            }
            return null;
        }
    }
}
