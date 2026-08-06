package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    public class RequestWiredCapabilitiesMessageComposer implements IMessageComposer, IDisposable
    {
        private var _array:Array;

        public function RequestWiredCapabilitiesMessageComposer(k:int, _arg_2:int, _arg_3:int)
        {
            this._array = [k, _arg_2, _arg_3];
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
            return this._array == null;
        }
    }
}
