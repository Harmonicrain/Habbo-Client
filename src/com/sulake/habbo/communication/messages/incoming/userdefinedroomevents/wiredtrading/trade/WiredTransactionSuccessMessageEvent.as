package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade.WiredTransactionSuccessMessageParser;

    public class WiredTransactionSuccessMessageEvent extends MessageEvent
        implements IMessageEvent
    {
        public function WiredTransactionSuccessMessageEvent(callback:Function)
        {
            super(callback, WiredTransactionSuccessMessageParser);
        }

        public function getParser():WiredTransactionSuccessMessageParser
        {
            return this._parser as WiredTransactionSuccessMessageParser;
        }
    }
}
