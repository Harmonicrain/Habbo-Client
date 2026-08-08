package com.sulake.habbo.quest.rewardtrack.data
{
    import com.sulake.habbo.window.widgets.IProductDisplayInfo;

    public class RewardTrackRewardDisplayWrapper implements IProductDisplayInfo
    {
        private var _prize:RewardTrackPrize;

        public function RewardTrackRewardDisplayWrapper(prize:RewardTrackPrize)
        {
            super();
            this._prize = prize;
        }

        public function get productTypeId():int
        {
            if ("habbicon" == this._prize.rewardTypeId)
            {
                return 7300;
            }
            if (this._prize.productItemTypeId == 0 && this.isCurrencyReward())
            {
                return 9;
            }
            return this._prize.productItemTypeId;
        }

        public function get itemTypeId():String
        {
            if (this._prize.productItemTypeId == 0)
            {
                if ("credits" == this._prize.rewardTypeId)
                {
                    return "-1";
                }
                if ("pixels" == this._prize.rewardTypeId)
                {
                    return "0";
                }
                if ("activity_points" == this._prize.rewardTypeId || "currency" == this._prize.rewardTypeId)
                {
                    return this._prize.extraParams != null && this._prize.extraParams != "" ? this._prize.extraParams : "0";
                }
                if ("habbicon" == this._prize.rewardTypeId)
                {
                    return this._prize.extraParams != null && this._prize.extraParams != "" ? this._prize.extraParams : this._prize.id;
                }
            }
            return this._prize.rewardTypeId;
        }

        public function get extraData():String
        {
            return this._prize.extraParams;
        }

        public function get petFigureString():String
        {
            return this._prize.extraParams;
        }

        public function get botFigureString():String
        {
            return this._prize.extraParams;
        }

        public function get figureSetIds():Vector.<int>
        {
            return new Vector.<int>();
        }

        private function isCurrencyReward():Boolean
        {
            return this._prize.rewardTypeId == "credits" || this._prize.rewardTypeId == "pixels" || this._prize.rewardTypeId == "activity_points" || this._prize.rewardTypeId == "currency";
        }
    }
}
