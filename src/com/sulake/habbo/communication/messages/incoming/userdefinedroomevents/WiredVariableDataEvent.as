package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredVariableDataMessageParser;

    public class WiredVariableDataEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredVariableDataEvent(k:Function)
        {
            super(k, WiredVariableDataMessageParser);
        }

        public function getParser():WiredVariableDataMessageParser
        {
            return this._parser as WiredVariableDataMessageParser;
        }
    }
}
