package com.sulake.habbo.communication.messages.parser.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class RewardTrackPremiumResultMessageParser implements IMessageParser
    {
        public static const SUCCESS:int = 0;

        private var _trackId:String;
        private var _resultCode:int;
        private var _points:int;

        public function flush():Boolean
        {
            this._trackId = null;
            this._resultCode = 0;
            this._points = 0;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            this._trackId = wrapper.readString();
            this._resultCode = wrapper.readInteger();
            this._points = wrapper.readInteger();
            return true;
        }

        public function get trackId():String
        {
            return this._trackId;
        }

        public function get resultCode():int
        {
            return this._resultCode;
        }

        public function get points():int
        {
            return this._points;
        }
    }
}
