package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public final class WiredMenuRoomStatsParser implements IMessageParser
    {
        public var executionCost:Number;
        public var executionCap:Number;
        public var heavy:Boolean;
        public var floorCount:int;
        public var floorCap:int;
        public var wallCount:int;
        public var wallCap:int;
        public var permanentFurniCount:int;
        public var permanentFurniCap:int;
        public var permanentUserCount:int;
        public var permanentUserCap:int;
        public var permanentGlobalCount:int;
        public var permanentGlobalCap:int;
        public function flush():Boolean { return true; }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable != 57) { return false; }
            executionCost = data.readDouble(); executionCap = data.readDouble();
            heavy = data.readBoolean();
            floorCount = data.readInteger(); floorCap = data.readInteger();
            wallCount = data.readInteger(); wallCap = data.readInteger();
            permanentFurniCount = data.readInteger();
            permanentFurniCap = data.readInteger();
            permanentUserCount = data.readInteger();
            permanentUserCap = data.readInteger();
            permanentGlobalCount = data.readInteger();
            permanentGlobalCap = data.readInteger();
            return true;
        }
    }
}
