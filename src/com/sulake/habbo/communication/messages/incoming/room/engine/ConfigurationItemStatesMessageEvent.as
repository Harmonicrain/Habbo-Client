package com.sulake.habbo.communication.messages.incoming.room.engine
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ConfigurationItemStatesMessageParser;

    public class ConfigurationItemStatesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function ConfigurationItemStatesMessageEvent(k:Function)
        {
            super(k, ConfigurationItemStatesMessageParser);
        }

        public function getParser():ConfigurationItemStatesMessageParser
        {
            return _parser as ConfigurationItemStatesMessageParser;
        }
    }
}
