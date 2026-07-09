package com.sulake.habbo.window.widgets
{
    import com.sulake.core.window.IWidget;

    public interface IProductIconWidget extends IWidget
    {
        function set productInfo(value:IProductDisplayInfo):*;
        function get productInfo():IProductDisplayInfo;
        function set blend(value:Number):*;
        function get blend():Number;
        function set unknownImageUri(value:String):void;
    }
}
