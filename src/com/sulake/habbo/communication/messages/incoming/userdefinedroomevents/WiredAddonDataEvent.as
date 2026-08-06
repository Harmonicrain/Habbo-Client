package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredAddonDataMessageParser;

    public class WiredAddonDataEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredAddonDataEvent(k:Function)
        {
            super(k, WiredAddonDataMessageParser);
        }

        public function getParser():WiredAddonDataMessageParser
        {
            return this._parser as WiredAddonDataMessageParser;
        }
    }
}
