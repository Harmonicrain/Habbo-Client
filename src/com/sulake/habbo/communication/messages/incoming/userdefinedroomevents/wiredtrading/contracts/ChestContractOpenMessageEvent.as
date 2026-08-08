package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractOpenMessageParser;

    public class ChestContractOpenMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function ChestContractOpenMessageEvent(callback:Function)
        {
            super(callback, ChestContractOpenMessageParser);
        }
        public function getParser():ChestContractOpenMessageParser
        {
            return this._parser as ChestContractOpenMessageParser;
        }
    }
}
