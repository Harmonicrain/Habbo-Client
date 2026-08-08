package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    public final class WiredMenuLogsPageParser implements IMessageParser
    {
        public var total:int; public var page:int; public var amount:int;
        public var entries:Array;
        public var levelFilter:int = -1;
        public var sourceFilter:int = -1;
        public var query:String = "";
        public function flush():Boolean
        {
            entries = [];
            levelFilter = -1;
            sourceFilter = -1;
            query = "";
            return true;
        }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable < 16) { return false; }
            total=data.readInteger(); page=data.readInteger(); amount=data.readInteger();
            var count:int=data.readInteger();
            if(count<0||count>500){return false;} entries=[];
            for(var i:int=0;i<count;i++){
                entries.push({id:data.readLong(),level:data.readByte(),
                    source:data.readByte(),message:data.readString(),
                    timestamp:data.readLong(),timestampText:data.readString()});
            }
            if(data.bytesAvailable<3){return false;}
            if(data.readBoolean()){levelFilter=data.readByte();}
            if(data.readBoolean()){sourceFilter=data.readByte();}
            if(data.readBoolean()){query=data.readString();}
            return data.bytesAvailable==0;
        }
    }
}
