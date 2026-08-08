package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
{
    /**
     * Identity converter (May §_-6Y§, CONVERTER_ECHO): displayed value == stored int.
     */
    public class SliderValueEcho implements ISliderValueConverter
    {
        public function SliderValueEcho()
        {
            super();
        }

        public function toIntParam(_arg_1:String):int
        {
            return int(_arg_1);
        }

        public function toString(_arg_1:int):String
        {
            return _arg_1.toString();
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
