package com.sulake.habbo.communication.messages.parser.habbicons
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class HabbiconMessengerHistoryEntry
    {
        private var _senderId:int;
        private var _senderName:String;
        private var _senderFigure:String;
        private var _content:HabbiconMessengerContent;
        private var _secondsSinceSent:int;
        private var _messageId:String;

        public function HabbiconMessengerHistoryEntry(wrapper:IMessageDataWrapper)
        {
            this._senderId = wrapper.readInteger();
            this._senderName = wrapper.readString();
            this._senderFigure = wrapper.readString();
            this._content = new HabbiconMessengerContent(wrapper);
            this._secondsSinceSent = wrapper.readInteger();
            this._messageId = wrapper.readString();
        }

        public function get senderId():int
        {
            return this._senderId;
        }

        public function get senderName():String
        {
            return this._senderName;
        }

        public function get senderFigure():String
        {
            return this._senderFigure;
        }

        public function get content():HabbiconMessengerContent
        {
            return this._content;
        }

        public function get secondsSinceSent():int
        {
            return this._secondsSinceSent;
        }

        public function get messageId():String
        {
            return this._messageId;
        }
    }
}
