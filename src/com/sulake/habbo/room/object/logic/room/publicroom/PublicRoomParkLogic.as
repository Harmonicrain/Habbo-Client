package com.sulake.habbo.room.object.logic.room.publicroom
{
    import com.sulake.habbo.room.events.RoomObjectRoomActionEvent;
    import com.sulake.habbo.room.object.logic.room.RoomLogic;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.events.MouseEvent;

    public class PublicRoomParkLogic extends RoomLogic
    {
        private static const BUS:String = "bus";
        private static const BUS_OPEN:String = "bus_oviopen_hidden";
        private static const GOAWAY_BUS:String = "goawaybus";

        public function PublicRoomParkLogic()
        {
            super();
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry):void
        {
            super.mouseEvent(k, _arg_2);
            if (((k == null) || (object == null)))
            {
                return;
            }
            if (k.type == MouseEvent.CLICK)
            {
                var _local_3:String = k.spriteTag;
                var _local_4:RoomObjectRoomActionEvent;
                if (((_local_3 == BUS) || (_local_3 == BUS_OPEN)))
                {
                    _local_4 = new RoomObjectRoomActionEvent(RoomObjectRoomActionEvent.RORAE_TRY_BUS, object);
                }
                else if (_local_3 == GOAWAY_BUS)
                {
                    _local_4 = new RoomObjectRoomActionEvent(RoomObjectRoomActionEvent.RORAE_CHANGE_ROOM, object);
                }
                if (((!(_local_4 == null)) && (!(eventDispatcher == null))))
                {
                    eventDispatcher.dispatchEvent(_local_4);
                }
            }
        }
    }
}
