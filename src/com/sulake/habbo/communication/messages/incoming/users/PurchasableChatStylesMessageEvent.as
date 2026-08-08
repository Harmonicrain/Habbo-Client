package com.sulake.habbo.communication.messages.incoming.users
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.ChatStyleIdsMessageParser;

    public class PurchasableChatStylesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function PurchasableChatStylesMessageEvent(k:Function)
        {
            super(k, ChatStyleIdsMessageParser);
        }

        public function getParser():ChatStyleIdsMessageParser
        {
            return this._parser as ChatStyleIdsMessageParser;
        }
    }
}
