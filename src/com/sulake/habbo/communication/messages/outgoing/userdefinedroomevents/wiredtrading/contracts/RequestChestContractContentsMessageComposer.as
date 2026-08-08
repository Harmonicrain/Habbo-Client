package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.contracts
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class RequestChestContractContentsMessageComposer implements IMessageComposer
    {
        private var _data:Array;
        public function RequestChestContractContentsMessageComposer(contractId:int)
        {
            this._data = [contractId];
        }
        public function getMessageArray():Array { return this._data; }
        public function dispose():void { this._data = null; }
    }
}
