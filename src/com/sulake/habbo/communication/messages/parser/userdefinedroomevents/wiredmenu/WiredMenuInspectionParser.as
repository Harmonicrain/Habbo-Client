package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public final class WiredMenuInspectionParser implements IMessageParser
    {
        public var type:int;
        public var objectId:int;
        public var values:Array;
        public var wiredIds:Array;
        public function flush():Boolean
        {
            type = -1;
            objectId = 0;
            values = [];
            wiredIds = [];
            return true;
        }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable < 8) { return false; }
            type = data.readInteger();
            if (type != 0 && type != 1 && type != -10) { return false; }
            objectId = type == -10 ? 0 : data.readInteger();
            var count:int = data.readInteger();
            if (count < 0 || count > 4096) { return false; }
            values = [];
            for (var i:int = 0; i < count; i++)
            {
                values.push({id:data.readString(), value:data.readInteger()});
            }
            wiredIds = [];
            if (type == 0)
            {
                count = data.readInteger();
                if (count < 0 || count > 4096) { return false; }
                for (i = 0; i < count; i++) { wiredIds.push(data.readInteger()); }
            }
            return data.bytesAvailable == 0;
        }
    }
}
