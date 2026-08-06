package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    public final class WiredMenuUserVariablesPageParser implements IMessageParser
    {
        public var variableId:String; public var total:int; public var page:int;
        public var amount:int; public var entries:Array; public var userFilter:int;
        public var sortFilter:int;
        public function flush():Boolean { entries=[]; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            variableId=data.readString(); total=data.readInteger(); page=data.readInteger();
            amount=data.readInteger(); var count:int=data.readInteger();
            if(count<0||count>500){return false;} entries=[];
            for(var i:int=0;i<count;i++){
                entries.push({type:data.readInteger(),id:data.readInteger(),
                    name:data.readString(),value:data.readInteger(),
                    created:data.readLong(),createdText:data.readString(),
                    updated:data.readLong(),updatedText:data.readString()});
            }
            userFilter=data.readInteger(); sortFilter=data.readInteger();
            return data.bytesAvailable==0;
        }
    }
}
