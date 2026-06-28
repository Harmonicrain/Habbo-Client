package com.sulake.habbo.communication.messages.incoming.games
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.games.GameBoardUpdateMessageParser;

    public class GameBoardUpdateMessageEvent extends MessageEvent
    {
        public function GameBoardUpdateMessageEvent(k:Function)
        {
            super(k, GameBoardUpdateMessageParser);
        }

        public function getParser():GameBoardUpdateMessageParser
        {
            return (_parser as GameBoardUpdateMessageParser);
        }
    }
}
