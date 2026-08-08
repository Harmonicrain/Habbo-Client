package com.sulake.habbo.quest.rewardtrack.data
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class RewardTrackPrize
    {
        private var _id:String;
        private var _requiredPoints:int;
        private var _productItemTypeId:int;
        private var _rewardTypeId:String;
        private var _extraParams:String;
        private var _rewardAmount:int;
        private var _premium:Boolean;
        private var _available:Boolean;
        private var _claimed:Boolean;

        public function RewardTrackPrize(wrapper:IMessageDataWrapper)
        {
            this._id = wrapper.readString();
            this._requiredPoints = wrapper.readInteger();
            this._productItemTypeId = wrapper.readShort();
            this._rewardTypeId = wrapper.readString();
            this._extraParams = wrapper.readString();
            this._rewardAmount = wrapper.readInteger();
            this._premium = wrapper.readBoolean();
            this._available = wrapper.readBoolean();
            this._claimed = wrapper.readBoolean();
        }

        public function get id():String
        {
            return this._id;
        }

        public function get requiredPoints():int
        {
            return this._requiredPoints;
        }

        public function get productItemTypeId():int
        {
            return this._productItemTypeId;
        }

        public function get rewardTypeId():String
        {
            return this._rewardTypeId;
        }

        public function get extraParams():String
        {
            return this._extraParams;
        }

        public function get rewardAmount():int
        {
            return this._rewardAmount;
        }

        public function get premium():Boolean
        {
            return this._premium;
        }

        public function get available():Boolean
        {
            return this._available;
        }

        public function get claimed():Boolean
        {
            return this._claimed;
        }

        public function set claimed(value:Boolean):void
        {
            this._claimed = value;
        }

        public function isPremiumLocked(track:RewardTrack):Boolean
        {
            return this._premium && track != null && !track.premium;
        }

        public function hasEnoughPoints(track:RewardTrack):Boolean
        {
            return track != null && track.points >= this._requiredPoints;
        }

        public function isAvailable(track:RewardTrack):Boolean
        {
            return !this.isPremiumLocked(track) && this.hasEnoughPoints(track);
        }

        public function refreshAvailability(track:RewardTrack):void
        {
            this._available = this.isAvailable(track);
        }

        public function isClaimable(track:RewardTrack):Boolean
        {
            return this.isAvailable(track) && !this._claimed;
        }
    }
}
