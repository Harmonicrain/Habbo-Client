package com.sulake.habbo.communication.messages.incoming.habbicons
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.RoomUserHabbiconMessageParser;

    public class RoomUserHabbiconMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function RoomUserHabbiconMessageEvent(callback:Function)
        {
            super(callback, RoomUserHabbiconMessageParser);
        }

        public function getParser():RoomUserHabbiconMessageParser
        {
            return this._parser as RoomUserHabbiconMessageParser;
        }
    }
}
