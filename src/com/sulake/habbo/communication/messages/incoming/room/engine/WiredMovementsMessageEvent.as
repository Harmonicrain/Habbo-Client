package com.sulake.habbo.communication.messages.incoming.room.engine
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.WiredMovementsMessageParser;

    public class WiredMovementsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMovementsMessageEvent(k:Function)
        {
            super(k, WiredMovementsMessageParser);
        }

        public function getParser():WiredMovementsMessageParser
        {
            return _parser as WiredMovementsMessageParser;
        }
    }
}
