package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    // Wired 2.0 save format. Signature unchanged; quantifierCode (type-specific) is
    // sent as 0 for existing conditions; _arg_5=legacy stuffTypeSelectionCode (ignored).
    // New source/variable/stuffIds2 arrays sent empty for existing wired.
    public class UpdateConditionMessageComposer implements IMessageComposer, IDisposable
    {
        private var _array:Array;

        public function UpdateConditionMessageComposer(k:int, _arg_2:Array, _arg_3:String, _arg_4:Array, _arg_5:int)
        {
            var _i:int;
            this._array = new Array();
            super();
            this._array.push(k);                       // id
            this._array.push(_arg_2.length);           // intParams
            for each (_i in _arg_2) { this._array.push(_i); }
            this._array.push(_arg_3);                  // stringParam
            this._array.push(_arg_4.length);           // stuffIds
            for each (_i in _arg_4) { this._array.push(_i); }
            this._array.push(0);                       // quantifierCode (type-specific; 0 for existing)
            this._array.push(0);                       // furniSourceTypes count
            this._array.push(0);                       // userSourceTypes count
            this._array.push(0);                       // variableIds count
            this._array.push(0);                       // stuffIds2 count
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
