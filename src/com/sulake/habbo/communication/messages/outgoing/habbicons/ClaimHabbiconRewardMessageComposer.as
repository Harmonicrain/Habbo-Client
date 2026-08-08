package com.sulake.habbo.communication.messages.outgoing.habbicons
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class ClaimHabbiconRewardMessageComposer implements IMessageComposer
    {
        private var _habbiconId:int;

        public function ClaimHabbiconRewardMessageComposer(habbiconId:int)
        {
            this._habbiconId = habbiconId;
        }

        public function getMessageArray():Array
        {
            return [this._habbiconId];
        }

        public function dispose():void
        {
        }
    }
}
