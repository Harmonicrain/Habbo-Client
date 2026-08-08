package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade.WiredTradeCompletedMessageParser;

    public class WiredTradeCompletedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredTradeCompletedMessageEvent(callback:Function)
        { super(callback, WiredTradeCompletedMessageParser); }
    }
}
