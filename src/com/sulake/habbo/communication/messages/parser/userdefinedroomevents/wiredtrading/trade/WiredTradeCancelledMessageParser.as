package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class WiredTradeCancelledMessageParser implements IMessageParser
    {
        private var _transactionFailureTypeId:int;
        public function flush():Boolean
        {
            this._transactionFailureTypeId = 0;
            return true;
        }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable != 4) { return false; }
            this._transactionFailureTypeId = data.readInteger();
            return true;
        }
        public function get transactionFailureTypeId():int
        { return this._transactionFailureTypeId; }
    }
}
