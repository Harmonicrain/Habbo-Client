package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;

    public interface IChestSubController extends IDisposable
    {
        function get type():int;
        function get title():String;
        function get view():IWindowContainer;
        function get isEmpty():Boolean;
        function get itemCount():int;
        function clear():void;
        function updateUI():void;
        function get allowResizing():Boolean;
    }
}
