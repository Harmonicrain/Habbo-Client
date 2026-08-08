package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.util.Long;
    import com.sulake.core.runtime.IDisposable;

    /** July C2S 475: one 64-bit transaction id. */
    public class RequestTransactionDetailsMessageComposer
        implements IMessageComposer, IDisposable
    {
        private var _array:Array;
        public function RequestTransactionDetailsMessageComposer(transactionId:Number)
        {
            this._array = [new Long(transactionId)];
        }
        public function getMessageArray():Array { return this._array; }
        public function dispose():void { this._array = null; }
        public function get disposed():Boolean { return this._array == null; }
    }
}
