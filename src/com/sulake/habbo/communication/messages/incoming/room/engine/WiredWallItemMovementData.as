package com.sulake.habbo.communication.messages.incoming.room.engine
{
    public class WiredWallItemMovementData
    {
        public var itemId:int;
        public var isDirectionRight:Boolean;
        public var oldWallX:int;
        public var oldWallY:int;
        public var oldOffsetX:int;
        public var oldOffsetY:int;
        public var newWallX:int;
        public var newWallY:int;
        public var newOffsetX:int;
        public var newOffsetY:int;
        public var animationTime:int;

        public function WiredWallItemMovementData(k:int, _arg_2:Boolean, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:int, _arg_9:int, _arg_10:int, _arg_11:int)
        {
            this.itemId = k;
            this.isDirectionRight = _arg_2;
            this.oldWallX = _arg_3;
            this.oldWallY = _arg_4;
            this.oldOffsetX = _arg_5;
            this.oldOffsetY = _arg_6;
            this.newWallX = _arg_7;
            this.newWallY = _arg_8;
            this.newOffsetX = _arg_9;
            this.newOffsetY = _arg_10;
            this.animationTime = _arg_11;
        }
    }
}
