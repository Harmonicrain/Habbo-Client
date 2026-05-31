package com.sulake.habbo.communication.messages.incoming.room.engine
{
    public class PublicRoomObjectMessageData
    {
        private var _hasDimensions:Boolean;
        private var _id:String;
        private var _type:String;
        private var _x:int;
        private var _y:int;
        private var _z:int;
        private var _direction:int;
        private var _sizeX:int;
        private var _sizeY:int;

        public function PublicRoomObjectMessageData(k:Boolean, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:int, _arg_9:int)
        {
            this._hasDimensions = k;
            this._id = _arg_2;
            this._type = _arg_3;
            this._x = _arg_4;
            this._y = _arg_5;
            this._z = _arg_6;
            this._direction = _arg_7;
            this._sizeX = _arg_8;
            this._sizeY = _arg_9;
        }

        public function get hasDimensions():Boolean
        {
            return this._hasDimensions;
        }

        public function get id():String
        {
            return this._id;
        }

        public function get type():String
        {
            return this._type;
        }

        public function get x():int
        {
            return this._x;
        }

        public function get y():int
        {
            return this._y;
        }

        public function get z():int
        {
            return this._z;
        }

        public function get direction():int
        {
            return this._direction;
        }

        public function get sizeX():int
        {
            return this._sizeX;
        }

        public function get sizeY():int
        {
            return this._sizeY;
        }
    }
}
