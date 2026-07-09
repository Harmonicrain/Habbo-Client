package com.sulake.habbo.ui.widget.furniture.gamehall
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormatAlign;

    public class GamehallGameViewBase implements GamehallGameView
    {
        protected static const SCREEN_WIDTH:int = 270;
        protected static const SCREEN_HEIGHT:int = 264;
        protected static const BOARD_COLUMNS:int = 13;
        protected static const BOARD_ROWS:int = 12;
        protected static const CELL_SIZE:int = 19;
        protected static const BOARD_OFFSET_X:int = 4;
        protected static const BOARD_HIT_X:int = 11;
        protected static const BOARD_HIT_Y:int = 5;
        protected static const BOARD_HIT_WIDTH:int = 248;
        protected static const BOARD_HIT_HEIGHT:int = 229;

        protected var _sendMove:Function;
        protected var _invalidate:Function;
        protected var _panel:Sprite;
        protected var _assets:GamehallAssetLibrary;
        protected var _localSeat:int;
        protected var _seatCount:int;
        protected var _status:String = "";
        protected var _mode:String = "start";

        public function GamehallGameViewBase(sendMove:Function, invalidate:Function)
        {
            this._sendMove = sendMove;
            this._invalidate = invalidate;
        }

        public function reset(localSeat:int, seatCount:int):void
        {
            this._localSeat = localSeat;
            this._seatCount = seatCount;
            this._status = "";
            this._mode = "start";
        }

        public function applyUpdate(verb:String="", args:Array=null, reason:String=""):void
        {
            if (reason != "")
            {
                this._status = reason;
            }
            else if (verb != "")
            {
                this._status = verb;
                if (args != null && args.length > 0)
                {
                    this._status += " " + args.join(" ");
                }
            }
        }

        public function render(panel:Sprite, assets:GamehallAssetLibrary):void
        {
            this._panel = panel;
            this._assets = assets;
            if (this._mode == "board")
            {
                this.drawBoard();
            }
            else
            {
                this.drawStart();
            }
            this.drawPanelText();
        }

        public function handleWindowEvent(event:WindowEvent, window:IWindow):void
        {
        }

        public function dispose():void
        {
            this._panel = null;
            this._assets = null;
            this._sendMove = null;
            this._invalidate = null;
        }

        protected function drawStart():void
        {
            this.drawClassicGameScreen();
        }

        protected function drawBoard():void
        {
            this.drawClassicGameScreen();
        }

        protected function drawPanelText():void
        {
            if (this._mode != "board")
            {
                return;
            }
            this._panel.addChild(this.createPanelText(this._status, 10, 250, 135, 14, 9, 0x00CC00, TextFormatAlign.LEFT, false));
            this._panel.addChild(this.createPanelText(GamehallUpdates.TURN, 150, 250, 100, 14, 9, 0x00CC00, TextFormatAlign.RIGHT, true, true));
        }

        protected function sendMove(verb:String, args:Array):void
        {
            if (this._sendMove != null)
            {
                this._sendMove(verb, args);
            }
        }

        protected function invalidate():void
        {
            if (this._invalidate != null)
            {
                this._invalidate();
            }
        }

        protected function pointInRect(px:Number, py:Number, x:int, y:int, width:int, height:int):Boolean
        {
            return px >= x && px < x + width && py >= y && py < y + height;
        }

        protected function turnStatus():String
        {
            return this._status;
        }

        protected function drawClassicGameScreen():void
        {
            var top:DisplayObject = this.assetDisplay("hh_games_game_screen_bup");
            var mid:DisplayObject = this.assetDisplay("hh_games_game_screen_midg");
            var bottom:DisplayObject = this.assetDisplay("hh_games_game_screen_downer");
            if (top != null && mid != null && bottom != null)
            {
                top.x = 0;
                this._panel.addChild(top);
                mid.x = 0;
                mid.y = 10;
                mid.height = SCREEN_HEIGHT - int(top.height) - int(bottom.height);
                this._panel.addChild(mid);
                bottom.x = 0;
                bottom.y = SCREEN_HEIGHT - int(bottom.height);
                this._panel.addChild(bottom);
                return;
            }
            this.drawGameScreenFallback();
        }

        protected function drawGameScreenFallback():void
        {
            var g:* = this._panel.graphics;
            g.beginFill(0x000000);
            g.drawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            g.endFill();
            g.lineStyle(1, 0x66CC00);
            g.drawRect(1, 1, SCREEN_WIDTH - 2, SCREEN_HEIGHT - 2);
        }

        protected function drawBoardFallback():void
        {
            this.drawGameScreenFallback();
            var g:* = this._panel.graphics;
            g.lineStyle(1, 0x66CC00, 1);
            for (var column:int = 0; column <= BOARD_COLUMNS; column++)
            {
                g.moveTo(BOARD_HIT_X + column * CELL_SIZE, BOARD_HIT_Y);
                g.lineTo(BOARD_HIT_X + column * CELL_SIZE, BOARD_HIT_Y + BOARD_ROWS * CELL_SIZE);
            }
            for (var row:int = 0; row <= BOARD_ROWS; row++)
            {
                g.moveTo(BOARD_HIT_X, BOARD_HIT_Y + row * CELL_SIZE);
                g.lineTo(BOARD_HIT_X + BOARD_COLUMNS * CELL_SIZE, BOARD_HIT_Y + row * CELL_SIZE);
            }
        }

        protected function addAsset(name:String, x:int, y:int):void
        {
            var display:DisplayObject = this.assetDisplay(name);
            if (display == null)
            {
                return;
            }
            display.x = x;
            display.y = y;
            this._panel.addChild(display);
        }

        protected function assetDisplay(name:String):DisplayObject
        {
            return this._assets == null ? null : this._assets.assetDisplay(name);
        }

        protected function hasReadyAsset(name:String):Boolean
        {
            return this._assets != null && this._assets.hasAsset(name);
        }

        protected function createPanelText(caption:String, x:int, y:int, width:int, height:int, size:int, color:uint, align:String, underline:Boolean, bold:Boolean = false):TextField
        {
            return GamehallFonts.createPanelText(caption, x, y, width, height, size, color, align, underline, bold);
        }
    }
}
