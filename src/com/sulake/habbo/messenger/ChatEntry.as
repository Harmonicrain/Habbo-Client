package com.sulake.habbo.messenger
{
    import flash.utils.getTimer;

    public class ChatEntry 
    {
        public static const TYPE_OWN_CHAT:int = 1;
        public static const TYPE_OTHER_CHAT:int = 2;
        public static const TYPE_NOTIFICATION:int = 3;
        public static const TYPE_INFO:int = 4;
        public static const TYPE_INVITATION:int = 5;
        public static const CONTENT_TEXT:int = 0;
        public static const CONTENT_HABBICON:int = 1;

        private var _type:int;
        private var _senderId:int;
        private var _message:String;
        private var _secondsSinceSent:int;
        private var _clientReceiveTime:int;
        private var _extraData:String;
        private var _contentType:int;
        private var _habbiconId:int;
        private var _messageId:String;
        private var _confirmationId:int;

        public function ChatEntry(k:int, _arg_2:int, _arg_3:String, _arg_4:int, _arg_5:String=null, _arg_6:int=0, _arg_7:int=0, _arg_8:String=null, _arg_9:int=0)
        {
            this._type = k;
            this._senderId = _arg_2;
            this._message = _arg_3;
            this._secondsSinceSent = _arg_4;
            this._clientReceiveTime = getTimer();
            this._extraData = _arg_5;
            this._contentType = _arg_6;
            this._habbiconId = _arg_7;
            this._messageId = _arg_8;
            this._confirmationId = _arg_9;
        }

        public function get type():int
        {
            return this._type;
        }

        public function get senderId():int
        {
            return this._senderId;
        }

        public function get message():String
        {
            return this._message;
        }

        public function get extraData():String
        {
            return this._extraData;
        }

        public function get contentType():int
        {
            return this._contentType;
        }

        public function get habbiconId():int
        {
            return this._habbiconId;
        }

        public function get messageId():String
        {
            return this._messageId;
        }

        public function get confirmationId():int
        {
            return this._confirmationId;
        }

        public function get isTextMessage():Boolean
        {
            return this._contentType == CONTENT_TEXT;
        }

        public function get _Str_17201():int
        {
            var k:int = ((getTimer() - this._clientReceiveTime) / 1000);
            return this._secondsSinceSent + k;
        }

        public function _Str_22172():Number
        {
            return new Date().getTime() - (this._Str_17201 * 1000);
        }

        public function _Str_19910(k:String):void
        {
            this._message = ((k + "\n") + this._message);
        }
    }
}
