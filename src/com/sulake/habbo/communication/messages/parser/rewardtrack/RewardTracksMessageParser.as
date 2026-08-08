package com.sulake.habbo.communication.messages.parser.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;

    public class RewardTracksMessageParser implements IMessageParser
    {
        private var _disabled:Boolean;
        private var _tracks:Array;
        private var _reload:Boolean;

        public function flush():Boolean
        {
            this._disabled = false;
            this._tracks = [];
            this._reload = false;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            var i:int;
            var count:int;
            this._tracks = [];
            this._disabled = wrapper.readBoolean();
            count = wrapper.readInteger();
            for (i = 0; i < count; i++)
            {
                this._tracks.push(new RewardTrack(wrapper));
            }
            this._reload = wrapper.readBoolean();
            return true;
        }

        public function get disabled():Boolean
        {
            return this._disabled;
        }

        public function get tracks():Array
        {
            return this._tracks;
        }

        public function get reload():Boolean
        {
            return this._reload;
        }
    }
}
