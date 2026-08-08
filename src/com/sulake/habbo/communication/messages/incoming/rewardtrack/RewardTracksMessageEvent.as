package com.sulake.habbo.communication.messages.incoming.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTracksMessageParser;

    public class RewardTracksMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function RewardTracksMessageEvent(callback:Function)
        {
            super(callback, RewardTracksMessageParser);
        }

        public function getParser():RewardTracksMessageParser
        {
            return _parser as RewardTracksMessageParser;
        }
    }
}
