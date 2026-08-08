package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class VariableInfoAndValue
    {
        private var _variable:WiredVariable;
        private var _value:int;

        public function VariableInfoAndValue(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 29, "VariableInfoAndValue");
            this._variable = new WiredVariable(k);
            WiredMessageDataValidator.requireBytes(k, 4, "VariableInfoAndValue value");
            this._value = k.readInteger();
        }

        public function get variable():WiredVariable { return this._variable; }
        public function get value():int { return this._value; }
    }
}
