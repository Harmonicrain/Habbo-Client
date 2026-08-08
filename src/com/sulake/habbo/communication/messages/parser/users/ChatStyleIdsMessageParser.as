package com.sulake.habbo.communication.messages.parser.users
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class ChatStyleIdsMessageParser implements IMessageParser
    {
        private var _styleIds:Array;

        public function get styleIds():Array
        {
            return this._styleIds;
        }

        public function flush():Boolean
        {
            this._styleIds = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            var _local_3:int;
            this._styleIds = [];
            var _local_2:int = k.readInteger();
            while (_local_3 < _local_2)
            {
                this._styleIds.push(k.readInteger());
                _local_3++;
            }
            return true;
        }
    }
}
