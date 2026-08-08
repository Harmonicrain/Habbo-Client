package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
{
    public class SliderValueMilliseconds50 implements ISliderValueConverter
    {
        public function SliderValueMilliseconds50()
        {
            super();
        }

        public function toIntParam(_arg_1:String):int
        {
            return int(Number(_arg_1) / 50);
        }

        public function toString(_arg_1:int):String
        {
            return "" + _arg_1 * 50;
        }

        public function get precision():int
        {
            return -1;
        }

        public function get endsWithFive():Boolean
        {
            return true;
        }
    }
}
