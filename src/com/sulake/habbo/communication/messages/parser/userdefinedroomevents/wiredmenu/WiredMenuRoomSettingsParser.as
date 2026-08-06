package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public final class WiredMenuRoomSettingsParser implements IMessageParser
    {
        private var _modify:int;
        private var _read:int;
        private var _timezone:String;
        public function flush():Boolean { _modify = 0; _read = 0; _timezone = null; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable < 10) { return false; }
            _modify = data.readInteger(); _read = data.readInteger();
            _timezone = data.readString(); return data.bytesAvailable == 0;
        }
        public function get modifyMask():int { return _modify; }
        public function get readMask():int { return _read; }
        public function get timezone():String { return _timezone; }
    }
}
