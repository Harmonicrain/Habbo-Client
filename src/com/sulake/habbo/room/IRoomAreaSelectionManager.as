package com.sulake.habbo.room
{
    import com.sulake.habbo.room.events.RoomObjectTileMouseEvent;

    public interface IRoomAreaSelectionManager
    {
        function activate(_arg_1:Function, _arg_2:String):Boolean;
        function deactivate():void;
        function startSelecting():void;
        function handleTileMouseEvent(_arg_1:RoomObjectTileMouseEvent):void;
        function finishSelecting():Boolean;
        function clearHighlight():void;
        function setHighlight(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void;
        function get areaSelectionState():int;
        function dispose():void;
    }
}
