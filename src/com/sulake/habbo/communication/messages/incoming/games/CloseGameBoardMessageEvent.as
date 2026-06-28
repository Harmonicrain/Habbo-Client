package com.sulake.habbo.communication.messages.incoming.games
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.games.CloseGameBoardMessageParser;

    public class CloseGameBoardMessageEvent extends MessageEvent
    {
        public function CloseGameBoardMessageEvent(k:Function)
        {
            super(k, CloseGameBoardMessageParser);
        }

        public function getParser():CloseGameBoardMessageParser
        {
            return (_parser as CloseGameBoardMessageParser);
        }
    }
}
