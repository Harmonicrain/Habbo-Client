package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    public class UpdateSelectorMessageComposer implements IMessageComposer, IDisposable
    {
        private var _array:Array;

        public function UpdateSelectorMessageComposer(k:int, _arg_2:Array, _arg_3:String, _arg_4:Array, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Array = null, _arg_8:Array = null, _arg_9:Array = null, _arg_10:Array = null)
        {
            var _i:int;
            var _s:String;
            this._array = new Array();
            super();
            if (_arg_7 == null) { _arg_7 = []; }
            if (_arg_8 == null) { _arg_8 = []; }
            if (_arg_9 == null) { _arg_9 = []; }
            if (_arg_10 == null) { _arg_10 = []; }
            this._array.push(k);
            this._array.push(_arg_2.length);
            for each (_i in _arg_2) { this._array.push(_i); }
            this._array.push(_arg_3);
            this._array.push(_arg_4.length);
            for each (_i in _arg_4) { this._array.push(_i); }
            this._array.push(_arg_5);
            this._array.push(_arg_6);
            this._array.push(_arg_7.length);
            for each (_i in _arg_7) { this._array.push(_i); }
            this._array.push(_arg_8.length);
            for each (_i in _arg_8) { this._array.push(_i); }
            this._array.push(_arg_9.length);
            for each (_s in _arg_9) { this._array.push(_s); }
            this._array.push(_arg_10.length);
            for each (_i in _arg_10) { this._array.push(_i); }
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
