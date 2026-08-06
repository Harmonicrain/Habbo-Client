package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    public class UpdateAddonMessageComposer implements IMessageComposer, IDisposable
    {
        private var _array:Array;

        public function UpdateAddonMessageComposer(k:int, _arg_2:Array, _arg_3:Array, _arg_4:String, _arg_5:Array, _arg_6:Array, _arg_7:Array, _arg_8:Array)
        {
            this._array = [];
            this.appendDefinition(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
        }

        private function appendDefinition(k:int, _arg_2:Array, _arg_3:Array, _arg_4:String, _arg_5:Array, _arg_6:Array, _arg_7:Array, _arg_8:Array):void
        {
            this._array.push(k);
            this.appendIntArray(_arg_2);
            this._array.push((_arg_4 != null) ? _arg_4 : "");
            this.appendIntArray(_arg_5);
            this.appendIntArray(_arg_7);
            this.appendIntArray(_arg_8);
            this.appendStringArray(_arg_3);
            this.appendIntArray(_arg_6);
        }

        private function appendIntArray(k:Array):void
        {
            if (k == null) { k = []; }
            this._array.push(k.length);
            for each (var _local_2:int in k) { this._array.push(_local_2); }
        }

        private function appendStringArray(k:Array):void
        {
            if (k == null) { k = []; }
            this._array.push(k.length);
            for each (var _local_2:String in k) { this._array.push(_local_2); }
        }

        public function getMessageArray():Array { return this._array; }
        public function dispose():void { this._array = null; }
        public function get disposed():Boolean { return this._array == null; }
    }
}
