package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
{
    public class SliderValueSeconds5 implements ISliderValueConverter
    {
        public function SliderValueSeconds5()
        {
            super();
        }

        public function toIntParam(_arg_1:String):int
        {
            return Math.round(Number(_arg_1) / 5);
        }

        public function toString(_arg_1:int):String
        {
            return String(_arg_1 * 5);
        }

        public function get precision():int
        {
            return 0;
        }

        public function get endsWithFive():Boolean
        {
            return true;
        }
    }
}
