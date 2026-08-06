package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    public class WiredClickUserMessageComposer implements IMessageComposer, IDisposable
    {
        private var _array:Array;

        public function WiredClickUserMessageComposer(k:int, heldTicks:int=0)
        {
            this._array = new Array();
            super();
            this._array.push(k);
            this._array.push(Math.max(0, Math.min(1728000, heldTicks)));
        }

        public function getMessageArray():Array
        {
            return this._array;
        }

        public function dispose():void
        {
            this._array = null;
        }

        public function get disposed():Boolean
        {
            return false;
        }
    }
}
