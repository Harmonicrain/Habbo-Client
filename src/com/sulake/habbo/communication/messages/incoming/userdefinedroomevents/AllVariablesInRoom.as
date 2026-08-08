package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class AllVariablesInRoom
    {
        private var _hash:int;
        private var _variables:Array;

        public function AllVariablesInRoom(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 4, "AllVariablesInRoom");
            this._hash = k.readInteger();
        }

        public function get variables():Array { return this._variables; }
        public function get needsSynchronize():Boolean { return this._variables == null; }
        public function get hash():int { return this._hash; }

        public function synchronize(k:Array):void
        {
            this._variables = k != null ? k.concat() : [];
        }
    }
}
