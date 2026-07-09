package com.sulake.habbo.quest.rewardtrack.data
{
    public class RewardTrackTaskLevel
    {
        private var _requiredCount:int;
        private var _pointsReward:int;
        private var _premium:Boolean;

        public function RewardTrackTaskLevel(requiredCount:int, pointsReward:int, premium:Boolean)
        {
            this._requiredCount = requiredCount;
            this._pointsReward = pointsReward;
            this._premium = premium;
        }

        public function get requiredCount():int
        {
            return this._requiredCount;
        }

        public function get pointsReward():int
        {
            return this._pointsReward;
        }

        public function get premium():Boolean
        {
            return this._premium;
        }
    }
}
