package com.sulake.habbo.room.messages
{
    import com.sulake.room.messages.RoomObjectUpdateMessage;

    public class RoomObjectFurniIconUpdateMessage extends RoomObjectUpdateMessage
    {
        public static const FURNI_ICON_LOADED:String = "ROFIUM_FURNI_ICON_LOADED";

        private var _assetName:String;
        private var _wallItem:Boolean;
        private var _typeId:int;
        private var _extra:String;

        public function RoomObjectFurniIconUpdateMessage(assetName:String, wallItem:Boolean, typeId:int, extra:String)
        {
            super(null, null);
            this._assetName = assetName == null ? "" : assetName;
            this._wallItem = wallItem;
            this._typeId = typeId;
            this._extra = extra == null ? "" : extra;
        }

        public function get assetName():String
        {
            return this._assetName;
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
