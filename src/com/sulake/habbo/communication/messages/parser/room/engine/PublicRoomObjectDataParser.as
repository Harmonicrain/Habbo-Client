package com.sulake.habbo.communication.messages.parser.room.engine
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.room.engine.PublicRoomObjectMessageData;

    public class PublicRoomObjectDataParser
    {
        public static function parseObjectData(k:IMessageDataWrapper):PublicRoomObjectMessageData
        {
            var _local_2:Boolean = k.readBoolean();
            var _local_3:String = k.readString();
            var _local_4:String = k.readString();
            var _local_5:int = k.readInteger();
            var _local_6:int = k.readInteger();
            var _local_7:int = k.readInteger();
            var _local_8:int = 0;
            var _local_9:int = 0;
            var _local_10:int = 0;
            if (!_local_2)
            {
                _local_8 = (k.readInteger() * 45);
            }
            else
            {
                _local_9 = k.readInteger();
                _local_10 = k.readInteger();
            }
            return new PublicRoomObjectMessageData(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10);
        }
    }
}
