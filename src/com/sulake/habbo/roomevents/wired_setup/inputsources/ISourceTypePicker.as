package com.sulake.habbo.roomevents.wired_setup.inputsources
{
    public interface ISourceTypePicker
    {
        function initialize(k:Array, _arg_2:int):void;
        function select(k:int):void;
        function dispose():void;
    }
}
