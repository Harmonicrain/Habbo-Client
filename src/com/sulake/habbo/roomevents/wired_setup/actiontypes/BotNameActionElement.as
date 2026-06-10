package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class BotNameActionElement extends DefaultElement
    {
        private var _code:int;
        protected var _botName:TextInputPreset;

        public function BotNameActionElement(_arg_1:int)
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
            this._botName = _arg_1.createTextInput(new TextInputParam("", 32, null, -1, null, true, loc("wiredfurni.tooltip.bot.name")));
            _arg_3.addElements(_arg_1.createSection(l("bot.name"), this._botName));
        }

        override public function readStringParamFromForm():String
        {
            return this._botName.text;
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._botName.text = _arg_1.stringData;
        }
    }
}
