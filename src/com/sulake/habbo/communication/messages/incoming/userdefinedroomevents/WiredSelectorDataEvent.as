package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredSelectorDataMessageParser;

    public class WiredSelectorDataEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredSelectorDataEvent(k:Function)
        {
            super(k, WiredSelectorDataMessageParser);
        }

        public function getParser():WiredSelectorDataMessageParser
        {
            return this._parser as WiredSelectorDataMessageParser;
        }
    }
}
