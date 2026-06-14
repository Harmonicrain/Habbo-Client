package com.sulake.habbo.communication.messages.incoming.users
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.PurchasableChatStyleChangedMessageParser;

    public class PurchasableChatStyleChangedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function PurchasableChatStyleChangedMessageEvent(k:Function)
        {
            super(k, PurchasableChatStyleChangedMessageParser);
        }

        public function getParser():PurchasableChatStyleChangedMessageParser
        {
            return this._parser as PurchasableChatStyleChangedMessageParser;
        }
    }
}
