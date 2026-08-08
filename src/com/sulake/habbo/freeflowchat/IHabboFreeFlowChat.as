package com.sulake.habbo.freeflowchat
{
    import com.sulake.core.runtime.IUnknown;
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import com.sulake.habbo.freeflowchat.style.IChatStyleLibrary;

    public interface IHabboFreeFlowChat extends IUnknown
    {
        function get displayObject():DisplayObject;
        function get chatStyleLibrary():IChatStyleLibrary;
        function createChatStylePreviewBitmap(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:String):BitmapData;
        function get isDisabledInPreferences():Boolean;
        function set isDisabledInPreferences(_arg_1:Boolean):void;
        function get preferedChatStyle():int;
        function set preferedChatStyle(_arg_1:int):void;
        function get chatFontSizeMode():int;
        function set chatFontSizeMode(_arg_1:int):void;
        function get chatFontSizeScale():Number;
        function isNotificationStyle(_arg_1:int):Boolean;
        function clear():void;
        function toggleVisibility():void;
    }
}
