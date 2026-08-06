package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class ChestCoinBalanceMessageParser implements IMessageParser
    {
        private var _chestId:int;
        private var _coins:int;
        private var _update:Boolean;
        public function flush():Boolean
        {
            this._chestId = 0; this._coins = 0; this._update = false; return true;
        }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable != 9) { return false; }
            this._chestId = data.readInteger();
            this._coins = data.readInteger();
            this._update = data.readBoolean();
            return true;
        }
        public function get chestId():int { return this._chestId; }
        public function get coins():int { return this._coins; }
        public function get isUpdate():Boolean { return this._update; }
    }
}
