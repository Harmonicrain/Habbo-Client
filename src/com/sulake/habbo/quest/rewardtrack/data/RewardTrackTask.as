package com.sulake.habbo.quest.rewardtrack.data
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class RewardTrackTask
    {
        private var _id:String;
        private var _actionType:String;
        private var _parameter:String;
        private var _progressCount:int;
        private var _premium:Boolean;
        private var _levels:Array;

        public function RewardTrackTask(wrapper:IMessageDataWrapper)
        {
            var i:int;
            var levelCount:int;
            this._levels = [];
            this._id = wrapper.readString();
            this._actionType = wrapper.readString();
            this._parameter = wrapper.readString();
            this._progressCount = wrapper.readInteger();
            this._premium = wrapper.readBoolean();
            levelCount = wrapper.readInteger();
            for (i = 0; i < levelCount; i++)
            {
                this._levels.push(new RewardTrackTaskLevel(wrapper.readInteger(), wrapper.readInteger(), wrapper.readBoolean()));
            }
        }

        public function get id():String
        {
            return this._id;
        }

        public function get actionType():String
        {
            return this._actionType;
        }

        public function get parameter():String
        {
            return this._parameter;
        }

        public function get progressCount():int
        {
            return this._progressCount;
        }

        public function set progressCount(value:int):void
        {
            this._progressCount = value;
        }

        public function get premium():Boolean
        {
            return this._premium;
        }

        public function get levels():Array
        {
            return this._levels;
        }
    }
}
