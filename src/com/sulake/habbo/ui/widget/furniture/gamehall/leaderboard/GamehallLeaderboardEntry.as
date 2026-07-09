package com.sulake.habbo.ui.widget.furniture.gamehall.leaderboard
{
    public class GamehallLeaderboardEntry
    {
        private var _userId:int;
        private var _rank:int;
        private var _username:String;
        private var _figure:String;
        private var _gender:String;
        private var _points:int;
        private var _wins:int;
        private var _losses:int;
        private var _draws:int;
        private var _gamesPlayed:int;
        private var _own:Boolean;

        public function GamehallLeaderboardEntry(data:Object)
        {
            if (data == null)
            {
                data = {};
            }
            this._userId = int(data.userId);
            this._rank = int(data.rank);
            this._username = data.username == null ? "" : String(data.username);
            this._figure = data.figure == null ? "" : String(data.figure);
            this._gender = data.gender == null ? "" : String(data.gender);
            this._points = int(data.points);
            this._wins = int(data.wins);
            this._losses = int(data.losses);
            this._draws = int(data.draws);
            this._gamesPlayed = int(data.gamesPlayed);
            this._own = Boolean(data.own);
        }

        public function get userId():int
        {
            return this._userId;
        }

        public function get rank():int
        {
            return this._rank;
        }

        public function get rankCaption():String
        {
            return this._rank > 0 ? String(this._rank) : "--";
        }

        public function get username():String
        {
            return this._username;
        }

        public function get figure():String
        {
            return this._figure;
        }

        public function get gender():String
        {
            return this._gender;
        }

        public function get score():int
        {
            return this._points;
        }

        public function get wins():int
        {
            return this._wins;
        }

        public function get losses():int
        {
            return this._losses;
        }

        public function get draws():int
        {
            return this._draws;
        }

        public function get gamesPlayed():int
        {
            return this._gamesPlayed;
        }

        public function get own():Boolean
        {
            return this._own;
        }
    }
}
