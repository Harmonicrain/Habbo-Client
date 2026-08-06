package com.sulake.habbo.communication.messages.incoming.room.engine
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.AreaHideMessageParser;

    public class AreaHideMessageEvent extends MessageEvent
    {
        public function AreaHideMessageEvent(k:Function)
        {
            super(k, AreaHideMessageParser);
        }

        public function getParser():AreaHideMessageParser
        {
            return _parser as AreaHideMessageParser;
        }
    }
}
