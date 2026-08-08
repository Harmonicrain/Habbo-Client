package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    public final class WiredMenuMutationResultParser implements IMessageParser
    {
        private var _success:Boolean;
        public function flush():Boolean { _success = false; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable != 1) { return false; }
            _success = data.readBoolean(); return true;
        }
        public function get success():Boolean { return _success; }
    }
}
