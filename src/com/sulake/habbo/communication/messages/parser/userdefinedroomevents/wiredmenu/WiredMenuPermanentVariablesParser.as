package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    public final class WiredMenuPermanentVariablesParser implements IMessageParser
    {
        public var type:int; public var id:int; public var name:String;
        public var figure:String; public var ownerId:int; public var ownerName:String;
        public var ownerFigure:String; public var entries:Array;
        public function flush():Boolean { entries=[]; return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            type=data.readInteger(); id=data.readInteger(); name=data.readString();
            figure=data.readString();
            if(type!=1){ownerId=data.readInteger();ownerName=data.readString();
                ownerFigure=data.readString();}
            var count:int=data.readInteger();
            if(count<0||count>4096){return false;} entries=[];
            for(var i:int=0;i<count;i++){
                entries.push({variableId:data.readString(),value:data.readInteger(),
                    created:data.readLong(),createdText:data.readString(),
                    updated:data.readLong(),updatedText:data.readString()});
            }
            return data.bytesAvailable==0;
        }
    }
}
