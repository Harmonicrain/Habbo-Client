package com.sulake.habbo.communication.messages.incoming.room.publicroom
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.publicroom.BusDoorMessageParser;

    public class BusDoorMessageEvent extends MessageEvent
    {
        public function BusDoorMessageEvent(k:Function)
        {
            super(k, BusDoorMessageParser);
        }

        public function getParser():BusDoorMessageParser
        {
            return (_parser as BusDoorMessageParser);
        }
    }
}
