package com.sulake.habbo.communication.messages.incoming.games
{
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.games.OpenGameBoardMessageParser;

    public class OpenGameBoardMessageEvent extends MessageEvent
    {
        public function OpenGameBoardMessageEvent(k:Function)
        {
            super(k, OpenGameBoardMessageParser);
        }

        public function getParser():OpenGameBoardMessageParser
        {
            return (_parser as OpenGameBoardMessageParser);
        }
    }
}
