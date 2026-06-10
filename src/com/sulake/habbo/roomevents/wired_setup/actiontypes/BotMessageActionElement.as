package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class BotMessageActionElement extends BotNameActionElement
    {
        private static const SEPARATOR:String = "\t";

        private var _message:TextInputPreset;
        private var _mode:RadioGroupPreset;
        private var _firstLabel:String;
        private var _firstId:int;
        private var _secondLabel:String;
        private var _secondId:int;

        public function BotMessageActionElement(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:String, _arg_5:int)
        {
            super(_arg_1);
            this._firstLabel = _arg_2;
            this._firstId = _arg_3;
            this._secondLabel = _arg_4;
            this._secondId = _arg_5;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._botName = _arg_1.createTextInput(new TextInputParam("", 32, null, -1, null, true, loc("wiredfurni.tooltip.bot.name")));
            this._message = _arg_1.createTextInput(new TextInputParam("", 100, null, -1, null, true, loc("wiredfurni.tooltip.bot.chatmessage")));
            this._mode = _arg_1.createRadioGroup([new RadioButtonParam(this._firstId, this._firstLabel), new RadioButtonParam(this._secondId, this._secondLabel)]);
            _arg_3.addElements(_arg_1.createSection(l("bot.name"), this._botName), _arg_1.createSection(l("message"), this._message), _arg_1.createSection("", this._mode));
        }

        override public function readStringParamFromForm():String
        {
            return (this._botName.text + SEPARATOR) + this._message.text;
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._mode.selected];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            var _local_2:Array = _arg_1.stringData.split(SEPARATOR);
            this._botName.text = (_local_2.length >= 1) ? _local_2[0] : "";
            this._message.text = (_local_2.length >= 2) ? _local_2[1] : "";
            this._mode.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : this._firstId;
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
