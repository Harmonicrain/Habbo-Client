package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
{
    public class SliderValueHundredth implements ISliderValueConverter
    {
        public function SliderValueHundredth()
        {
            super();
        }

        public function toIntParam(_arg_1:String):int
        {
            return Math.round(Number(_arg_1) * 100);
        }

        public function toString(_arg_1:int):String
        {
            return (_arg_1 / 100).toFixed(2);
        }

        public function get precision():int
        {
            return 2;
        }

        public function get endsWithFive():Boolean
        {
            return false;
        }
    }
}
