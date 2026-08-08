package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class WiredValidationErrorParameter
    {
        private var _key:String;
        private var _value:String;

        public function WiredValidationErrorParameter(k:IMessageDataWrapper)
        {
            this._key = k.readString();
            this._value = k.readString();
        }

        public function get key():String
        {
            return this._key;
        }

        public function get value():String
        {
            return this._value;
        }
    }
}
