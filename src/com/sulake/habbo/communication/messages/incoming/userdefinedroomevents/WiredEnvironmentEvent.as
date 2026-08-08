package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredEnvironmentMessageParser;

    public class WiredEnvironmentEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredEnvironmentEvent(k:Function)
        {
            super(k, WiredEnvironmentMessageParser);
        }

        public function getParser():WiredEnvironmentMessageParser
        {
            return this._parser as WiredEnvironmentMessageParser;
        }
    }
}
