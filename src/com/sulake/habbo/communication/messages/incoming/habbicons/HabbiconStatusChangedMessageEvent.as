package com.sulake.habbo.communication.messages.incoming.habbicons
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconStatusChangedMessageParser;

    public class HabbiconStatusChangedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function HabbiconStatusChangedMessageEvent(callback:Function)
        {
            super(callback, HabbiconStatusChangedMessageParser);
        }

        public function getParser():HabbiconStatusChangedMessageParser
        {
            return this._parser as HabbiconStatusChangedMessageParser;
        }
    }
}
