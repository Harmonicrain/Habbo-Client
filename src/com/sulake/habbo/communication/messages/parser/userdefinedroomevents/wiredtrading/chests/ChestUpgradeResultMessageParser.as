package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class ChestUpgradeResultMessageParser implements IMessageParser
    {
        public static const SUCCESS:int = 0;
        private var _chestId:int;
        private var _resultCode:int;
        public function flush():Boolean { this._chestId = 0; this._resultCode = 0; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable != 8) { return false; }
            this._chestId = data.readInteger();
            this._resultCode = data.readInteger();
            return true;
        }
        public function get chestId():int { return this._chestId; }
        public function get resultCode():int { return this._resultCode; }
    }
}
