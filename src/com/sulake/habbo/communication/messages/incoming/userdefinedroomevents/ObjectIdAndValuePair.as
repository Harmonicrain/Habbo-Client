package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class ObjectIdAndValuePair
    {
        private var _objectId:int;
        private var _value:int;

        public function ObjectIdAndValuePair(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 8, "Wired holder value");
            this._objectId = k.readInteger();
            this._value = k.readInteger();
        }

        public function get objectId():int { return this._objectId; }
        public function get value():int { return this._value; }
    }
}
