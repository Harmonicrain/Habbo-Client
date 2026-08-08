package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.transactions
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogPage;

    public class WiredTransactionLogsMessageParser implements IMessageParser
    {
        private var _page:WiredTransactionLogPage;
        public function flush():Boolean { this._page = null; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            var parsed:Boolean = false;
            try
            {
                this._page = new WiredTransactionLogPage(data);
                parsed = data.bytesAvailable == 0;
            }
            catch (error:Error)
            {
                this._page = null;
            }
            return parsed;
        }
        public function get page():WiredTransactionLogPage { return this._page; }
    }
}
