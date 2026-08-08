package com.sulake.habbo.ui.widget.furniture.gamehall
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.text.TextFormatAlign;

    public class GamehallBattleshipsView extends GamehallGameViewBase
    {
        private static const OK_HIT_X:int = 77;
        private static const OK_HIT_Y:int = 211;
        private static const OK_HIT_WIDTH:int = 121;
        private static const OK_HIT_HEIGHT:int = 16;
        private static const GAME_RESULT_WIN:String = "WIN";
        private static const GAME_RESULT_LOSE:String = "LOSE";

        private var _gameResultLocked:Boolean = false;
        private var _ownGrid:String = "";
        private var _opponentGrid:String = "";
        private var _turnSeat:int = -1;
        private var _placeQueue:Array = [];
        private var _placedShips:Array = [];
        private var _placeHorizontal:Boolean = true;
        private var _placeWaiting:Boolean = false;
        private var _ghostSprite:Sprite;
        private var _ghostCol:int = -1;
        private var _ghostRow:int = -1;

        public function GamehallBattleshipsView(sendMove:Function, invalidate:Function)
        {
            super(sendMove, invalidate);
        }

        override public function reset(localSeat:int, seatCount:int):void
        {
            super.reset(localSeat, seatCount);
            this._gameResultLocked = false;
            this._ownGrid = "";
            this._opponentGrid = "";
            this._turnSeat = -1;
            this.resetPlacement();
        }

        override public function applyUpdate(verb:String="", args:Array=null, reason:String=""):void
        {
            if (verb == GamehallCommands.RESTART || verb == "STARTOVER")
            {
                this.resetBattleshipsBoardState();
                return;
            }
            if (verb == GamehallUpdates.SITUATION)
            {
                this._gameResultLocked = false;
                this._mode = "board";
                if (args != null)
                {
                    if (args.length > 1)
                    {
                        this._ownGrid = String(args[1]);
                    }
                    if (args.length > 3)
                    {
                        this._opponentGrid = String(args[3]);
                    }
                }
                this._status = this.turnStatus();
                return;
            }
            if (verb == GamehallUpdates.FLEET)
            {
                this._gameResultLocked = false;
                this.applyBattleshipsFleet(args);
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
            if (verb == GamehallUpdates.HIT || verb == GamehallUpdates.HIT_TWICE || verb == GamehallUpdates.MISS || verb == GamehallUpdates.SINK)
            {
                this._mode = "board";
                if (verb == GamehallUpdates.HIT)
                {
                    this._status = "Hit!";
                }
                else if (verb == GamehallUpdates.HIT_TWICE)
                {
                    this._status = "Direct hit!";
                }
                else if (verb == GamehallUpdates.SINK)
                {
                    this._status = "Ship sunk!";
                }
                else
                {
                    this._status = "Miss!";
                }
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
            if (event.type == WindowMouseEvent.MOVE)
            {
                this.handlePlacementHover(event, window);
                return;
            }
            if (event.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (window == null)
            {
                return;
            }
            if (window.name == "ok_link" && this._mode == "start")
            {
                this.sendMove(GamehallCommands.OPEN, []);
                return;
            }
            if (window.name != "gamehall_canvas")
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
                this.handlePlacementClick(mouseEvent.localX, mouseEvent.localY);
                return;
            }
            if (this._mode == "board" && this._gameResultLocked)
            {
                if (this.pointInRect(mouseEvent.localX, mouseEvent.localY, 150, 248, 110, 16))
                {
                    this.sendMove(GamehallCommands.RESTART, []);
                }
                return;
            }
            if (this._mode == "board" && this._turnSeat == this._localSeat && this.pointInRect(mouseEvent.localX, mouseEvent.localY, BOARD_HIT_X, BOARD_HIT_Y, BOARD_HIT_WIDTH, BOARD_HIT_HEIGHT))
            {
                this.sendMove(GamehallCommands.SHOOT, [int((mouseEvent.localX - BOARD_HIT_X) / CELL_SIZE), int((mouseEvent.localY - BOARD_HIT_Y) / CELL_SIZE)]);
            }
        }

        override protected function drawStart():void
        {
            if (this._placeWaiting)
            {
                this.drawGameScreenFallback();
                return;
            }
            this.drawBattleshipsPlacement();
        }

        override protected function drawBoard():void
        {
            var board:DisplayObject = this.assetDisplay("hh_games_game_battleships_board_real");
            if (board != null)
            {
                board.x = BOARD_OFFSET_X;
                this._panel.addChild(board);
            }
            else
            {
                this.drawBoardFallback();
            }
            if (this.isBattleshipsDefenceView())
            {
                for each (var ship:Object in this._placedShips)
                {
                    this.drawPlacedShip(int(ship.length), int(ship.col), int(ship.row), Boolean(ship.horizontal), 1.0);
                }
            }
            this.drawBattleshipsMarkers();
        }

        override protected function drawPanelText():void
        {
            if (this._mode == "start")
            {
                if (this._placeWaiting)
                {
                    this._panel.addChild(this.createPanelText("WAITING FOR THE OPPONENT", 0, 124, SCREEN_WIDTH, 16, 9, 0xEEEEEE, TextFormatAlign.CENTER, false, true));
                }
                else
                {
                    this._panel.addChild(this.createPanelText(this.placementLabel(), 10, 250, 150, 14, 9, 0x00CC00, TextFormatAlign.LEFT, false, true));
                    this._panel.addChild(this.createPanelText("TURN", 150, 250, 110, 14, 9, 0x00CC00, TextFormatAlign.RIGHT, true, true));
                }
                return;
            }
            this._panel.addChild(this.createPanelText(this._status, 10, 250, 135, 14, 9, 0x00CC00, TextFormatAlign.LEFT, false));
            if (this._gameResultLocked)
            {
                this._panel.addChild(this.createPanelText("New game", 150, 250, 100, 14, 9, 0x00CC00, TextFormatAlign.RIGHT, true, true));
            }
        }

        override protected function turnStatus():String
        {
            if (this._turnSeat < 0)
            {
                return this._status;
            }
            return this._turnSeat == this._localSeat ? "Your turn!" : "The Enemy's Turn";
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

        private function resetPlacement():void
        {
            this._placeQueue = [];
            this._placedShips = [];
            this._placeHorizontal = true;
            this._placeWaiting = false;
            this._ghostSprite = null;
            this._ghostCol = -1;
            this._ghostRow = -1;
            this.queueShips(5, 1);
            this.queueShips(4, 2);
            this.queueShips(3, 3);
            this.queueShips(2, 4);
        }

        private function resetBattleshipsBoardState():void
        {
            this._mode = "start";
            this._status = "";
            this._gameResultLocked = false;
            this._ownGrid = "";
            this._opponentGrid = "";
            this._turnSeat = -1;
            this.resetPlacement();
        }

        private function queueShips(length:int, count:int):void
        {
            for (var i:int = 0; i < count; i++)
            {
                this._placeQueue.push(length);
            }
        }

        private function drawBattleshipsPlacement():void
        {
            var board:DisplayObject = this.assetDisplay("hh_games_game_battleships_board_real");
            if (board != null)
            {
                board.x = BOARD_OFFSET_X;
                this._panel.addChild(board);
            }
            else
            {
                this.drawBoardFallback();
            }
            for each (var ship:Object in this._placedShips)
            {
                this.drawPlacedShip(int(ship.length), int(ship.col), int(ship.row), Boolean(ship.horizontal), 1.0);
            }
            this._ghostSprite = new Sprite();
            this._ghostSprite.mouseEnabled = false;
            this._ghostSprite.mouseChildren = false;
            this._panel.addChild(this._ghostSprite);
            this.drawGhost();
        }

        private function drawGhost():void
        {
            if (this._ghostSprite == null)
            {
                return;
            }
            while (this._ghostSprite.numChildren > 0)
            {
                this._ghostSprite.removeChildAt(0);
            }
            this._ghostSprite.graphics.clear();
            if (this._placeWaiting || this._placeQueue.length == 0 || this._ghostCol < 0 || this._ghostRow < 0)
            {
                return;
            }
            var length:int = int(this._placeQueue[0]);
            var head:Object = this.placementHead(this._ghostCol, this._ghostRow, length);
            this.drawShipInto(this._ghostSprite, length, int(head.col), int(head.row), this._placeHorizontal, 1.0);
        }

        private function placementHead(col:int, row:int, length:int):Object
        {
            var headCol:int = col;
            var headRow:int = row;
            if (this._placeHorizontal)
            {
                headCol = col - int(length / 2);
                if (headCol < 0) { headCol = 0; }
                if (headCol + length > BOARD_COLUMNS) { headCol = BOARD_COLUMNS - length; }
            }
            else
            {
                headRow = row - int(length / 2);
                if (headRow < 0) { headRow = 0; }
                if (headRow + length > BOARD_ROWS) { headRow = BOARD_ROWS - length; }
            }
            return {col:headCol, row:headRow};
        }

        private function drawPlacedShip(length:int, col:int, row:int, horizontal:Boolean, alpha:Number):void
        {
            this.drawShipInto(this._panel, length, col, row, horizontal, alpha);
        }

        private function drawShipInto(target:Sprite, length:int, col:int, row:int, horizontal:Boolean, alpha:Number):void
        {
            var px:int = BOARD_HIT_X + col * CELL_SIZE;
            var py:int = BOARD_HIT_Y + row * CELL_SIZE;
            var footWidth:int = horizontal ? length * CELL_SIZE : CELL_SIZE;
            var footHeight:int = horizontal ? CELL_SIZE : length * CELL_SIZE;
            var name:String = "hh_games_game_bs_ship_" + length + (horizontal ? "_h" : "_v");
            var display:DisplayObject = this.assetDisplay(name);
            if (display != null)
            {
                display.x = px + int((footWidth - display.width) / 2);
                display.y = py + int((footHeight - display.height) / 2);
                display.alpha = alpha;
                target.addChild(display);
                return;
            }
            var g:* = target.graphics;
            g.lineStyle(2, 0x66CC00, alpha);
            g.beginFill(0x66CC00, 0.15 * alpha + 0.05);
            g.drawRoundRect(px + 2, py + 2, footWidth - 4, footHeight - 4, 9, 9);
            g.endFill();
        }

        private function placementLabel():String
        {
            if (this._placeQueue.length == 0)
            {
                return "";
            }
            var length:int = int(this._placeQueue[0]);
            if (length == 5)
            {
                return "An aircraft carrier";
            }
            var count:int = 0;
            for each (var entry:* in this._placeQueue)
            {
                if (int(entry) == length)
                {
                    count++;
                }
            }
            return count + " " + this.shipName(length) + "(s)";
        }

        private function shipName(length:int):String
        {
            switch (length)
            {
                case 5: return "Aircraft Carrier";
                case 4: return "Battle Ship";
                case 3: return "Cruiser";
                case 2: return "Destroyer";
            }
            return "Ship";
        }

        private function handlePlacementHover(event:WindowEvent, window:IWindow):void
        {
            if (window == null || window.name != "gamehall_canvas" || this._mode != "start" || this._placeWaiting)
            {
                return;
            }
            var moveEvent:WindowMouseEvent = event as WindowMouseEvent;
            if (moveEvent == null)
            {
                return;
            }
            var col:int = int((moveEvent.localX - BOARD_HIT_X) / CELL_SIZE);
            var row:int = int((moveEvent.localY - BOARD_HIT_Y) / CELL_SIZE);
            if (col < 0 || col >= BOARD_COLUMNS || row < 0 || row >= BOARD_ROWS)
            {
                col = -1;
                row = -1;
            }
            if (col != this._ghostCol || row != this._ghostRow)
            {
                this._ghostCol = col;
                this._ghostRow = row;
                this.drawGhost();
            }
        }

        private function handlePlacementClick(localX:Number, localY:Number):void
        {
            if (this._placeWaiting)
            {
                return;
            }
            if (this.pointInRect(localX, localY, 150, 248, 110, 16))
            {
                this._placeHorizontal = !this._placeHorizontal;
                this.invalidate();
                return;
            }
            var col:int = int((localX - BOARD_HIT_X) / CELL_SIZE);
            var row:int = int((localY - BOARD_HIT_Y) / CELL_SIZE);
            if (col < 0 || col >= BOARD_COLUMNS || row < 0 || row >= BOARD_ROWS)
            {
                return;
            }
            this.tryPlaceCurrentShip(col, row);
        }

        private function tryPlaceCurrentShip(col:int, row:int):void
        {
            if (this._placeQueue.length == 0)
            {
                return;
            }
            var length:int = int(this._placeQueue[0]);
            var head:Object = this.placementHead(col, row, length);
            var headCol:int = int(head.col);
            var headRow:int = int(head.row);
            var endCol:int = this._placeHorizontal ? headCol + length - 1 : headCol;
            var endRow:int = this._placeHorizontal ? headRow : headRow + length - 1;
            if (this.placementOverlaps(headCol, headRow, endCol, endRow))
            {
                return;
            }
            this.sendMove(GamehallCommands.PLACE_SHIP, [length, headCol, headRow, endCol, endRow]);
            this._placedShips.push({length:length, col:headCol, row:headRow, horizontal:this._placeHorizontal});
            this._placeQueue.shift();
            if (this._placeQueue.length == 0)
            {
                this._placeWaiting = true;
                this._status = "Waiting for opponent";
            }
            this.invalidate();
        }

        private function placementOverlaps(startCol:int, startRow:int, endCol:int, endRow:int):Boolean
        {
            for each (var ship:Object in this._placedShips)
            {
                var oc:int = int(ship.col);
                var orow:int = int(ship.row);
                var olen:int = int(ship.length);
                var oec:int = Boolean(ship.horizontal) ? oc + olen - 1 : oc;
                var oer:int = Boolean(ship.horizontal) ? orow : orow + olen - 1;
                if (startCol <= oec && endCol >= oc && startRow <= oer && endRow >= orow)
                {
                    return true;
                }
            }
            return false;
        }

        private function applyBattleshipsFleet(args:Array):void
        {
            this._placedShips = [];
            if (args == null || args.length == 0)
            {
                return;
            }
            var encoded:String = String(args[0]);
            if (encoded == "")
            {
                return;
            }
            var entries:Array = encoded.split(";");
            for each (var entry:String in entries)
            {
                var fields:Array = entry.split(",");
                if (fields.length < 4)
                {
                    continue;
                }
                var length:int = int(fields[0]);
                var col:int = int(fields[1]);
                var row:int = int(fields[2]);
                var horizontal:Boolean = String(fields[3]).toUpperCase() != "V";
                if (length < 2 || length > 5 || col < 0 || row < 0)
                {
                    continue;
                }
                if (horizontal && col + length > BOARD_COLUMNS)
                {
                    continue;
                }
                if (!horizontal && row + length > BOARD_ROWS)
                {
                    continue;
                }
                this._placedShips.push({length:length, col:col, row:row, horizontal:horizontal});
            }
            if (this._placedShips.length >= 10)
            {
                this._placeQueue = [];
                this._placeWaiting = this._mode != "board";
            }
        }

        private function drawBattleshipsMarkers():void
        {
            var grid:String = this.battleshipsVisibleGrid();
            if (grid == null || grid.length == 0)
            {
                return;
            }
            for (var row:int = 0; row < BOARD_ROWS; row++)
            {
                for (var column:int = 0; column < BOARD_COLUMNS; column++)
                {
                    var index:int = row * BOARD_COLUMNS + column;
                    if (index >= grid.length)
                    {
                        return;
                    }
                    var marker:String = grid.charAt(index);
                    if (marker == "-" || marker == "")
                    {
                        continue;
                    }
                    this.drawBattleshipsMarker(marker, column, row);
                }
            }
        }

        private function battleshipsVisibleGrid():String
        {
            var preferred:String = this.isBattleshipsDefenceView() ? this._ownGrid : this._opponentGrid;
            if (preferred != null && preferred.length > 0)
            {
                return preferred;
            }
            return this.isBattleshipsDefenceView() ? this._opponentGrid : this._ownGrid;
        }

        private function isBattleshipsDefenceView():Boolean
        {
            return this._turnSeat >= 0 && this._turnSeat != this._localSeat;
        }

        private function drawBattleshipsMarker(marker:String, column:int, row:int):void
        {
            var assetName:String = null;
            if (marker == "X")
            {
                assetName = "hh_games_game_bs_hit";
            }
            else if (marker == "O")
            {
                assetName = "hh_games_game_bs_miss";
            }
            else if (marker == "S")
            {
                assetName = "hh_games_game_bs_sink";
            }
            var display:DisplayObject = assetName == null ? null : this.assetDisplay(assetName);
            if (display != null)
            {
                display.x = BOARD_HIT_X + column * CELL_SIZE + int((CELL_SIZE - display.width) / 2);
                display.y = BOARD_HIT_Y + row * CELL_SIZE + int((CELL_SIZE - display.height) / 2);
                this._panel.addChild(display);
                return;
            }
            this._panel.addChild(this.createPanelText(marker, BOARD_HIT_X + column * CELL_SIZE, BOARD_HIT_Y + row * CELL_SIZE + 4, CELL_SIZE, 12, 9, 0x66CC00, TextFormatAlign.CENTER, false));
        }
    }
}
