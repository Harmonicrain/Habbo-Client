package com.sulake.habbo.communication.messages.outgoing.games
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class RequestGamehallLeaderboardMessageComposer implements IMessageComposer
    {
        private var _gameType:String;
        private var _period:String;
        private var _offset:int;
        private var _limit:int;

        public function RequestGamehallLeaderboardMessageComposer(gameType:String="ALL", period:String="WEEKLY", offset:int=0, limit:int=10)
        {
            this._gameType = gameType;
            this._period = period;
            this._offset = offset;
            this._limit = limit;
        }

        public function getMessageArray():Array
        {
            return [this._gameType, this._period, this._offset, this._limit];
        }

        public function dispose():void
        {
        }
    }
}
