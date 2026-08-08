package com.sulake.habbo.catalog.habbicons
{
    import flash.events.Event;

    public class HabbiconControllerEvent extends Event
    {
        public static const OWNED_HABBICONS_UPDATED:String = "hce_owned_habbicons_updated";
        public static const SHOP_DATA_UPDATED:String = "hce_shop_data_updated";
        public static const STATUS_CHANGED:String = "hce_habbicon_status_changed";
        public static const RECENT_HABBICONS_UPDATED:String = "hce_recent_habbicons_updated";
        public static const ROOM_USE_HABBICON:String = "hce_room_use_habbicon";

        private var _habbiconId:int;
        private var _collectionId:int;
        private var _roomIndex:int;

        public function HabbiconControllerEvent(type:String, habbiconId:int = 0, collectionId:int = 0, roomIndex:int = 0)
        {
            super(type, false, false);
            this._habbiconId = habbiconId;
            this._collectionId = collectionId;
            this._roomIndex = roomIndex;
        }

        public function get habbiconId():int
        {
            return this._habbiconId;
        }

        public function get collectionId():int
        {
            return this._collectionId;
        }

        public function get roomIndex():int
        {
            return this._roomIndex;
        }

        override public function clone():Event
        {
            return new HabbiconControllerEvent(type, this._habbiconId, this._collectionId, this._roomIndex);
        }
    }
}
