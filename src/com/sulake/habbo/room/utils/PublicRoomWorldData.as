package com.sulake.habbo.room.utils
{
    public class PublicRoomWorldData
    {
        private var _name:String = "";
        private var _scale:Number = 1;
        private var _heightScale:Number = 1;

        public function PublicRoomWorldData(k:String, _arg_2:Number, _arg_3:Number)
        {
            super();
            this._name = k;
            this._scale = _arg_2;
            this._heightScale = _arg_3;
        }

        public function get name():String
        {
            return this._name;
        }

        public function get scale():Number
        {
            return this._scale;
        }

        public function get heightScale():Number
        {
            return this._heightScale;
        }
    }
}
