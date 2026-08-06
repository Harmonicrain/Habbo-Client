package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.contracts
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class SaveChestContractMessageComposer implements IMessageComposer
    {
        private var _data:Array;
        public function SaveChestContractMessageComposer(data:Array)
        {
            this._data = data == null ? [] : data;
        }
        public function getMessageArray():Array { return this._data; }
        public function dispose():void { this._data = null; }
    }
}
