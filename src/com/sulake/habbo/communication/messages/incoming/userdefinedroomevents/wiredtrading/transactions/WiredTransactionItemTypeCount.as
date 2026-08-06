package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;

    public class WiredTransactionItemTypeCount
    {
        private var _type:ChestItemType;
        private var _amount:int;

        public function WiredTransactionItemTypeCount(data:IMessageDataWrapper)
        {
            this._type = ChestItemType.readFromMessage(data);
            this._amount = data.readInteger();
        }

        public function get type():ChestItemType { return this._type; }
        public function get amount():int { return this._amount; }
    }
}
