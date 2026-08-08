package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.WiredTransactionSuccessContents;

    /** Exact July parser for S2C 2677 (local 7133). */
    public class WiredTransactionSuccessMessageParser implements IMessageParser
    {
        private static var _nextInternalId:int = 1;
        private var _contents:WiredTransactionSuccessContents;

        public function flush():Boolean
        {
            this._contents = null;
            return true;
        }

        public function parse(data:IMessageDataWrapper):Boolean
        {
            this._contents = new WiredTransactionSuccessContents(
                _nextInternalId++, data);
            return true;
        }

        public function get contents():WiredTransactionSuccessContents
        {
            return this._contents;
        }
    }
}
