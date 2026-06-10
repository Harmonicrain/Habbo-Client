package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
{
    /**
     * Slider value converter contract (May §_-113§). Converts between the displayed
     * slider string and the stored wired int param.
     */
    public interface ISliderValueConverter
    {
        function toIntParam(_arg_1:String):int;
        function toString(_arg_1:int):String;
        function get precision():int;
        function get endsWithFive():Boolean;
    }
}
