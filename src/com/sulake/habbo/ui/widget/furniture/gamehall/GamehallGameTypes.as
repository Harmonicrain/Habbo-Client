package com.sulake.habbo.ui.widget.furniture.gamehall
{
    public class GamehallGameTypes
    {
        public static const BATTLESHIPS:String = "battleships";
        public static const TICTACTOE:String = "tictactoe";
        public static const CHESS:String = "chess";
        public static const POKER:String = "poker";

        public static function normalize(gameType:String):String
        {
            var normalized:String = (gameType == null) ? "" : gameType.toLowerCase();
            if (normalized.indexOf("battleship") >= 0 || normalized.indexOf("battle_ship") >= 0)
            {
                return BATTLESHIPS;
            }
            if (normalized.indexOf("tictactoe") >= 0 || normalized.indexOf("tic") >= 0)
            {
                return TICTACTOE;
            }
            if (normalized.indexOf("chess") >= 0)
            {
                return CHESS;
            }
            if (normalized.indexOf("poker") >= 0)
            {
                return POKER;
            }
            return BATTLESHIPS;
        }
    }
}
