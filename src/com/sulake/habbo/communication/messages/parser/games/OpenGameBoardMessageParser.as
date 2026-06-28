package com.sulake.habbo.communication.messages.parser.games
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class OpenGameBoardMessageParser implements IMessageParser
    {
        private var _stationId:int = 0;
        private var _gameType:String = "";
        private var _localSeat:int = 0;
        private var _seatCount:int = 0;

        public function get stationId():int
        {
            return this._stationId;
        }

        public function get gameType():String
        {
            return this._gameType;
        }

        public function get localSeat():int
        {
            return this._localSeat;
        }

        public function get seatCount():int
        {
            return this._seatCount;
        }

        public function flush():Boolean
        {
            this._stationId = 0;
            this._gameType = "";
            this._localSeat = 0;
            this._seatCount = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            if (k == null)
            {
                return false;
            }
            this._stationId = k.readInteger();
            this._gameType = k.readString();
            this._localSeat = k.readInteger();
            this._seatCount = k.readInteger();
            return true;
        }
    }
}
