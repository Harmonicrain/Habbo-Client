package com.sulake.habbo.ui.widget.furniture.gamehall
{
    public class GamehallViewFactory
    {
        public static function create(gameType:String, sendMove:Function, invalidate:Function):GamehallGameView
        {
            switch (GamehallGameTypes.normalize(gameType))
            {
                case GamehallGameTypes.TICTACTOE:
                    return new GamehallTicTacToeView(sendMove, invalidate);
                case GamehallGameTypes.CHESS:
                case GamehallGameTypes.POKER:
                    return new GamehallPlaceholderView(gameType, sendMove, invalidate);
                default:
                    return new GamehallBattleshipsView(sendMove, invalidate);
            }
        }
    }
}
