package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.data.MapStuffData;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.utils.getTimer;

    public class FurnitureChestLogic extends FurnitureLogic
    {
        private static const IS_WIRED_ENABLED_KEY:String = "is_wired_enabled";

        private var _isWiredEnabled:Boolean = false;

        override public function processUpdateMessage(message:RoomObjectUpdateMessage):void
        {
            super.processUpdateMessage(message);

            var dataUpdate:RoomObjectDataUpdateMessage = message as RoomObjectDataUpdateMessage;
            if (dataUpdate == null)
            {
                return;
            }

            var mapData:MapStuffData = dataUpdate.data as MapStuffData;
            if (mapData == null)
            {
                return;
            }

            var isWiredEnabled:Boolean = mapData.getValue(IS_WIRED_ENABLED_KEY) == "1";
            if (isWiredEnabled != this._isWiredEnabled)
            {
                this._isWiredEnabled = isWiredEnabled;
                object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_CHEST_IS_WIRED_ENABLED, isWiredEnabled ? 1 : 0);
                update(getTimer());
            }
        }
    }
}
