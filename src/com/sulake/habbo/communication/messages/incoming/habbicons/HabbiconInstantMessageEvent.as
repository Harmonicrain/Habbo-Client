package com.sulake.habbo.communication.messages.incoming.habbicons
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconInstantMessageParser;

    public class HabbiconInstantMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function HabbiconInstantMessageEvent(callback:Function)
        {
            super(callback, HabbiconInstantMessageParser);
        }

        public function getParser():HabbiconInstantMessageParser
        {
            return this._parser as HabbiconInstantMessageParser;
        }
    }
}
