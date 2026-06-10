package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
{
    public class SliderValuePulses implements ISliderValueConverter
    {
        public function SliderValuePulses()
        {
            super();
        }

        public function toIntParam(_arg_1:String):int
        {
            return Math.round(Number(_arg_1) * 2);
        }

        public function toString(_arg_1:int):String
        {
            var _local_2:int = Math.floor(_arg_1 / 2);
            if (_arg_1 % 2 == 0)
            {
                return "" + _local_2;
            }
            return _local_2 + ".5";
        }

        public function get precision():int
        {
            return 1;
        }

        public function get endsWithFive():Boolean
        {
            return true;
        }
    }
}
