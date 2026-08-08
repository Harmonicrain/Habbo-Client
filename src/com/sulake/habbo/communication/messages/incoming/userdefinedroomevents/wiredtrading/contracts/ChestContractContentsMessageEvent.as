package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;

    public class ChestContractContentsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function ChestContractContentsMessageEvent(callback:Function)
        {
            super(callback, ChestContractContentsMessageParser);
        }
        public function getParser():ChestContractContentsMessageParser
        {
            return this._parser as ChestContractContentsMessageParser;
        }
    }
}
