package com.sulake.habbo.window.widgets
{
    public interface IProductDisplayInfo
    {
        function get productTypeId():int;
        function get itemTypeId():String;
        function get extraData():String;
        function get petFigureString():String;
        function get botFigureString():String;
        function get figureSetIds():Vector.<int>;
    }
}
