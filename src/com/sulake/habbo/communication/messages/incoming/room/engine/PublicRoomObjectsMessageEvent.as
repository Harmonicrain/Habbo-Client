package com.sulake.habbo.communication.messages.incoming.room.engine
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.PublicRoomObjectsMessageParser;

    public class PublicRoomObjectsMessageEvent extends MessageEvent
    {
        public function PublicRoomObjectsMessageEvent(k:Function)
        {
            super(k, PublicRoomObjectsMessageParser);
        }

        public function getParser():PublicRoomObjectsMessageParser
        {
            return (_parser as PublicRoomObjectsMessageParser);
        }
    }
}
