package com.sulake.habbo.roomevents.wired_setup.uibuilder
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SpacerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;

    /**
     * Wired 2.0 UI preset contract (May IWiredUIPreset). A preset wraps one editor
     * widget (or layout) and exposes a single backing window plus fluent decorators.
     */
    public interface IWiredUIPreset extends IDisposable
    {
        function get window():IWindow;
        function resizeToWidth(_arg_1:int):void;
        function hasStaticWidth():Boolean;
        function get staticWidth():int;

        function alignRight():WiredUIPreset;
        function alignCenter():WiredUIPreset;
        function staticHeight(_arg_1:int):WiredUIPreset;
        function floatVertically():WiredUIPreset;
        function wrapWindow(_arg_1:IWindow, _arg_2:Boolean = false):WiredUIPreset;
        function noDisable():WiredUIPreset;
        function halfBlend():WiredUIPreset;

        function set disabled(_arg_1:Boolean):void;
        function updateDisabledState():void;
        function get disabled():Boolean;

        function set visible(_arg_1:Boolean):void;
        function get visible():Boolean;

        function set blendSpacer(_arg_1:SpacerPreset):void;
    }
}
