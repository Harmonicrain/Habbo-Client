package com.sulake.habbo.roomevents
{
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

    public interface IHabboUserDefinedRoomEvents extends IUnknown 
    {
        function _Str_15677(_arg_1:int, _arg_2:String):void;
        function userSelected(_arg_1:int):void;
        function furnitureSelected(_arg_1:int):void;
        function showInspectButton():Boolean;
        function showToolbarMenuButton():Boolean;
        function inspectObject(_arg_1:int, _arg_2:int):void;
        function openWiredMenu(tab:String = "monitor"):void;
        function hasClickUserWired():Boolean;
        function get isGameMode():Boolean;
        function isWiredFeatureEnabled(_arg_1:int):Boolean;
        function get events():IEventDispatcher;
    }
}
