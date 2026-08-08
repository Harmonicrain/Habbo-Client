package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class WiredTradeItemsMessageComposer implements IMessageComposer
    {
        private var _data:Array = [];
        public function WiredTradeItemsMessageComposer(remove:Boolean, itemIds:Vector.<int>)
        {
            this._data.push(remove);
            this._data.push(itemIds.length);
            for each (var itemId:int in itemIds) { this._data.push(itemId); }
        }
        public function getMessageArray():Array { return this._data; }
        public function dispose():void { this._data = null; }
        public function get disposed():Boolean { return this._data == null; }
    }
}
