package com.sulake.habbo.window.widgets
{
    import com.sulake.core.window.IWidget;

    /** July inventory-grid overlay shown for chest categories 24 and 25. */
    public interface IChestItemGridOverlayWidget extends IWidget
    {
        function set contentsCount(value:int):void;
        function get contentsCount():int;
        function set color(value:String):void;
        function get color():String;
    }
}
