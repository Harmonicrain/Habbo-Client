package com.sulake.habbo.room.messages
{
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.IVector3d;

    public class RoomObjectMoveUpdateMessage extends RoomObjectUpdateMessage
    {
        private var _targetLoc:IVector3d;
        private var _isSlideUpdate:Boolean;
        private var _animationTime:Number;
        private var _skipPositionUpdate:Boolean;
        private var _overshootAnimationTime:Number;
        private var _curveStrength:Number;

        public function RoomObjectMoveUpdateMessage(k:IVector3d, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:Number=NaN, _arg_5:Boolean=false, _arg_6:Boolean=false, _arg_7:Number=NaN, _arg_8:Number=NaN)
        {
            super(k, _arg_3);
            this._isSlideUpdate = _arg_5;
            this._targetLoc = _arg_2;
            this._animationTime = _arg_4;
            this._skipPositionUpdate = _arg_6;
            this._overshootAnimationTime = _arg_7;
            this._curveStrength = _arg_8;
        }

        public function get _Str_7569():IVector3d
        {
            if (this._targetLoc == null)
            {
                return loc;
            }
            return this._targetLoc;
        }

        public function get targetLoc():IVector3d
        {
            if (this._targetLoc == null)
            {
                return loc;
            }
            return this._targetLoc;
        }

        public function get realTargetLoc():IVector3d
        {
            return this._targetLoc;
        }

        public function get isSlideUpdate():Boolean
        {
            return this._isSlideUpdate;
        }

        public function get animationTime():Number
        {
            return this._animationTime;
        }

        public function get skipPositionUpdate():Boolean
        {
            return this._skipPositionUpdate;
        }

        public function get overshootAnimationTime():Number
        {
            return this._overshootAnimationTime;
        }

        public function get curveStrength():Number
        {
            return this._curveStrength;
        }
    }
}
