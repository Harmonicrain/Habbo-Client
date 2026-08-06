package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.VariableInfoAndHolders;
    public final class WiredMenuVariableHoldersParser implements IMessageParser
    {
        private var _data:VariableInfoAndHolders;
        public function flush():Boolean { _data = null; return true; }
        public function parse(input:IMessageDataWrapper):Boolean
        {
            if (input.bytesAvailable < 4) { return false; }
            input.readInteger();
            _data = new VariableInfoAndHolders(input);
            return input.bytesAvailable == 0;
        }
        public function get data():VariableInfoAndHolders { return _data; }
    }
}
