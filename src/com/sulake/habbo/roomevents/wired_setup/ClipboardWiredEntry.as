package com.sulake.habbo.roomevents.wired_setup
{
    public class ClipboardWiredEntry
    {
        public var intParams:Array;
        public var stringParam:String;
        public var variableIds:Array;
        public var stuffIds:Array;
        public var stuffIds2:Array;
        public var furniSourceTypes:Array;
        public var userSourceTypes:Array;
        public var delayInPulses:int = 0;
        public var quantifierCode:int = 0;
        public var isFilter:Boolean = false;
        public var isInvert:Boolean = false;

        public function ClipboardWiredEntry(intParams:Array, stringParam:String,
            variableIds:Array, stuffIds:Array, stuffIds2:Array,
            furniSourceTypes:Array, userSourceTypes:Array)
        {
            this.intParams = intParams != null ? intParams.concat() : [];
            this.stringParam = stringParam != null ? stringParam : "";
            this.variableIds = variableIds != null ? variableIds.concat() : [];
            this.stuffIds = stuffIds != null ? stuffIds.concat() : [];
            this.stuffIds2 = stuffIds2 != null ? stuffIds2.concat() : [];
            this.furniSourceTypes = furniSourceTypes != null ? furniSourceTypes.concat() : [];
            this.userSourceTypes = userSourceTypes != null ? userSourceTypes.concat() : [];
        }
    }
}
