package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.habbo.room.events.RoomObjectStateChangedEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.data.IntArrayStuffData;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.events.MouseEvent;

    public class FurnitureAreaHideLogic extends FurnitureMultistateLogic
    {
        override public function getEventTypes():Array
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectWidgetRequestEvent.AREA_HIDE]);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage):void
        {
            super.processUpdateMessage(k);
            var _local_2:RoomObjectDataUpdateMessage = k as RoomObjectDataUpdateMessage;
            if (((_local_2 != null) && (_local_2.data != null)))
            {
                _local_2.data.writeRoomObjectModel(object.getModelController());
                if (object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_REAL_ROOM_OBJECT) == 1)
                {
                    this.setupObject();
                }
            }
        }

        private function setupObject():void
        {
            if (((object == null) || (object.getModelController() == null)))
            {
                return;
            }
            var _local_1:IntArrayStuffData = new IntArrayStuffData();
            _local_1.initializeFromRoomObjectModel(object.getModel());
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_ROOT_X, _local_1.getValue(1));
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_ROOT_Y, _local_1.getValue(2));
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_WIDTH, _local_1.getValue(3));
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_LENGTH, _local_1.getValue(4));
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_INVISIBILITY, ((_local_1.getValue(5) == 1) ? 1 : 0));
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_WALLITEMS, ((_local_1.getValue(6) == 1) ? 1 : 0));
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_INVERT, ((_local_1.getValue(7) == 1) ? 1 : 0));
            object.setState(_local_1.getValue(0), 0);
        }

        override public function useObject():void
        {
            if (((eventDispatcher != null) && (object != null)))
            {
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.AREA_HIDE, object));
            }
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry):void
        {
            if (((k == null) || (_arg_2 == null) || (object == null)))
            {
                return;
            }
            if (k.type != MouseEvent.DOUBLE_CLICK)
            {
                super.mouseEvent(k, _arg_2);
                return;
            }
            var _local_3:RoomObjectEvent;
            if (((k.spriteTag == "turn_on") || (k.spriteTag == "turn_off")))
            {
                _local_3 = new RoomObjectStateChangedEvent(RoomObjectStateChangedEvent.STATE_CHANGE, object);
            }
            else
            {
                _local_3 = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.AREA_HIDE, object);
            }
            if (eventDispatcher != null)
            {
                eventDispatcher.dispatchEvent(_local_3);
            }
        }
    }
}
