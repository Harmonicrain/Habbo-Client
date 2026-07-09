package com.sulake.habbo.communication.messages.parser.habbicons
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class HabbiconMessengerContent
    {
        public static const MESSAGE_TYPE_TEXT:int = 0;
        public static const MESSAGE_TYPE_HABBICON:int = 1;

        private var _messageType:int;
        private var _messageText:String;
        private var _habbiconId:int;

        public function HabbiconMessengerContent(wrapper:IMessageDataWrapper = null)
        {
            if (wrapper != null)
            {
                this.parse(wrapper);
            }
        }

        public function parse(wrapper:IMessageDataWrapper):void
        {
            this._messageType = wrapper.readInteger();
            if (this._messageType == MESSAGE_TYPE_HABBICON)
            {
                this._habbiconId = wrapper.readInteger();
                this._messageText = "";
            }
            else
            {
                this._messageText = wrapper.readString();
                this._habbiconId = 0;
            }
        }

        public function get messageType():int
        {
            return this._messageType;
        }

        public function get messageText():String
        {
            return this._messageText;
        }

        public function get habbiconId():int
        {
            return this._habbiconId;
        }
    }
}
