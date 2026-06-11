package com.sulake.habbo.freeflowchat.viewer.visualization.style
{
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.text.StyleSheet;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public interface IChatStyleInternal 
    {
        function getNewBackgroundSprite(_arg_1:uint=0xFFFFFF):Sprite;
        function get textFormat():TextFormat;
        function get styleSheet():StyleSheet;
        function get pointer():BitmapData;
        function get _Str_8470():int;
        function get pointerOffsetToBubbleBottom():int;
        function getPointerLeftMargin(_arg_1:int):int;
        function getPointerRightMargin(_arg_1:int):int;
        function get _Str_5505():Point;
        function get faceOffset():Point;
        function getEmblem(_arg_1:Boolean=false):BitmapData;
        function getEmblemOffset(_arg_1:Boolean=false):Point;
        function get iconImage():BitmapData;
        function get textFieldMargins():Rectangle;
        function get overlap():Rectangle;
        function get allowHTML():Boolean;
        function get _Str_4931():Boolean;
        function get isAnonymous():Boolean;
        function get isSystemStyle():Boolean;
        function get isNotification():Boolean;
    }
}
