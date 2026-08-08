package com.sulake.habbo.communication.messages.parser.habbicons
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class RoomUserHabbiconMessageParser implements IMessageParser
    {
        private var _roomIndex:int;
        private var _habbiconId:int;

        public function get roomIndex():int
        {
            return this._roomIndex;
        }

        public function get habbiconId():int
        {
            return this._habbiconId;
        }

        public function flush():Boolean
        {
            this._roomIndex = 0;
            this._habbiconId = 0;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            this._roomIndex = wrapper.readInteger();
            this._habbiconId = wrapper.readInteger();
            return true;
        }
    }
}
