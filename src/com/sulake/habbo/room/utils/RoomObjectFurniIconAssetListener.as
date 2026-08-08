package com.sulake.habbo.room.utils
{
    public class RoomObjectFurniIconAssetListener
    {
        private var _roomId:int;
        private var _objectId:int;
        private var _category:int;

        public function RoomObjectFurniIconAssetListener(roomId:int, objectId:int, category:int)
        {
            this._roomId = roomId;
            this._objectId = objectId;
            this._category = category;
        }

        public function get roomId():int
        {
            return this._roomId;
        }

        public function get objectId():int
        {
            return this._objectId;
        }

        public function get category():int
        {
            return this._category;
        }
    }
}
