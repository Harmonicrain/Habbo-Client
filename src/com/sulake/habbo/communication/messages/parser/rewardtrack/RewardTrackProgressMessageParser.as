package com.sulake.habbo.communication.messages.parser.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class RewardTrackProgressMessageParser implements IMessageParser
    {
        private var _trackId:String;
        private var _taskId:String;
        private var _progressCount:int;
        private var _points:int;

        public function flush():Boolean
        {
            this._trackId = null;
            this._taskId = null;
            this._progressCount = 0;
            this._points = 0;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            this._trackId = wrapper.readString();
            this._taskId = wrapper.readString();
            this._progressCount = wrapper.readInteger();
            this._points = wrapper.readInteger();
            return true;
        }

        public function get trackId():String
        {
            return this._trackId;
        }

        public function get taskId():String
        {
            return this._taskId;
        }

        public function get progressCount():int
        {
            return this._progressCount;
        }

        public function get points():int
        {
            return this._points;
        }
    }
}
