package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.transactions
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionDetails;

    public class WiredTransactionDetailsMessageParser implements IMessageParser
    {
        private var _details:WiredTransactionDetails;
        public function flush():Boolean { this._details = null; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            var parsed:Boolean = false;
            try
            {
                this._details = new WiredTransactionDetails(data);
                parsed = data.bytesAvailable == 0;
            }
            catch (error:Error)
            {
                this._details = null;
            }
            return parsed;
        }
        public function get details():WiredTransactionDetails { return this._details; }
    }
}
