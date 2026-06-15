package com.sulake.habbo.communication.messages.incoming.room.engine
{
    import com.sulake.room.utils.IVector3d;

    public class WiredFurniMovementData
    {
        public var furniId:int;
        public var source:IVector3d;
        public var target:IVector3d;
        public var rotation:int;
        public var animationTime:Number;
        public var overshootingDistance:Number;
        public var curveStrength:Number;

        public function WiredFurniMovementData(k:int, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:int, _arg_5:Number, _arg_6:Number=NaN, _arg_7:Number=NaN)
        {
            this.furniId = k;
            this.source = _arg_2;
            this.target = _arg_3;
            this.rotation = _arg_4;
            this.animationTime = _arg_5;
            this.overshootingDistance = _arg_6;
            this.curveStrength = _arg_7;
        }
    }
}
