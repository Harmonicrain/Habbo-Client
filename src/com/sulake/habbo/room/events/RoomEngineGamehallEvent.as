package com.sulake.habbo.room.events
{
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;

    public class RoomEngineGamehallEvent extends RoomEngineObjectEvent
    {
        public static const OPEN:String = "REGHE_GAMEHALL_OPEN";
        public static const UPDATE:String = "REGHE_GAMEHALL_UPDATE";
        public static const CLOSE:String = "REGHE_GAMEHALL_CLOSE";
        public static const LEADERBOARD_OPEN:String = "REGHE_GAMEHALL_LEADERBOARD_OPEN";

        private var _gameType:String;
        private var _localSeat:int;
        private var _seatCount:int;
        private var _verb:String;
        private var _args:Array;
        private var _reason:String;

        public function RoomEngineGamehallEvent(type:String, roomId:int, stationId:int, gameType:String="", localSeat:int=0, seatCount:int=0, verb:String="", args:Array=null, reason:String="")
        {
            super(type, roomId, stationId, RoomObjectCategoryEnum.OBJECT_CATEGORY_UNKNOWN);
            this._gameType = gameType;
            this._localSeat = localSeat;
            this._seatCount = seatCount;
            this._verb = verb;
            this._args = (args == null) ? [] : args;
            this._reason = reason;
        }

        public function get stationId():int
        {
            return objectId;
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

        public function get verb():String
        {
            return this._verb;
        }

        public function get args():Array
        {
            return this._args;
        }

        public function get reason():String
        {
            return this._reason;
        }
    }
}
