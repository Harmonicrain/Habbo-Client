package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class WiredTradeCompletedMessageParser implements IMessageParser
    {
        public function flush():Boolean { return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        { return data.bytesAvailable == 0; }
    }
}
