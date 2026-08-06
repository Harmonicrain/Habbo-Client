package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    public class WiredMenuComposer implements IMessageComposer, IDisposable
    {
        protected var _data:Array;

        public function WiredMenuComposer(data:Array = null)
        {
            this._data = data == null ? [] : data;
        }

        public function getMessageArray():Array { return this._data; }
        public function dispose():void { this._data = null; }
        public function get disposed():Boolean { return this._data == null; }
    }
}
