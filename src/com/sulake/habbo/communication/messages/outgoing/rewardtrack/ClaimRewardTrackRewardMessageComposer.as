package com.sulake.habbo.communication.messages.outgoing.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class ClaimRewardTrackRewardMessageComposer implements IMessageComposer
    {
        private var _data:Array;

        public function ClaimRewardTrackRewardMessageComposer(trackId:String, rewardId:String)
        {
            this._data = [trackId, rewardId];
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
