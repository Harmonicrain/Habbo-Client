package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public final class WiredMenuPermissionsParser implements IMessageParser
    {
        private var _write:Boolean;
        private var _read:Boolean;
        public function flush():Boolean { _write = false; _read = false; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable != 2) { return false; }
            _write = data.readBoolean(); _read = data.readBoolean(); return true;
        }
        public function get writePermission():Boolean { return _write; }
        public function get readPermission():Boolean { return _read; }
    }
}
