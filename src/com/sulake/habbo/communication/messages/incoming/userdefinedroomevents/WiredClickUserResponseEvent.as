package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredClickUserResponseMessageParser;

    public class WiredClickUserResponseEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredClickUserResponseEvent(k:Function)
        {
            super(k, WiredClickUserResponseMessageParser);
        }

        public function getParser():WiredClickUserResponseMessageParser
        {
            return this._parser as WiredClickUserResponseMessageParser;
        }
    }
}
