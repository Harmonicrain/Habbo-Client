package com.sulake.habbo.communication.messages.incoming.habbicons
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconInfoMessageParser;

    public class HabbiconInfoMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function HabbiconInfoMessageEvent(callback:Function)
        {
            super(callback, HabbiconInfoMessageParser);
        }

        public function getParser():HabbiconInfoMessageParser
        {
            return this._parser as HabbiconInfoMessageParser;
        }
    }
}
