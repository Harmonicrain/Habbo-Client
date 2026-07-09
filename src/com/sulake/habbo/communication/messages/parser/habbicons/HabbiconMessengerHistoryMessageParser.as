package com.sulake.habbo.communication.messages.parser.habbicons
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class HabbiconMessengerHistoryMessageParser implements IMessageParser
    {
        private var _chatId:int;
        private var _entries:Array;

        public function flush():Boolean
        {
            this._chatId = 0;
            this._entries = [];
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            var count:int;
            var index:int;
            this._chatId = wrapper.readInteger();
            this._entries = [];
            count = wrapper.readInteger();
            index = 0;
            while (index < count)
            {
                this._entries.push(new HabbiconMessengerHistoryEntry(wrapper));
                index++;
            }
            return true;
        }

        public function get chatId():int
        {
            return this._chatId;
        }

        public function get entries():Array
        {
            return this._entries;
        }
    }
}
