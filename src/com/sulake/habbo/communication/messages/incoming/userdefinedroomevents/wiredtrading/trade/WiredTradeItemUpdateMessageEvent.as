package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade.WiredTradeItemUpdateMessageParser;

    public class WiredTradeItemUpdateMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredTradeItemUpdateMessageEvent(callback:Function)
        { super(callback, WiredTradeItemUpdateMessageParser); }
        public function getParser():WiredTradeItemUpdateMessageParser
        { return this._parser as WiredTradeItemUpdateMessageParser; }
    }
}
