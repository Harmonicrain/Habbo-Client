package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
{
    public class SliderValueCountOrUnlimited implements ISliderValueConverter
    {
        private var _unlimitedValue:int;

        public function SliderValueCountOrUnlimited(_arg_1:int)
        {
            super();
            this._unlimitedValue = _arg_1;
        }

        public function toIntParam(_arg_1:String):int
        {
            return int(Number(_arg_1));
        }

        public function toString(_arg_1:int):String
        {
            if (_arg_1 == this._unlimitedValue)
            {
                return "∞";
            }
            return "" + _arg_1;
        }

        public function get precision():int
        {
            return 0;
        }

        public function get endsWithFive():Boolean
        {
            return false;
        }
    }
}
