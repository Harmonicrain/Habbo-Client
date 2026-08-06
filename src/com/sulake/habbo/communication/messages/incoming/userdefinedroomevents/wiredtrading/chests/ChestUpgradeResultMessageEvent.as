package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestUpgradeResultMessageParser;

    public class ChestUpgradeResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function ChestUpgradeResultMessageEvent(callback:Function)
        {
            super(callback, ChestUpgradeResultMessageParser);
        }
        public function getParser():ChestUpgradeResultMessageParser
        {
            return this._parser as ChestUpgradeResultMessageParser;
        }
    }
}
