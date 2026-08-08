package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class AllVariablesHashMessageParser implements IMessageParser
    {
        private var _allVariablesHash:int;

        public function flush():Boolean
        {
            this._allVariablesHash = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            if (k.bytesAvailable != 4)
            {
                return false;
            }
            this._allVariablesHash = k.readInteger();
            return true;
        }

        public function get allVariablesHash():int
        {
            return this._allVariablesHash;
        }
    }
}
