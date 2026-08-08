package com.sulake.core.communication.util
{
    /**
     * Marks a composer value that must be encoded as one signed protocol
     * 64-bit integer. ActionScript Number remains exact for the database IDs
     * used by the client (up to 2^53).
     */
    public final class Long
    {
        private var _value:Number;

        public function Long(value:Number)
        {
            this._value = value;
        }

        public function get high():int
        {
            return int(Math.floor(this._value / 4294967296));
        }

        public function get low():uint
        {
            return uint(this._value - Number(this.high) * 4294967296);
        }

        public function get value():Number
        {
            return this._value;
        }
    }
}
