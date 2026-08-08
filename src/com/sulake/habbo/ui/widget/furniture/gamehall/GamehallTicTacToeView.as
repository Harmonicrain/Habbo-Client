package com.sulake.habbo.ui.widget.furniture.gamehall
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.text.TextFormatAlign;

    public class GamehallTicTacToeView extends GamehallGameViewBase
    {
        private static const TTT_CHOOSE_GLYPH_Y:int = 86;
        private static const TTT_CHOOSE_GLYPH_BLOCK:int = 4;
        private static const TTT_BOARD_X:int = 14;
        private static const TTT_BOARD_Y:int = 15;
        private static const TTT_BOARD_COLUMNS:int = 24;
        private static const TTT_BOARD_ROWS:int = 23;
        private static const TTT_CELL_SIZE:int = 10;
        private static const TTT_MARK_OFFSET_X:int = 1;
        private static const TTT_MARK_OFFSET_Y:int = 1;
        private static const TTT_X_CHOOSE_X:int = 83;
        private static const TTT_O_CHOOSE_X:int = 163;
        private static const TTT_CHOOSE_SIZE:int = 40;
        private static const GAME_RESULT_WIN:String = "WIN";
        private static const GAME_RESULT_LOSE:String = "LOSE";

        private var _gameResultLocked:Boolean = false;
        private var _turnSeat:int = -1;
        private var _tttSide:String = "";
        private var _tttBoardData:String = "";

        public function GamehallTicTacToeView(sendMove:Function, invalidate:Function)
        {
            super(sendMove, invalidate);
        }

        override public function reset(localSeat:int, seatCount:int):void
        {
            super.reset(localSeat, seatCount);
            this._gameResultLocked = false;
            this._turnSeat = -1;
            this._tttSide = "";
            this._tttBoardData = "";
        }

        override public function applyUpdate(verb:String="", args:Array=null, reason:String=""):void
        {
            if (verb == GamehallUpdates.SELECT_TYPE)
            {
                this._gameResultLocked = false;
                if (args != null && args.length > 0)
                {
                    this._tttSide = String(args[0]).toUpperCase();
                }
                this._status = this._tttSide == "" ? "Side selected" : "Playing " + this._tttSide;
                return;
            }
            if (verb == GamehallUpdates.TYPE_RESERVED)
            {
                if (!this._gameResultLocked)
                {
                    this._status = "Reserved";
                }
                return;
            }
            if (verb == GamehallUpdates.BOARD_DATA)
            {
                this._gameResultLocked = false;
                this._mode = "board";
                if (args != null)
                {
                    if (args.length > 0)
                    {
                        this._status = String(args[0]);
                    }
                    if (args.length > 2)
                    {
                        this._tttBoardData = String(args[2]);
                    }
                }
                return;
            }
            if (verb == GamehallUpdates.TURN)
            {
                this._gameResultLocked = false;
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
                this._gameResultLocked = false;
                this._status = args != null && args.length > 0 ? args.join(" ") : "Waiting for opponent";
                return;
            }
            if (verb == GamehallUpdates.OPPONENTS)
            {
                this._gameResultLocked = false;
                this._status = "Opponent ready";
                return;
            }
            if (verb == GamehallUpdates.GAME_END)
            {
                this._mode = "board";
                this._gameResultLocked = true;
                this._status = this.gameEndStatus(args);
                return;
            }
            if (verb == GamehallUpdates.GAME_OVER)
            {
                this._mode = "board";
                if (!this._gameResultLocked)
                {
                    this._status = "Game over";
                }
                return;
            }
            super.applyUpdate(verb, args, reason);
        }

        override public function handleWindowEvent(event:WindowEvent, window:IWindow):void
        {
            if (event.type != WindowMouseEvent.CLICK || window == null || window.name != "gamehall_canvas")
            {
                return;
            }
            var mouseEvent:WindowMouseEvent = event as WindowMouseEvent;
            if (mouseEvent == null)
            {
                return;
            }
            if (this._mode == "start")
            {
                if (this.pointInRect(mouseEvent.localX, mouseEvent.localY, TTT_X_CHOOSE_X, TTT_CHOOSE_GLYPH_Y, TTT_CHOOSE_SIZE, TTT_CHOOSE_SIZE))
                {
                    this.sendMove(GamehallCommands.CHOOSE_TYPE, ["X"]);
                }
                else if (this.pointInRect(mouseEvent.localX, mouseEvent.localY, TTT_O_CHOOSE_X, TTT_CHOOSE_GLYPH_Y, TTT_CHOOSE_SIZE, TTT_CHOOSE_SIZE))
                {
                    this.sendMove(GamehallCommands.CHOOSE_TYPE, ["O"]);
                }
                return;
            }
            if (this._mode == "board")
            {
                if (this.pointInRect(mouseEvent.localX, mouseEvent.localY, 148, 247, 100, 14))
                {
                    this.sendMove(GamehallCommands.RESTART, []);
                    return;
                }
                if (!this._gameResultLocked && this._tttSide != "" && this.pointInRect(mouseEvent.localX, mouseEvent.localY, TTT_BOARD_X, TTT_BOARD_Y, TTT_BOARD_COLUMNS * TTT_CELL_SIZE, TTT_BOARD_ROWS * TTT_CELL_SIZE))
                {
                    this.sendMove(GamehallCommands.SET_SECTOR, [this._tttSide, int((mouseEvent.localX - TTT_BOARD_X) / TTT_CELL_SIZE), int((mouseEvent.localY - TTT_BOARD_Y) / TTT_CELL_SIZE)]);
                }
            }
        }

        override protected function drawStart():void
        {
            this.drawClassicGameScreen();
            var board:DisplayObject = this.assetDisplay("hh_games_game_TicTacToe_board_real");
            if (board != null)
            {
                board.x = TTT_BOARD_X;
                board.y = TTT_BOARD_Y;
                this._panel.addChild(board);
            }
            else
            {
                this.drawTicTacToeFallbackGrid();
            }
            this.addTicTacToeChooseGlyph("X", TTT_X_CHOOSE_X, TTT_CHOOSE_GLYPH_Y, 0x003366);
            this.addTicTacToeChooseGlyph("O", TTT_O_CHOOSE_X, TTT_CHOOSE_GLYPH_Y, 0x770000);
            this._panel.addChild(this.createPanelText("Choose your side", 17, 247, 121, 22, 9, 0xEEEEEE, TextFormatAlign.LEFT, false, false));
        }

        override protected function drawBoard():void
        {
            this.drawClassicGameScreen();
            var board:DisplayObject = this.assetDisplay("hh_games_game_TicTacToe_board_real");
            if (board != null)
            {
                board.x = TTT_BOARD_X;
                board.y = TTT_BOARD_Y;
                this._panel.addChild(board);
            }
            else
            {
                this.drawTicTacToeFallbackGrid();
            }
            this.drawTicTacToeMarks();
        }

        override protected function drawPanelText():void
        {
            if (this._mode != "board")
            {
                return;
            }
            this._panel.addChild(this.createPanelText(this._status, 17, 247, 135, 14, 9, 0xEEEEEE, TextFormatAlign.LEFT, false, false));
            this._panel.addChild(this.createPanelText("New game", 148, 247, 100, 14, 9, 0xEEEEEE, TextFormatAlign.RIGHT, true, false));
        }

        override protected function turnStatus():String
        {
            if (this._turnSeat < 0)
            {
                return this._status;
            }
            return this._turnSeat == this._localSeat ? "Your turn" : "Opponent's turn";
        }

        private function gameEndStatus(args:Array):String
        {
            if (args == null || args.length == 0)
            {
                return "Game over";
            }
            var result:String = String(args[0]).toUpperCase();
            if (result == GAME_RESULT_WIN)
            {
                return "You Won!";
            }
            if (result == GAME_RESULT_LOSE)
            {
                return "Game over";
            }
            return String(args[0]) + " wins";
        }

        private function addTicTacToeChooseGlyph(caption:String, x:int, y:int, color:uint):void
        {
            var sprite:Sprite = new Sprite();
            sprite.x = x;
            sprite.y = y;
            var mask:Array = caption == "O" ?
                ["..######..",
                 "..######..",
                 "##......##",
                 "##......##",
                 "##......##",
                 "##......##",
                 "##......##",
                 "##......##",
                 "..######..",
                 "..######.."] :
                ["##......##",
                 "##......##",
                 "..##..##..",
                 "..##..##..",
                 "....##....",
                 "....##....",
                 "..##..##..",
                 "..##..##..",
                 "##......##",
                 "##......##"];
            sprite.graphics.beginFill(color);
            for (var row:int = 0; row < mask.length; row++)
            {
                var line:String = mask[row];
                for (var column:int = 0; column < line.length; column++)
                {
                    if (line.charAt(column) == "#")
                    {
                        sprite.graphics.drawRect(column * TTT_CHOOSE_GLYPH_BLOCK, row * TTT_CHOOSE_GLYPH_BLOCK, TTT_CHOOSE_GLYPH_BLOCK, TTT_CHOOSE_GLYPH_BLOCK);
                    }
                }
            }
            sprite.graphics.endFill();
            this._panel.addChild(sprite);
        }

        private function drawTicTacToeMarks():void
        {
            if (this._tttBoardData == null || this._tttBoardData.length == 0)
            {
                return;
            }
            for (var row:int = 0; row < TTT_BOARD_ROWS; row++)
            {
                for (var column:int = 0; column < TTT_BOARD_COLUMNS; column++)
                {
                    var index:int = row * (TTT_BOARD_COLUMNS + 1) + column;
                    if (index >= this._tttBoardData.length)
                    {
                        return;
                    }
                    var marker:String = this._tttBoardData.charAt(index);
                    if (marker == " " || marker == "")
                    {
                        continue;
                    }
                    this.addTicTacToeBoardGlyph(marker, TTT_BOARD_X + column * TTT_CELL_SIZE + TTT_MARK_OFFSET_X, TTT_BOARD_Y + row * TTT_CELL_SIZE + TTT_MARK_OFFSET_Y);
                }
            }
        }

        private function addTicTacToeBoardGlyph(marker:String, x:int, y:int):void
        {
            var normalized:String = marker == "q" ? "O" : marker == "+" ? "X" : marker;
            if (normalized != "X" && normalized != "O")
            {
                return;
            }
            var color:uint = normalized == "O" ? 0x770000 : 0x003366;
            var mask:Array = normalized == "O" ?
                ["..#####..",
                 ".##...##.",
                 "##.....##",
                 "#.......#",
                 "#.......#",
                 "#.......#",
                 "##.....##",
                 ".##...##.",
                 "..#####.."] :
                ["##.....##",
                 ".##...##.",
                 "..##.##..",
                 "...###...",
                 "...###...",
                 "..##.##..",
                 ".##...##.",
                 "##.....##",
                 "#.......#"];
            var sprite:Sprite = new Sprite();
            sprite.x = x;
            sprite.y = y;
            sprite.graphics.beginFill(color);
            for (var row:int = 0; row < mask.length; row++)
            {
                var line:String = mask[row];
                for (var column:int = 0; column < line.length; column++)
                {
                    if (line.charAt(column) == "#")
                    {
                        sprite.graphics.drawRect(column, row, 1, 1);
                    }
                }
            }
            sprite.graphics.endFill();
            this._panel.addChild(sprite);
        }

        private function drawTicTacToeFallbackGrid():void
        {
            var g:* = this._panel.graphics;
            g.lineStyle(1, 0x66CC00, 1);
            g.drawRect(TTT_BOARD_X, TTT_BOARD_Y, TTT_BOARD_COLUMNS * TTT_CELL_SIZE + 1, TTT_BOARD_ROWS * TTT_CELL_SIZE + 1);
            for (var column:int = 1; column < TTT_BOARD_COLUMNS; column++)
            {
                g.moveTo(TTT_BOARD_X + column * TTT_CELL_SIZE, TTT_BOARD_Y);
                g.lineTo(TTT_BOARD_X + column * TTT_CELL_SIZE, TTT_BOARD_Y + TTT_BOARD_ROWS * TTT_CELL_SIZE + 1);
            }
            for (var row:int = 1; row < TTT_BOARD_ROWS; row++)
            {
                g.moveTo(TTT_BOARD_X, TTT_BOARD_Y + row * TTT_CELL_SIZE);
                g.lineTo(TTT_BOARD_X + TTT_BOARD_COLUMNS * TTT_CELL_SIZE + 1, TTT_BOARD_Y + row * TTT_CELL_SIZE);
            }
        }
    }
}
