package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.transactions.WiredTransactionDetailsMessageParser;

    public class WiredTransactionDetailsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredTransactionDetailsMessageEvent(callback:Function)
        {
            super(callback, WiredTransactionDetailsMessageParser);
        }
        public function getParser():WiredTransactionDetailsMessageParser
        {
            return this._parser as WiredTransactionDetailsMessageParser;
        }
    }
}
