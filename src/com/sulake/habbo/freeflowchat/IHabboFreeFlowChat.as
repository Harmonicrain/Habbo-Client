package com.sulake.habbo.freeflowchat
{
    import com.sulake.core.runtime.IUnknown;
    import flash.display.DisplayObject;
    import com.sulake.habbo.freeflowchat.style.IChatStyleLibrary;

    public interface IHabboFreeFlowChat extends IUnknown 
    {
        function get displayObject():DisplayObject;
        function get chatStyleLibrary():IChatStyleLibrary;
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
