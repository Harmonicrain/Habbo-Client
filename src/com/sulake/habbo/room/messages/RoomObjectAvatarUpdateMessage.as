package com.sulake.habbo.room.messages
{
    import com.sulake.room.utils.IVector3d;

    public class RoomObjectAvatarUpdateMessage extends RoomObjectMoveUpdateMessage
    {
        private var _dirHead:int;
        private var _canStandUp:Boolean;
        private var _baseY:Number;
        private var _jumpingPower:Number;

        public function RoomObjectAvatarUpdateMessage(k:IVector3d, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:int, _arg_5:Boolean, _arg_6:Number, _arg_7:Number=NaN, _arg_8:Boolean=false, _arg_9:Number=NaN)
        {
            super(k, _arg_2, _arg_3, _arg_7, false, _arg_8);
            this._dirHead = _arg_4;
            this._canStandUp = _arg_5;
            this._baseY = _arg_6;
            this._jumpingPower = _arg_9;
        }

        public function get jumpingPower():Number
        {
            return this._jumpingPower;
        }

        public function get dirHead():int
        {
            return this._dirHead;
        }

        public function get canStandUp():Boolean
        {
            return this._canStandUp;
        }

        public function get baseY():Number
        {
            return this._baseY;
        }
    }
}
