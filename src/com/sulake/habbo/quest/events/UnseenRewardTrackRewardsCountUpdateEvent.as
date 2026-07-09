package com.sulake.habbo.quest.events
{
    import flash.events.Event;

    public class UnseenRewardTrackRewardsCountUpdateEvent extends Event
    {
        public static const UNSEEN_REWARD_TRACK_REWARDS_COUNT_UPDATE:String = "qe_urtrcue";

        private var _count:int;

        public function UnseenRewardTrackRewardsCountUpdateEvent(count:int)
        {
            super(UNSEEN_REWARD_TRACK_REWARDS_COUNT_UPDATE);
            this._count = count;
        }

        public function get count():int
        {
            return this._count;
        }
    }
}
