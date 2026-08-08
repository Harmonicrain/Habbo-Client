package com.sulake.habbo.room.messages
{
    public class RoomObjectAvatarHabbiconUpdateMessage extends RoomObjectUpdateStateMessage
    {
        private var _habbiconId:int;

        public function RoomObjectAvatarHabbiconUpdateMessage(habbiconId:int)
        {
            this._habbiconId = habbiconId;
        }

        public function get habbiconId():int
        {
            return this._habbiconId;
        }
    }
}
