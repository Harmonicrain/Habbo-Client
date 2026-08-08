package com.sulake.habbo.communication.messages.outgoing.preferences
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    public class SetChatStylePreferenceComposer implements IMessageComposer, IDisposable
    {
        private var _array:Array;

        public function SetChatStylePreferenceComposer(k:int, _arg_2:int=0)
        {
            this._array = new Array();
            super();
            this._array.push(k);
            this._array.push(_arg_2);
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
