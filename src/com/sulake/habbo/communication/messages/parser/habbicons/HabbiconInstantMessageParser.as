package com.sulake.habbo.communication.messages.parser.habbicons
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class HabbiconInstantMessageParser implements IMessageParser
    {
        private var _chatId:int;
        private var _content:HabbiconMessengerContent;
        private var _secondsSinceSent:int;
        private var _messageId:String;
        private var _confirmationId:int;
        private var _senderId:int;
        private var _senderName:String;
        private var _senderFigure:String;

        public function flush():Boolean
        {
            this._chatId = 0;
            this._content = null;
            this._secondsSinceSent = 0;
            this._messageId = "";
            this._confirmationId = 0;
            this._senderId = 0;
            this._senderName = "";
            this._senderFigure = "";
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            this._chatId = wrapper.readInteger();
            this._content = new HabbiconMessengerContent(wrapper);
            this._secondsSinceSent = wrapper.readInteger();
            this._messageId = wrapper.readString();
            this._confirmationId = wrapper.readInteger();
            this._senderId = wrapper.readInteger();
            this._senderName = wrapper.readString();
            this._senderFigure = wrapper.readString();
            return true;
        }

        public function get chatId():int
        {
            return this._chatId;
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

        public function get confirmationId():int
        {
            return this._confirmationId;
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
    }
}
