package com.sulake.habbo.room
{
    import com.sulake.room.IRoomInstance;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.habbo.room.utils.FurniStackingHeightMap;
    import com.sulake.habbo.room.utils.LegacyWallGeometry;
    import com.sulake.habbo.room.utils.TileObjectMap;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.session.ISessionDataManager;

    public interface IRoomCreator extends IRoomObjectCreator 
    {
        function initializeRoom(_arg_1:int, _arg_2:XML):void;
        function getRoom(_arg_1:int):IRoomInstance;
        function disposeRoom(_arg_1:int):void;
        function setOwnUserId(_arg_1:int, _arg_2:int):void;
        function setWorldType(_arg_1:int, _arg_2:String, _arg_3:Boolean=false):void;
        function getWorldType(_arg_1:int):String;
        function getPublicRoomContentType(_arg_1:String):String;
        function getObjectRoom(_arg_1:int):IRoomObjectController;
        function setFurniStackingHeightMap(_arg_1:int, _arg_2:FurniStackingHeightMap):void;
        function getFurniStackingHeightMap(_arg_1:int):FurniStackingHeightMap;
        function getLegacyGeometry(_arg_1:int):LegacyWallGeometry;
        function getTileObjectMap(_arg_1:int):TileObjectMap;
        function getRoomNumberValue(_arg_1:int, _arg_2:String):Number;
        function getRoomStringValue(_arg_1:int, _arg_2:String):String;
        function isRoomObjectContentAvailable(_arg_1:String):Boolean;
        function setIsPlayingGame(_arg_1:int, _arg_2:Boolean):void;
        function refreshTileObjectMap(_arg_1:int, _arg_2:String):void;
        function get configuration():IHabboConfigurationManager;
        function get roomSessionManager():IRoomSessionManager;
        function get sessionDataManager():ISessionDataManager;
    }
}
