package com.sulake.core.communication.util
{
    /** Marks a composer value that must be encoded as one signed protocol byte. */
    public final class Byte
    {
        private var _value:int;
        public function Byte(value:int) { this._value = value; }
        public function get value():int { return this._value; }
    }
}
