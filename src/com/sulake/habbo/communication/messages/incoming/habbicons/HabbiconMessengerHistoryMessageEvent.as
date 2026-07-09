package com.sulake.habbo.communication.messages.incoming.habbicons
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconMessengerHistoryMessageParser;

    public class HabbiconMessengerHistoryMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function HabbiconMessengerHistoryMessageEvent(callback:Function)
        {
            super(callback, HabbiconMessengerHistoryMessageParser);
        }

        public function getParser():HabbiconMessengerHistoryMessageParser
        {
            return this._parser as HabbiconMessengerHistoryMessageParser;
        }
    }
}
