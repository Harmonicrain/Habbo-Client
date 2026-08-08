package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.AllVariablesDiffMessageParser;

    public class AllVariablesDiffMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function AllVariablesDiffMessageEvent(k:Function)
        {
            super(k, AllVariablesDiffMessageParser);
        }

        public function getParser():AllVariablesDiffMessageParser
        {
            return this._parser as AllVariablesDiffMessageParser;
        }
    }
}
