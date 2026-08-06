package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class ChestContractUpdateResultMessageParser implements IMessageParser
    {
        private var _contractId:int;
        private var _success:Boolean;
        private var _failCode:String;
        public function flush():Boolean
        {
            this._contractId = 0;
            this._success = false;
            this._failCode = null;
            return true;
        }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable < 7) return false;
            this._contractId = data.readInteger();
            this._success = data.readBoolean();
            this._failCode = data.readString();
            return data.bytesAvailable == 0;
        }
        public function get contractId():int { return this._contractId; }
        public function get isSuccess():Boolean { return this._success; }
        public function get failCode():String { return this._failCode; }
    }
}
