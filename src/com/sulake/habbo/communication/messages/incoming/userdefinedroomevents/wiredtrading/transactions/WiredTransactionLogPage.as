package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
    import __AS3__.vec.Vector;

    /** July's room/chest transaction page envelope. */
    public class WiredTransactionLogPage
    {
        public static const LIST_CHEST:int = 0;
        public static const LIST_ROOM:int = 1;

        private var _listType:int;
        private var _listId:Number;
        private var _totalLogs:int;
        private var _currentPage:int;
        private var _amount:int;
        private var _logs:Vector.<WiredTransactionInfo>;

        public function WiredTransactionLogPage(data:IMessageDataWrapper)
        {
            this._listType = data.readInteger();
            this._listId = data.readLong();
            this._totalLogs = data.readInteger();
            this._currentPage = data.readInteger();
            this._amount = data.readInteger();
            var count:int = WiredMessageDataValidator.readCount(
                data, 54, 100, "Wired transaction logs");
            this._logs = new Vector.<WiredTransactionInfo>();
            for (var i:int = 0; i < count; i++)
            {
                this._logs.push(new WiredTransactionInfo(data));
            }
        }

        public function get listType():int { return this._listType; }
        public function get listId():Number { return this._listId; }
        public function get totalLogs():int { return this._totalLogs; }
        public function get currentPage():int { return this._currentPage; }
        public function get amount():int { return this._amount; }
        public function get logs():Vector.<WiredTransactionInfo> { return this._logs; }
    }
}
