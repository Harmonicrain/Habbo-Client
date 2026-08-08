package com.sulake.habbo.communication.messages.incoming.room.engine
{
    public class WiredUserDirectionData
    {
        public var userIndex:int;
        public var headDirection:int;
        public var bodyDirection:int;

        public function WiredUserDirectionData(k:int, _arg_2:int, _arg_3:int)
        {
            this.userIndex = k;
            this.bodyDirection = _arg_2;
            this.headDirection = _arg_3;
        }
    }
}
