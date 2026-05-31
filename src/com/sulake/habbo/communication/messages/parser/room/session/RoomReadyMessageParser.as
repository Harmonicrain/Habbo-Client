package com.sulake.habbo.communication.messages.parser.room.session
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class RoomReadyMessageParser implements IMessageParser
    {
        private var _roomType:String = "";
        private var _roomId:int = 0;
        private var _isPublic:Boolean = false;


        public function get roomType():String
        {
            return this._roomType;
        }

        public function get roomId():int
        {
            return this._roomId;
        }

        public function get isPublic():Boolean
        {
            return this._isPublic;
        }

        public function flush():Boolean
        {
            this._roomType = "";
            this._roomId = 0;
            this._isPublic = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            this._roomType = k.readString();
            this._roomId = k.readInteger();
            this._isPublic = k.readBoolean();
            return true;
        }
    }
}
