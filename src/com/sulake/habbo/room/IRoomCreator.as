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
    import com.sulake.room.utils.IVector3d;

    public interface IRoomCreator extends IRoomObjectCreator 
    {
        function initializeRoom(_arg_1:int, _arg_2:XML, _arg_3:IVector3d=null, _arg_4:Vector.<IAreaHideInfo>=null):void;
        function getRoom(_arg_1:int):IRoomInstance;
        function disposeRoom(_arg_1:int):void;
        function setOwnUserId(_arg_1:int, _arg_2:int):void;
        function setWorldType(_arg_1:int, _arg_2:String, _arg_3:Boolean=false):void;
        function updatePublicRoomParkBusDoor(_arg_1:int, _arg_2:Boolean):void;
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
        function setHanditemControlBlocked(_arg_1:int, _arg_2:Boolean):void;
        function setChooserDisabled(_arg_1:int, _arg_2:Boolean):void;
        function setFreeFurniMovementsMode(_arg_1:int, _arg_2:Boolean):void;
        function setInvisibleFurni(_arg_1:int, _arg_2:Boolean):void;
        function refreshTileObjectMap(_arg_1:int, _arg_2:String):void;
        function updateAreaHide(_arg_1:int, _arg_2:int, _arg_3:Boolean, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:Boolean):void;
        function get configuration():IHabboConfigurationManager;
        function get roomSessionManager():IRoomSessionManager;
        function get sessionDataManager():ISessionDataManager;
    }
}
