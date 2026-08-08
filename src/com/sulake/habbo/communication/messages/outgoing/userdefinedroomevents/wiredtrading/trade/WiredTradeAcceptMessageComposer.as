package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class WiredTradeAcceptMessageComposer implements IMessageComposer
    {
        private var _data:Array;
        public function WiredTradeAcceptMessageComposer(confirm:Boolean)
        { this._data = [confirm]; }
        public function getMessageArray():Array { return this._data; }
        public function dispose():void { this._data = null; }
        public function get disposed():Boolean { return this._data == null; }
    }
}
