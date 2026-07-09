package com.sulake.habbo.ui.widget.furniture.gamehall
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.text.TextFormatAlign;

    public class GamehallPlaceholderView extends GamehallGameViewBase
    {
        private var _gameType:String;
        private var _turnSeat:int = -1;

        public function GamehallPlaceholderView(gameType:String, sendMove:Function, invalidate:Function)
        {
            super(sendMove, invalidate);
            this._gameType = GamehallGameTypes.normalize(gameType);
        }

        override public function reset(localSeat:int, seatCount:int):void
        {
            super.reset(localSeat, seatCount);
            this._turnSeat = -1;
        }

        override public function applyUpdate(verb:String="", args:Array=null, reason:String=""):void
        {
            if (verb == GamehallUpdates.BOARD_DATA || verb == GamehallUpdates.SITUATION)
            {
                this._mode = "board";
                if (args != null && args.length > 0)
                {
                    this._status = String(args[0]);
                }
                return;
            }
            if (verb == GamehallUpdates.TURN)
            {
                this._mode = "board";
                if (args != null && args.length > 0)
                {
                    this._turnSeat = int(args[0]);
                }
                this._status = this.turnStatus();
                return;
            }
            if (verb == GamehallUpdates.WAIT)
            {
                this._status = args != null && args.length > 0 ? args.join(" ") : "Waiting for opponent";
                return;
            }
            if (verb == GamehallUpdates.OPPONENTS)
            {
                this._status = "Opponent ready";
                return;
            }
            if (verb == GamehallUpdates.GAME_END)
            {
                this._mode = "board";
                this._status = args != null && args.length > 0 ? String(args[0]) + " wins" : "Game over";
                return;
            }
            if (verb == GamehallUpdates.GAME_OVER)
            {
                this._mode = "board";
                this._status = "Game over";
                return;
            }
            super.applyUpdate(verb, args, reason);
        }

        override public function handleWindowEvent(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK && window != null && window.name == "ok_link" && this._mode == "start" && this._gameType == GamehallGameTypes.POKER)
            {
                this.sendMove(GamehallCommands.OPEN, []);
            }
        }

        override protected function drawStart():void
        {
            if (this._gameType == GamehallGameTypes.CHESS)
            {
                this.drawChessStart();
                return;
            }
            this.drawPokerStart();
        }

        override protected function drawBoard():void
        {
            if (this._gameType == GamehallGameTypes.CHESS)
            {
                this.drawChessBoard();
                return;
            }
            this.drawPokerBoard();
        }

        override protected function drawPanelText():void
        {
            if (this._mode != "board")
            {
                return;
            }
            this._panel.addChild(this.createPanelText(this._status, 10, 250, 135, 14, 9, 0x00CC00, TextFormatAlign.LEFT, false));
            var action:String = this._gameType == GamehallGameTypes.POKER ? GamehallCommands.OPEN : GamehallUpdates.TURN;
            this._panel.addChild(this.createPanelText(action, 150, 250, 100, 14, 9, 0x00CC00, TextFormatAlign.RIGHT, true, true));
        }

        override protected function turnStatus():String
        {
            if (this._turnSeat < 0)
            {
                return this._status;
            }
            return this._turnSeat == this._localSeat ? "Your turn" : "Opponent's turn";
        }

        private function drawChessStart():void
        {
            this.drawClassicGameScreen();
            this._panel.addChild(this.createPanelText("Choose your side", 5, 64, 258, 22, 18, 0xEEEEEE, TextFormatAlign.CENTER, false, true));
            this.addAsset("hh_games_game_Wsd", 80, 130);
            this.addAsset("hh_games_game_Bsd", 178, 130);
            this._panel.addChild(this.createPanelText("White", 47, 176, 85, 22, 9, 0xEEEEEE, TextFormatAlign.CENTER, false, true));
            this._panel.addChild(this.createPanelText("Black", 145, 176, 85, 22, 9, 0xEEEEEE, TextFormatAlign.CENTER, false, true));
        }

        private function drawChessBoard():void
        {
            this.drawClassicGameScreen();
            this.addAsset("hh_games_game_chess_gridnumbers", 18, 13);
            this.addAsset("hh_games_game_chess_board_real", 30, 26);
        }

        private function drawPokerStart():void
        {
            this.drawPokerTable();
            this._panel.addChild(this.createPanelText("Poker", 0, 42, SCREEN_WIDTH, 24, 18, 0xEEEEEE, TextFormatAlign.CENTER, false));
            this._panel.addChild(this.createPanelText("Waiting for players", 0, 115, SCREEN_WIDTH, 14, 9, 0x00CC00, TextFormatAlign.CENTER, false));
            this.addAsset("hh_games_game_small_back_1", 118, 150);
        }

        private function drawPokerBoard():void
        {
            this.drawPokerTable();
            this.addAsset("hh_games_game_small_back_1", 38, 190);
            this.addAsset("hh_games_game_small_back_1", 72, 190);
            this.addAsset("hh_games_game_small_back_1", 106, 190);
            this.addAsset("hh_games_game_small_back_1", 140, 190);
            this.addAsset("hh_games_game_small_back_1", 174, 190);
        }

        private function drawPokerTable():void
        {
            this.drawClassicGameScreen();
            var g:* = this._panel.graphics;
            g.lineStyle(1, 0x66CC00);
            g.beginFill(0x003300, 0.35);
            g.drawRoundRect(28, 58, 206, 142, 34, 34);
            g.endFill();
            g.drawRoundRect(42, 75, 178, 108, 28, 28);
        }
    }
}
