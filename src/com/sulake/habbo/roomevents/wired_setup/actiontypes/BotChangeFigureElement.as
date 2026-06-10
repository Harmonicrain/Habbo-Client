package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class BotChangeFigureElement extends BotNameActionElement
    {
        private static const SEPARATOR:String = "\t";

        private var _figure:TextInputPreset;

        public function BotChangeFigureElement()
        {
            super(ActionTypeCodes.BOT_CHANGE_FIGURE);
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._botName = _arg_1.createTextInput(new TextInputParam("", 32, null, -1, null, true, loc("wiredfurni.tooltip.bot.name")));
            this._figure = _arg_1.createTextInput(new TextInputParam("", 1000));
            _arg_3.addElements(_arg_1.createSection(l("bot.name"), this._botName), _arg_1.createSection(l("capture.figure"), this._figure), _arg_1.createTextualButtonPreset(l("capture.figure"), this.captureFigure));
        }

        private function captureFigure():void
        {
            if (this.roomEvents != null && this.roomEvents.sessionDataManager != null)
            {
                this._figure.text = this.roomEvents.sessionDataManager.figure;
            }
        }

        override public function readStringParamFromForm():String
        {
            return (this._botName.text + SEPARATOR) + this._figure.text;
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            var _local_2:Array = _arg_1.stringData.split(SEPARATOR);
            this._botName.text = (_local_2.length > 0) ? _local_2[0] : "";
            this._figure.text = (_local_2.length > 1) ? _local_2[1] : "";
        }
    }
}
