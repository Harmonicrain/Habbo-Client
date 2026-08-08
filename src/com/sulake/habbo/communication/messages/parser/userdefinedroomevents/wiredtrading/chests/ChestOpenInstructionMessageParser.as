package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class ChestOpenInstructionMessageParser implements IMessageParser
    {
        private var _chestId:int;
        public function flush():Boolean { this._chestId = 0; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable != 4) { return false; }
            this._chestId = data.readInteger();
            return true;
        }
        public function get chestId():int { return this._chestId; }
    }
}
