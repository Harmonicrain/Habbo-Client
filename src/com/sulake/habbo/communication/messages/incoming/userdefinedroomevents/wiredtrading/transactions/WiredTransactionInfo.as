package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /** One exact July transaction-log summary record. */
    public class WiredTransactionInfo
    {
        public static const TYPE_MANUAL:int = 0;
        public static const TYPE_WIRED:int = 1;
        public static const TYPE_CONTRACT_PAYMENT:int = 2;
        public static const TYPE_CONTRACT_REWARD:int = 3;
        public static const TYPE_CONTRACT_TRADE:int = 4;

        private var _transactionId:Number;
        private var _roomId:int;
        private var _transactionType:int;
        private var _definitionInfo:String;
        private var _userId:int;
        private var _username:String;
        private var _timestamp:Number;
        private var _readableTimestamp:String;
        private var _chestCount:int;
        private var _withdrawFurniCount:int;
        private var _depositFurniCount:int;
        private var _withdrawCoinsCount:int;
        private var _depositCoinsCount:int;

        public function WiredTransactionInfo(data:IMessageDataWrapper)
        {
            this._transactionId = data.readLong();
            this._roomId = data.readInteger();
            this._transactionType = data.readInteger();
            this._definitionInfo = data.readString();
            this._userId = data.readInteger();
            this._username = data.readString();
            this._timestamp = data.readLong();
            this._readableTimestamp = data.readString();
            this._chestCount = data.readInteger();
            this._withdrawFurniCount = data.readInteger();
            this._depositFurniCount = data.readInteger();
            this._withdrawCoinsCount = data.readInteger();
            this._depositCoinsCount = data.readInteger();
        }

        public function get transactionId():Number { return this._transactionId; }
        public function get roomId():int { return this._roomId; }
        public function get transactionType():int { return this._transactionType; }
        public function get transactionDefinitionInfo():String { return this._definitionInfo; }
        public function get userId():int { return this._userId; }
        public function get username():String { return this._username; }
        public function get timestamp():Number { return this._timestamp; }
        public function get readableTimestamp():String { return this._readableTimestamp; }
        public function get chestCount():int { return this._chestCount; }
        public function get withdrawFurniCount():int { return this._withdrawFurniCount; }
        public function get depositFurniCount():int { return this._depositFurniCount; }
        public function get withdrawCoinsCount():int { return this._withdrawCoinsCount; }
        public function get depositCoinsCount():int { return this._depositCoinsCount; }
    }
}
