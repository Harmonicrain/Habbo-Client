package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class BotGiveHandItemElement extends BotNameActionElement
    {
        private var _handItem:NumberInputPreset;

        public function BotGiveHandItemElement()
        {
            super(ActionTypeCodes.BOT_GIVE_HAND_ITEM);
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._botName = _arg_1.createTextInput(new TextInputParam("", 32, null, -1, null, true, loc("wiredfurni.tooltip.bot.name")));
            this._handItem = _arg_1.createNumberInput(new NumberInputParam(0, 0, 99999));
            _arg_3.addElements(_arg_1.createSection(l("bot.name"), this._botName), _arg_1.createSection(l("handitem"), this._handItem));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._handItem.value];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._botName.text = _arg_1.stringData;
            this._handItem.value = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
        }
    }
}
