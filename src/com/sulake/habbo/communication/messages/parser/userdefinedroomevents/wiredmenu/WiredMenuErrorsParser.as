package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public final class WiredMenuErrorsParser implements IMessageParser
    {
        private var _errors:Array;
        public function flush():Boolean { _errors = []; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable < 4) { return false; }
            var count:int = data.readInteger();
            if (count < 0 || count > 500) { return false; }
            _errors = [];
            for (var i:int = 0; i < count; i++)
            {
                if (data.bytesAvailable < 16) { return false; }
                _errors.push({id:data.readInteger(), name:data.readString(),
                    category:data.readString(), count:data.readInteger(),
                    elapsed:data.readLong()});
            }
            return data.bytesAvailable == 0;
        }
        public function get errors():Array { return _errors; }
    }
}
