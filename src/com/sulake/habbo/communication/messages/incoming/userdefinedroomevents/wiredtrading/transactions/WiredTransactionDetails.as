package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
    import __AS3__.vec.Vector;

    /** Exact July transaction-details model. */
    public class WiredTransactionDetails
    {
        private var _info:WiredTransactionInfo;
        private var _chestIds:Vector.<int>;
        private var _deposited:Vector.<WiredTransactionItemTypeCount>;
        private var _withdrawn:Vector.<WiredTransactionItemTypeCount>;
        private var _incomplete:Boolean;

        public function WiredTransactionDetails(data:IMessageDataWrapper)
        {
            this._info = new WiredTransactionInfo(data);
            var count:int = WiredMessageDataValidator.readCount(
                data, 4, 1000, "Transaction chest ids");
            this._chestIds = new Vector.<int>();
            var i:int;
            for (i = 0; i < count; i++)
            {
                this._chestIds.push(data.readInteger());
            }
            this._deposited = this.readItems(data, "Deposited transaction item types");
            this._withdrawn = this.readItems(data, "Withdrawn transaction item types");
            WiredMessageDataValidator.requireBytes(data, 1, "Transaction incomplete flag");
            this._incomplete = data.readBoolean();
        }

        private function readItems(data:IMessageDataWrapper,
                                   label:String):Vector.<WiredTransactionItemTypeCount>
        {
            var count:int = WiredMessageDataValidator.readCount(data, 10, 1000, label);
            var result:Vector.<WiredTransactionItemTypeCount> =
                new Vector.<WiredTransactionItemTypeCount>();
            for (var i:int = 0; i < count; i++)
            {
                result.push(new WiredTransactionItemTypeCount(data));
            }
            return result;
        }

        public function get info():WiredTransactionInfo { return this._info; }
        public function get chestIds():Vector.<int> { return this._chestIds; }
        public function get depositedFurnis():Vector.<WiredTransactionItemTypeCount>
        {
            return this._deposited;
        }
        public function get withdrawnFurnis():Vector.<WiredTransactionItemTypeCount>
        {
            return this._withdrawn;
        }
        public function get incompleteData():Boolean { return this._incomplete; }
    }
}
