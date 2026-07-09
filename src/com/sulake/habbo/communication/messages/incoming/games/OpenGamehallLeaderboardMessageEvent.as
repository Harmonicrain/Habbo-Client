package com.sulake.habbo.communication.messages.incoming.games
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.games.OpenGamehallLeaderboardMessageParser;

    public class OpenGamehallLeaderboardMessageEvent extends MessageEvent
    {
        public function OpenGamehallLeaderboardMessageEvent(k:Function)
        {
            super(k, OpenGamehallLeaderboardMessageParser);
        }

        public function getParser():OpenGamehallLeaderboardMessageParser
        {
            return (_parser as OpenGamehallLeaderboardMessageParser);
        }
    }
}
