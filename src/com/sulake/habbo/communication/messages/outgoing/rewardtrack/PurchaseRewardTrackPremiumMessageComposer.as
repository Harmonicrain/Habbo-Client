package com.sulake.habbo.communication.messages.outgoing.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class PurchaseRewardTrackPremiumMessageComposer implements IMessageComposer
    {
        private var _data:Array;

        public function PurchaseRewardTrackPremiumMessageComposer(trackId:String)
        {
            this._data = [trackId];
        }

        public function getMessageArray():Array
        {
            return this._data;
        }

        public function dispose():void
        {
            this._data = null;
        }
    }
}
