package com.sulake.habbo.communication.messages.incoming.room.engine
{
    import com.sulake.room.utils.IVector3d;

    public class WiredUserMovementData
    {
        public var userIndex:int;
        public var source:IVector3d;
        public var target:IVector3d;
        public var moveType:String;
        public var animationTime:Number;
        public var headDirection:int;
        public var bodyDirection:int;
        public var jumpPower:Number;

        public function WiredUserMovementData(k:int, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:String, _arg_5:Number, _arg_6:int, _arg_7:int, _arg_8:Number=NaN)
        {
            this.userIndex = k;
            this.source = _arg_2;
            this.target = _arg_3;
            this.moveType = _arg_4;
            this.animationTime = _arg_5;
            this.bodyDirection = _arg_6;
            this.headDirection = _arg_7;
            this.jumpPower = _arg_8;
        }
    }
}
