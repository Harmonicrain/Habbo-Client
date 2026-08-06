package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class WiredTradeCancelMessageComposer implements IMessageComposer
    {
        private var _data:Array = [];
        public function getMessageArray():Array { return this._data; }
        public function dispose():void { this._data = null; }
        public function get disposed():Boolean { return this._data == null; }
    }
}
