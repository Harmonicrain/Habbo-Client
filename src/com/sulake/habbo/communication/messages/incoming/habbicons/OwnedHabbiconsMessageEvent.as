package com.sulake.habbo.communication.messages.incoming.habbicons
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.habbicons.OwnedHabbiconsMessageParser;

    public class OwnedHabbiconsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function OwnedHabbiconsMessageEvent(callback:Function)
        {
            super(callback, OwnedHabbiconsMessageParser);
        }

        public function getParser():OwnedHabbiconsMessageParser
        {
            return this._parser as OwnedHabbiconsMessageParser;
        }
    }
}
