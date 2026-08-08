package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredCapabilitiesMessageParser;

    public class WiredCapabilitiesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredCapabilitiesMessageEvent(k:Function)
        {
            super(k, WiredCapabilitiesMessageParser);
        }

        public function getParser():WiredCapabilitiesMessageParser
        {
            return this._parser as WiredCapabilitiesMessageParser;
        }
    }
}
