package com.sulake.habbo.roomevents.wired_setup.common.utils
{
    public class ChronoFieldRangeFilter
    {
        private var _name:String;
        private var _useFilter:Boolean;
        private var _min:int;
        private var _max:int;
        private var _defaultValue:int;

        public function ChronoFieldRangeFilter(name:String, useFilter:Boolean, min:int, max:int, defaultValue:int = 0)
        {
            this._name = name;
            this._useFilter = useFilter;
            this._min = min;
            this._max = max;
            this._defaultValue = defaultValue;
        }

        public function get name():String { return this._name; }
        public function get useFilter():Boolean { return this._useFilter; }
        public function get min():int { return this._min; }
        public function get max():int { return this._max; }
        public function get defaultValue():int { return this._defaultValue; }
    }
}
