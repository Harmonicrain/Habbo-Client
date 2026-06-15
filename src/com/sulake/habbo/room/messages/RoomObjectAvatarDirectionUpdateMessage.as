package com.sulake.habbo.room.messages
{
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.IVector3d;

    public class RoomObjectAvatarDirectionUpdateMessage extends RoomObjectUpdateMessage
    {
        private var _dirHead:int;

        public function RoomObjectAvatarDirectionUpdateMessage(k:IVector3d, _arg_2:IVector3d, _arg_3:int)
        {
            super(k, _arg_2);
            this._dirHead = _arg_3;
        }

        public function get dirHead():int
        {
            return this._dirHead;
        }
    }
}
