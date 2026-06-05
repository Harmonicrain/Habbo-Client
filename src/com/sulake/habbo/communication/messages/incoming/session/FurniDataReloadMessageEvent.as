package com.sulake.habbo.communication.messages.incoming.session
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.session.FurniDataReloadMessageParser;

    public class FurniDataReloadMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function FurniDataReloadMessageEvent(k:Function)
        {
            super(k, FurniDataReloadMessageParser);
        }

        public function getParser():FurniDataReloadMessageParser
        {
            return this._parser as FurniDataReloadMessageParser;
        }
    }
}
