package com.sulake.habbo.communication.messages.parser.games
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class OpenGamehallLeaderboardMessageParser implements IMessageParser
    {
        private var _gameType:String;
        private var _period:String;
        private var _offset:int;
        private var _limit:int;
        private var _totalRows:int;
        private var _rows:Array;
        private var _ownRow:Object;

        public function flush():Boolean
        {
            this._gameType = "ALL";
            this._period = "WEEKLY";
            this._offset = 0;
            this._limit = 10;
            this._totalRows = 0;
            this._rows = [];
            this._ownRow = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            this.flush();
            this._gameType = k.readString();
            this._period = k.readString();
            this._offset = k.readInteger();
            this._limit = k.readInteger();
            this._totalRows = k.readInteger();

            var count:int = k.readInteger();
            for (var index:int = 0; index < count; index++)
            {
                this._rows.push(this.readRow(k));
            }

            if (k.readBoolean())
            {
                this._ownRow = this.readRow(k);
            }
            return true;
        }

        private function readRow(k:IMessageDataWrapper):Object
        {
            return {
                userId: k.readInteger(),
                rank: k.readInteger(),
                username: k.readString(),
                figure: k.readString(),
                gender: k.readString(),
                points: k.readInteger(),
                wins: k.readInteger(),
                losses: k.readInteger(),
                draws: k.readInteger(),
                gamesPlayed: k.readInteger(),
                own: k.readBoolean()
            };
        }

        public function get gameType():String
        {
            return this._gameType;
        }

        public function get period():String
        {
            return this._period;
        }

        public function get offset():int
        {
            return this._offset;
        }

        public function get limit():int
        {
            return this._limit;
        }

        public function get totalRows():int
        {
            return this._totalRows;
        }

        public function get rows():Array
        {
            return this._rows;
        }

        public function get ownRow():Object
        {
            return this._ownRow;
        }
    }
}
