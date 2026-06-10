package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.interfaces
{
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.IWiredUIPreset;

    public interface IListPreset extends IWiredUIPreset
    {
        function get spacing():int;
        function set spacing(_arg_1:int):void;
        function set backgroundColor(_arg_1:uint):void;
    }
}
