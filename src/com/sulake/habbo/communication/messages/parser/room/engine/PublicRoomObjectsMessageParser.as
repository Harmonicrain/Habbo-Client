package com.sulake.habbo.communication.messages.parser.room.engine
{
    import __AS3__.vec.Vector;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.PublicRoomObjectMessageData;

    public class PublicRoomObjectsMessageParser implements IMessageParser
    {
        private var _roomId:int;
        private var _roomCategory:int;
        private var _objects:Vector.<PublicRoomObjectMessageData>;

        public function get roomId():int
        {
            return this._roomId;
        }

        public function get roomCategory():int
        {
            return this._roomCategory;
        }

        public function get objects():Vector.<PublicRoomObjectMessageData>
        {
            return this._objects;
        }

        public function flush():Boolean
        {
            this._roomId = 0;
            this._roomCategory = 0;
            this._objects = new Vector.<PublicRoomObjectMessageData>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            this._roomId = k.readInteger();
            this._roomCategory = k.readInteger();
            this._objects = new Vector.<PublicRoomObjectMessageData>();
            var _local_2:int = k.readInteger();
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                this._objects.push(PublicRoomObjectDataParser.parseObjectData(k));
                _local_3++;
            }
            return true;
        }
    }
}
