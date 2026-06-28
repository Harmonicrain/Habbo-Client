package com.sulake.habbo.room.events
{
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

    public class RoomObjectRoomActionEvent extends RoomObjectEvent
    {
        public static const RORAE_LEAVE_ROOM:String = "RORAE_LEAVE_ROOM";
        public static const RORAE_CHANGE_ROOM:String = "RORAE_CHANGE_ROOM";
        public static const RORAE_TRY_BUS:String = "RORAE_TRY_BUS";

        public function RoomObjectRoomActionEvent(k:String, _arg_2:IRoomObject, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }
    }
}
