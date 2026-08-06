package com.sulake.habbo.room.utils
{
    import com.sulake.habbo.room.IAreaHideInfo;
    import com.sulake.room.utils.IVector3d;

    public class RoomData 
    {
        private var _roomId:int;
        private var _data:XML;
        private var _floorType:String = null;
        private var _wallType:String = null;
        private var _landscapeType:String = null;
        private var _cameraInitPosition:IVector3d;
        private var _areaHideData:Vector.<IAreaHideInfo>;

        public function RoomData(k:int, data:XML)
        {
            this._roomId = k;
            this._data = data;
        }

        public function get roomId():int
        {
            return this._roomId;
        }

        public function get data():XML
        {
            return this._data;
        }

        public function get floorType():String
        {
            return this._floorType;
        }

        public function set floorType(k:String):void
        {
            this._floorType = k;
        }

        public function get wallType():String
        {
            return this._wallType;
        }

        public function set wallType(k:String):void
        {
            this._wallType = k;
        }

        public function get landscapeType():String
        {
            return this._landscapeType;
        }

        public function set landscapeType(k:String):void
        {
            this._landscapeType = k;
        }

        public function get cameraInitPosition():IVector3d
        {
            return this._cameraInitPosition;
        }

        public function set cameraInitPosition(k:IVector3d):void
        {
            this._cameraInitPosition = k;
        }

        public function get areaHideData():Vector.<IAreaHideInfo>
        {
            return this._areaHideData;
        }

        public function set areaHideData(k:Vector.<IAreaHideInfo>):void
        {
            this._areaHideData = k;
        }
    }
}
