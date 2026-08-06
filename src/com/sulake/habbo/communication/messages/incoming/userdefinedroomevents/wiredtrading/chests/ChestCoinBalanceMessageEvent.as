package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestCoinBalanceMessageParser;

    public class ChestCoinBalanceMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function ChestCoinBalanceMessageEvent(callback:Function)
        {
            super(callback, ChestCoinBalanceMessageParser);
        }
        public function getParser():ChestCoinBalanceMessageParser
        {
            return this._parser as ChestCoinBalanceMessageParser;
        }
    }
}
