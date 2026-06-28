package com.sulake.habbo.communication.messages.parser.games
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class CloseGameBoardMessageParser implements IMessageParser
    {
        private var _stationId:int = 0;
        private var _reason:String = "";

        public function get stationId():int
        {
            return this._stationId;
        }

        public function get reason():String
        {
            return this._reason;
        }

        public function flush():Boolean
        {
            this._stationId = 0;
            this._reason = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            if (k == null)
            {
                return false;
            }
            this._stationId = k.readInteger();
            this._reason = k.readString();
            return true;
        }
    }
}
