package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.AllVariablesHashMessageParser;

    public class AllVariablesHashMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function AllVariablesHashMessageEvent(k:Function)
        {
            super(k, AllVariablesHashMessageParser);
        }

        public function getParser():AllVariablesHashMessageParser
        {
            return this._parser as AllVariablesHashMessageParser;
        }
    }
}
