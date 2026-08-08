package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade.WiredTradeInitiateMessageParser;

    public class WiredTradeInitiateMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredTradeInitiateMessageEvent(callback:Function)
        { super(callback, WiredTradeInitiateMessageParser); }
        public function getParser():WiredTradeInitiateMessageParser
        { return this._parser as WiredTradeInitiateMessageParser; }
    }
}
