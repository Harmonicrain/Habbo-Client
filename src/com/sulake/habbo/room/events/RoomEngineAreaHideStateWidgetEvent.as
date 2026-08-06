package com.sulake.habbo.room.events
{
    public class RoomEngineAreaHideStateWidgetEvent extends RoomEngineObjectEvent
    {
        public static const UPDATE_STATE_AREA_HIDE:String = "RETWE_UPDATE_STATE_AREA_HIDE";

        private var _isOn:Boolean;

        public function RoomEngineAreaHideStateWidgetEvent(k:int, objectId:int, category:int, isOn:Boolean)
        {
            super(UPDATE_STATE_AREA_HIDE, k, objectId, category);
            this._isOn = isOn;
        }

        public function get isOn():Boolean
        {
            return this._isOn;
        }
    }
}
