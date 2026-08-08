package com.sulake.habbo.communication.messages.incoming.habbicons
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconShopDataMessageParser;

    public class HabbiconShopDataMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function HabbiconShopDataMessageEvent(callback:Function)
        {
            super(callback, HabbiconShopDataMessageParser);
        }

        public function getParser():HabbiconShopDataMessageParser
        {
            return this._parser as HabbiconShopDataMessageParser;
        }
    }
}
