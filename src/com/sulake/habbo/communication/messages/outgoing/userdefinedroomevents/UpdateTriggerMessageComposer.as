package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    // Wired 2.0 save format. Old callers can omit source/variable/stuffIds2 arrays.
    public class UpdateTriggerMessageComposer implements IMessageComposer, IDisposable
    {
        private var _array:Array;

        public function UpdateTriggerMessageComposer(k:int, _arg_2:Array, _arg_3:String, _arg_4:Array, _arg_5:int, _arg_6:Array = null, _arg_7:Array = null, _arg_8:Array = null, _arg_9:Array = null)
        {
            var _i:int;
            var _s:String;
            this._array = new Array();
            super();
            if (_arg_6 == null) { _arg_6 = []; }
            if (_arg_7 == null) { _arg_7 = []; }
            if (_arg_8 == null) { _arg_8 = []; }
            if (_arg_9 == null) { _arg_9 = []; }
            this._array.push(k);                       // id
            this._array.push(_arg_2.length);           // intParams
            for each (_i in _arg_2) { this._array.push(_i); }
            this._array.push(_arg_3);                  // stringParam
            this._array.push(_arg_4.length);           // stuffIds
            for each (_i in _arg_4) { this._array.push(_i); }
            // (trigger: no type-specific field)
            this._array.push(_arg_6.length);           // furniSourceTypes
            for each (_i in _arg_6) { this._array.push(_i); }
            this._array.push(_arg_7.length);           // userSourceTypes
            for each (_i in _arg_7) { this._array.push(_i); }
            this._array.push(_arg_8.length);           // variableIds
            for each (_s in _arg_8) { this._array.push(_s); }
            this._array.push(_arg_9.length);           // stuffIds2
            for each (_i in _arg_9) { this._array.push(_i); }
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
