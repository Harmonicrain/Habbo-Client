package com.sulake.habbo.room.events
{
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

    public class RoomObjectFurniIconAssetEvent extends RoomObjectEvent
    {
        public static const LOAD_FURNI_ICON:String = "ROFIAE_LOAD_FURNI_ICON";

        private var _wallItem:Boolean;
        private var _typeId:int;
        private var _extra:String;

        public function RoomObjectFurniIconAssetEvent(type:String, object:IRoomObject, wallItem:Boolean, typeId:int, extra:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, object, bubbles, cancelable);
            this._wallItem = wallItem;
            this._typeId = typeId;
            this._extra = extra == null ? "" : extra;
        }

        public function get wallItem():Boolean
        {
            return this._wallItem;
        }

        public function get typeId():int
        {
            return this._typeId;
        }

        public function get extra():String
        {
            return this._extra;
        }
    }
}
