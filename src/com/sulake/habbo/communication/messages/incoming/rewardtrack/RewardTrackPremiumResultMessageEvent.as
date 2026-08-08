package com.sulake.habbo.communication.messages.incoming.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackPremiumResultMessageParser;

    public class RewardTrackPremiumResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function RewardTrackPremiumResultMessageEvent(callback:Function)
        {
            super(callback, RewardTrackPremiumResultMessageParser);
        }

        public function getParser():RewardTrackPremiumResultMessageParser
        {
            return _parser as RewardTrackPremiumResultMessageParser;
        }
    }
}
