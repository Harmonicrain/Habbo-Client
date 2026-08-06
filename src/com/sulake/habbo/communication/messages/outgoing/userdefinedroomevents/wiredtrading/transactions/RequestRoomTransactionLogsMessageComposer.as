package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    /** July C2S 2016: page size, 1-based page. */
    public class RequestRoomTransactionLogsMessageComposer
        implements IMessageComposer, IDisposable
    {
        private var _array:Array;
        public function RequestRoomTransactionLogsMessageComposer(amount:int, page:int)
        {
            this._array = [amount, page];
        }
        public function getMessageArray():Array { return this._array; }
        public function dispose():void { this._array = null; }
        public function get disposed():Boolean { return this._array == null; }
    }
}
