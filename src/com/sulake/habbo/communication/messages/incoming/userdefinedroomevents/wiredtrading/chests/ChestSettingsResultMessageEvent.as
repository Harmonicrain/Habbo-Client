package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestSettingsResultMessageParser;

    public class ChestSettingsResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function ChestSettingsResultMessageEvent(callback:Function)
        {
            super(callback, ChestSettingsResultMessageParser);
        }
        public function getParser():ChestSettingsResultMessageParser
        {
            return this._parser as ChestSettingsResultMessageParser;
        }
    }
}
