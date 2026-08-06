package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class SharedGlobalPlaceholder
    {
        private var _roomId:int;
        private var _roomName:String;
        private var _placeholderName:String;

        public function SharedGlobalPlaceholder(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 8, "SharedGlobalPlaceholder");
            this._roomId = k.readInteger();
            this._roomName = k.readString();
            this._placeholderName = k.readString();
        }

        public function get roomId():int { return this._roomId; }
        public function get roomName():String { return this._roomName; }
        public function get placeholderName():String { return this._placeholderName; }
    }
}
