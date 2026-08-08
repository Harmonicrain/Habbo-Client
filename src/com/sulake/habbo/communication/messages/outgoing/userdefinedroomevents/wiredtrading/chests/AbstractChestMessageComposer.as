package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    public class AbstractChestMessageComposer implements IMessageComposer, IDisposable
    {
        protected var _array:Array;
        public function AbstractChestMessageComposer(values:Array) { this._array = values; }
        public function getMessageArray():Array { return this._array; }
        public function dispose():void { this._array = null; }
        public function get disposed():Boolean { return this._array == null; }
    }
}
