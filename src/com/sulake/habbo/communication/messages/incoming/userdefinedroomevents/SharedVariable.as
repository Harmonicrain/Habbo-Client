package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class SharedVariable
    {
        private var _roomId:int;
        private var _roomName:String;
        private var _wiredVariable:WiredVariable;

        public function SharedVariable(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 31, "SharedVariable");
            this._roomId = k.readInteger();
            this._roomName = k.readString();
            this._wiredVariable = new WiredVariable(k);
        }

        public function get roomId():int { return this._roomId; }
        public function get roomName():String { return this._roomName; }
        public function get wiredVariable():WiredVariable { return this._wiredVariable; }
    }
}
