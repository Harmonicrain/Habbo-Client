package com.sulake.habbo.communication.messages.incoming.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackClaimResultMessageParser;

    public class RewardTrackClaimResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function RewardTrackClaimResultMessageEvent(callback:Function)
        {
            super(callback, RewardTrackClaimResultMessageParser);
        }

        public function getParser():RewardTrackClaimResultMessageParser
        {
            return _parser as RewardTrackClaimResultMessageParser;
        }
    }
}
