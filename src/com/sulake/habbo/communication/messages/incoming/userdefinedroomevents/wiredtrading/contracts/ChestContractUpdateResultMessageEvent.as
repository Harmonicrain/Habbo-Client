package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractUpdateResultMessageParser;

    public class ChestContractUpdateResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function ChestContractUpdateResultMessageEvent(callback:Function)
        {
            super(callback, ChestContractUpdateResultMessageParser);
        }
        public function getParser():ChestContractUpdateResultMessageParser
        {
            return this._parser as ChestContractUpdateResultMessageParser;
        }
    }
}
