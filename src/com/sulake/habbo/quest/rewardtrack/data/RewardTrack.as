package com.sulake.habbo.quest.rewardtrack.data
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class RewardTrack
    {
        private var _id:String;
        private var _theme:String;
        private var _points:int;
        private var _hasPremiumConfig:Boolean;
        private var _taskPointsBoost:Number = 1;
        private var _instantPoints:int = 0;
        private var _costPoints:int = 0;
        private var _costPointsType:int = 5;
        private var _costCredits:int = 0;
        private var _premium:Boolean;
        private var _complete:Boolean;
        private var _premiumComplete:Boolean;
        private var _tasks:Array;
        private var _prizes:Array;

        public function RewardTrack(wrapper:IMessageDataWrapper)
        {
            var i:int;
            var count:int;
            this._tasks = [];
            this._prizes = [];
            this._id = wrapper.readString();
            this._theme = wrapper.readString();
            this._points = wrapper.readInteger();
            this._hasPremiumConfig = wrapper.readBoolean();
            if (this._hasPremiumConfig)
            {
                this._taskPointsBoost = wrapper.readDouble();
                this._instantPoints = wrapper.readInteger();
                this._costPoints = wrapper.readInteger();
                this._costCredits = wrapper.readInteger();
                this._costPointsType = wrapper.readInteger();
            }
            this._premium = wrapper.readBoolean();
            this._complete = wrapper.readBoolean();
            this._premiumComplete = wrapper.readBoolean();
            count = wrapper.readInteger();
            for (i = 0; i < count; i++)
            {
                this._tasks.push(new RewardTrackTask(wrapper));
            }
            count = wrapper.readInteger();
            for (i = 0; i < count; i++)
            {
                this._prizes.push(new RewardTrackPrize(wrapper));
            }
        }

        public function get id():String
        {
            return this._id;
        }

        public function get theme():String
        {
            return this._theme;
        }

        public function get points():int
        {
            return this._points;
        }

        public function set points(value:int):void
        {
            this._points = value;
        }

        public function get hasPremiumConfig():Boolean
        {
            return this._hasPremiumConfig;
        }

        public function get taskPointsBoost():Number
        {
            return this._taskPointsBoost;
        }

        public function get instantPoints():int
        {
            return this._instantPoints;
        }

        public function get costPoints():int
        {
            return this._costPoints;
        }

        public function get costPointsType():int
        {
            return this._costPointsType;
        }

        public function get costCredits():int
        {
            return this._costCredits;
        }

        public function get premium():Boolean
        {
            return this._premium;
        }

        public function set premium(value:Boolean):void
        {
            this._premium = value;
        }

        public function get complete():Boolean
        {
            return this._complete;
        }

        public function get premiumComplete():Boolean
        {
            return this._premiumComplete;
        }

        public function get tasks():Array
        {
            return this._tasks;
        }

        public function get prizes():Array
        {
            return this._prizes;
        }

        public function get hasPremiumPrizes():Boolean
        {
            var prize:RewardTrackPrize;
            for each (prize in this._prizes)
            {
                if (prize.premium)
                {
                    return true;
                }
            }
            return false;
        }

        public function get hasPremiumTasks():Boolean
        {
            var task:RewardTrackTask;
            for each (task in this._tasks)
            {
                if (task.premium)
                {
                    return true;
                }
            }
            return false;
        }

        public function get hasPremiumLevels():Boolean
        {
            var task:RewardTrackTask;
            var level:RewardTrackTaskLevel;
            for each (task in this._tasks)
            {
                for each (level in task.levels)
                {
                    if (level.premium)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public function getTask(taskId:String):RewardTrackTask
        {
            var task:RewardTrackTask;
            for each (task in this._tasks)
            {
                if (task.id == taskId)
                {
                    return task;
                }
            }
            return null;
        }

        public function getPrize(prizeId:String):RewardTrackPrize
        {
            var prize:RewardTrackPrize;
            for each (prize in this._prizes)
            {
                if (prize.id == prizeId)
                {
                    return prize;
                }
            }
            return null;
        }
    }
}
