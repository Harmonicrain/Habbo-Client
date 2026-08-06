package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class ChestContractOpenMessageParser implements IMessageParser
    {
        private var _contractId:int;
        public function flush():Boolean { this._contractId = 0; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable != 4) return false;
            this._contractId = data.readInteger();
            return true;
        }
        public function get contractId():int { return this._contractId; }
    }
}
