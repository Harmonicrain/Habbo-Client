package com.sulake.habbo.communication.messages.parser.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class RewardTrackClaimResultMessageParser implements IMessageParser
    {
        public static const SUCCESS:int = 0;

        private var _trackId:String;
        private var _rewardId:String;
        private var _resultCode:int;

        public function flush():Boolean
        {
            this._trackId = null;
            this._rewardId = null;
            this._resultCode = 0;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            this._trackId = wrapper.readString();
            this._rewardId = wrapper.readString();
            this._resultCode = wrapper.readInteger();
            return true;
        }

        public function get trackId():String
        {
            return this._trackId;
        }

        public function get rewardId():String
        {
            return this._rewardId;
        }

        public function get resultCode():int
        {
            return this._resultCode;
        }
    }
}
