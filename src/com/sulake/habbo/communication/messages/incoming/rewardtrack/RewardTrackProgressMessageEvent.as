package com.sulake.habbo.communication.messages.incoming.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackProgressMessageParser;

    public class RewardTrackProgressMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function RewardTrackProgressMessageEvent(callback:Function)
        {
            super(callback, RewardTrackProgressMessageParser);
        }

        public function getParser():RewardTrackProgressMessageParser
        {
            return _parser as RewardTrackProgressMessageParser;
        }
    }
}
