package com.sulake.habbo.ui.widget.furniture.gamehall
{
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.games.GameBoardMoveMessageComposer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.handler.GamehallWidgetHandler;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormatAlign;

    public class GamehallGameWidget extends RoomWidgetBase
    {
        private static const SCREEN_WIDTH:int = 270;
        private static const SCREEN_HEIGHT:int = 264;
        private static const BOARD_COLUMNS:int = 13;
        private static const BOARD_ROWS:int = 12;
        private static const CELL_SIZE:int = 19;
        private static const BOARD_OFFSET_X:int = 4;
        private static const BOARD_HIT_X:int = 11;
        private static const BOARD_HIT_Y:int = 5;
        private static const BOARD_HIT_WIDTH:int = 248;
        private static const BOARD_HIT_HEIGHT:int = 229;
        private static const OK_HIT_X:int = 77;
        private static const OK_HIT_Y:int = 211;
        private static const OK_HIT_WIDTH:int = 121;
        private static const OK_HIT_HEIGHT:int = 16;
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

        private var _boardWindow:GamehallBoardWindow;
        private var _frame:IWindowContainer;
        private var _panel:Sprite;
        private var _gameAssets:GamehallAssetLibrary;
        private var _stationId:int = -1;
        private var _gameType:String = "";
        private var _localSeat:int;
        private var _seatCount:int;
        private var _status:String = "";
        private var _mode:String = "start";
        private var _ownGrid:String = "";
        private var _opponentGrid:String = "";
        private var _turnSeat:int = -1;
        private var _tttSide:String = "";
        private var _tttBoardData:String = "";
        private var _placeQueue:Array = [];
        private var _placedShips:Array = [];
        private var _placeHorizontal:Boolean = true;
        private var _placeWaiting:Boolean = false;
        private var _ghostSprite:Sprite;
        private var _ghostCol:int = -1;
        private var _ghostRow:int = -1;
        public function GamehallGameWidget(handler:IRoomWidgetHandler, windowManager:IHabboWindowManager, assets:IAssetLibrary=null, localizations:IHabboLocalizationManager=null)
        {
            super(handler, windowManager, assets, localizations);
            GamehallWidgetHandler(handler).widget = this;
            this._boardWindow = new GamehallBoardWindow(windowManager, assets);
        }

        override public function get mainWindow():IWindow
        {
            return this._boardWindow == null ? null : this._boardWindow.root;
        }

        public function open(stationId:int, gameType:String="", localSeat:int=0, seatCount:int=0, verb:String="", args:Array=null, reason:String=""):void
        {
            this._stationId = stationId;
            this._gameType = (gameType == null) ? "" : gameType;
            this._localSeat = localSeat;
            this._seatCount = seatCount;
            this._status = "";
            this._mode = "start";
            this._ownGrid = "";
            this._opponentGrid = "";
            this._turnSeat = -1;
            this._tttSide = "";
            this._tttBoardData = "";
            this.resetPlacement();
            this.createFrame();
            this.ensureGameAssets();
            this.activateWindow();
            this.render();
            if (verb != "" || reason != "")
            {
                this.applyUpdate(this._stationId, verb, args, reason);
            }
        }

        public function applyUpdate(stationId:int, verb:String="", args:Array=null, reason:String=""):void
        {
            if (stationId != this._stationId)
            {
                return;
            }
            var normalized:String = (verb == null) ? "" : verb.toUpperCase();
            if (normalized == GamehallUpdates.CLOSE)
            {
                this.close(stationId, reason);
                return;
            }
            if (normalized == GamehallUpdates.SELECT_TYPE)
            {
                if (args != null && args.length > 0)
                {
                    this._tttSide = String(args[0]).toUpperCase();
                }
                this._status = this._tttSide == "" ? "Side selected" : "Playing " + this._tttSide;
                this.render();
                return;
            }
            if (normalized == GamehallUpdates.TYPE_RESERVED)
            {
                this._status = "Reserved";
                this.render();
                return;
            }
            if (normalized == GamehallUpdates.BOARD_DATA)
            {
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
                this.render();
                return;
            }
            if (normalized == GamehallUpdates.SITUATION)
            {
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
                this.render();
                return;
            }
            if (normalized == GamehallUpdates.FLEET)
            {
                this.applyBattleshipsFleet(args);
                this.render();
                return;
            }
            if (normalized == GamehallUpdates.TURN)
            {
                this._mode = "board";
                if (args != null && args.length > 0)
                {
                    this._turnSeat = int(args[0]);
                }
                this._status = this.turnStatus();
                this.render();
                return;
            }
            if (normalized == GamehallUpdates.HIT || normalized == GamehallUpdates.HIT_TWICE || normalized == GamehallUpdates.MISS || normalized == GamehallUpdates.SINK)
            {
                this._mode = "board";
                if (normalized == GamehallUpdates.HIT)
                {
                    this._status = "Hit!";
                }
                else if (normalized == GamehallUpdates.HIT_TWICE)
                {
                    this._status = "Direct hit!";
                }
                else if (normalized == GamehallUpdates.SINK)
                {
                    this._status = "Ship sunk!";
                }
                else
                {
                    this._status = "Miss!";
                }
                this.render();
                return;
            }
            if (normalized == GamehallUpdates.WAIT)
            {
                this._status = args != null && args.length > 0 ? args.join(" ") : "Waiting for opponent";
                this.render();
                return;
            }
            if (normalized == GamehallUpdates.OPPONENTS)
            {
                this._status = "Opponent ready";
                this.render();
                return;
            }
            if (normalized == GamehallUpdates.GAME_END || normalized == GamehallUpdates.GAME_OVER)
            {
                this._mode = "board";
                this._status = normalized == GamehallUpdates.GAME_END && args != null && args.length > 0 ? String(args[0]) + " wins" : "Game over";
                this.render();
                return;
            }
            if (reason != "")
            {
                this._status = reason;
            }
            else if (normalized != "")
            {
                this._status = normalized;
                if (args != null && args.length > 0)
                {
                    this._status += " " + args.join(" ");
                }
            }
            this.render();
        }

        public function close(stationId:int, reason:String=""):void
        {
            if (stationId != this._stationId)
            {
                return;
            }
            this.closeCurrent(reason);
        }

        private function closeCurrent(reason:String=""):void
        {
            this.destroyFrame();
            this._stationId = -1;
            this._gameType = "";
            this._localSeat = 0;
            this._seatCount = 0;
            this._status = "";
            this._mode = "start";
            this._ownGrid = "";
            this._opponentGrid = "";
            this._turnSeat = -1;
            this._tttSide = "";
            this._tttBoardData = "";
        }

        private function createFrame():void
        {
            this._panel = this._boardWindow.create(this.gameTitle(this._gameType), this.windowProcedure);
            this._frame = this._boardWindow.frame;
        }

        private function destroyFrame():void
        {
            if (this._boardWindow != null)
            {
                this._boardWindow.destroyFrame();
            }
            this._frame = null;
            this._panel = null;
        }

        private function windowProcedure(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this.activateWindow();
            }
            if (event.type == WindowMouseEvent.MOVE)
            {
                this.handlePlacementHover(event, window);
                return;
            }
            if (event.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (window.name == "header_button_close")
            {
                this.sendClose();
                return;
            }
            if (window.name == "ok_link" && this._mode == "start")
            {
                if (this.gameKey(this._gameType) == GamehallGameTypes.BATTLESHIPS || this.gameKey(this._gameType) == GamehallGameTypes.POKER)
                {
                    this.sendMove(GamehallCommands.OPEN, []);
                }
                return;
            }
            if (window.name == "gamehall_canvas" && this._mode == "start")
            {
                var okMouseEvent:WindowMouseEvent = event as WindowMouseEvent;
                if (okMouseEvent != null && this.gameKey(this._gameType) == GamehallGameTypes.TICTACTOE)
                {
                    if (this.pointInRect(okMouseEvent.localX, okMouseEvent.localY, TTT_X_CHOOSE_X, TTT_CHOOSE_GLYPH_Y, TTT_CHOOSE_SIZE, TTT_CHOOSE_SIZE))
                    {
                        this.sendMove(GamehallCommands.CHOOSE_TYPE, ["X"]);
                    }
                    else if (this.pointInRect(okMouseEvent.localX, okMouseEvent.localY, TTT_O_CHOOSE_X, TTT_CHOOSE_GLYPH_Y, TTT_CHOOSE_SIZE, TTT_CHOOSE_SIZE))
                    {
                        this.sendMove(GamehallCommands.CHOOSE_TYPE, ["O"]);
                    }
                    return;
                }
                if (okMouseEvent != null && this.gameKey(this._gameType) == GamehallGameTypes.BATTLESHIPS)
                {
                    this.handlePlacementClick(okMouseEvent.localX, okMouseEvent.localY);
                }
                return;
            }
            if (window.name == "gamehall_canvas" && this._mode == "board")
            {
                var mouseEvent:WindowMouseEvent = event as WindowMouseEvent;
                if (mouseEvent != null && this.gameKey(this._gameType) == GamehallGameTypes.TICTACTOE)
                {
                    if (this.pointInRect(mouseEvent.localX, mouseEvent.localY, 148, 247, 100, 14))
                    {
                        this.sendMove(GamehallCommands.RESTART, []);
                        return;
                    }
                    if (this._tttSide != "" && this.pointInRect(mouseEvent.localX, mouseEvent.localY, TTT_BOARD_X, TTT_BOARD_Y, TTT_BOARD_COLUMNS * TTT_CELL_SIZE, TTT_BOARD_ROWS * TTT_CELL_SIZE))
                    {
                        this.sendMove(GamehallCommands.SET_SECTOR, [this._tttSide, int((mouseEvent.localX - TTT_BOARD_X) / TTT_CELL_SIZE), int((mouseEvent.localY - TTT_BOARD_Y) / TTT_CELL_SIZE)]);
                    }
                    return;
                }
                if (mouseEvent != null && this.gameKey(this._gameType) == GamehallGameTypes.BATTLESHIPS && this._turnSeat == this._localSeat && this.pointInRect(mouseEvent.localX, mouseEvent.localY, BOARD_HIT_X, BOARD_HIT_Y, BOARD_HIT_WIDTH, BOARD_HIT_HEIGHT))
                {
                    this.sendMove(GamehallCommands.SHOOT, [int((mouseEvent.localX - BOARD_HIT_X) / CELL_SIZE), int((mouseEvent.localY - BOARD_HIT_Y) / CELL_SIZE)]);
                }
            }
        }

        private function pointInRect(px:Number, py:Number, x:int, y:int, width:int, height:int):Boolean
        {
            return px >= x && px < x + width && py >= y && py < y + height;
        }

        private function sendClose():void
        {
            if (this._stationId >= 0)
            {
                this.sendMove(GamehallCommands.CLOSE, []);
            }
            this.closeCurrent();
        }

        private function sendMove(verb:String, args:Array):void
        {
            var handler:GamehallWidgetHandler = _handler as GamehallWidgetHandler;
            if (handler != null && handler.container != null && handler.container.connection != null)
            {
                handler.container.connection.send(new GameBoardMoveMessageComposer(this._stationId, verb, args));
            }
        }

        private function ensureGameAssets():void
        {
            if (this._gameAssets != null)
            {
                return;
            }
            var handler:GamehallWidgetHandler = _handler as GamehallWidgetHandler;
            if (handler == null || handler.container == null || handler.container.config == null)
            {
                return;
            }
            var baseUrl:String = handler.container.config.getProperty("flash.client.url");
            if (baseUrl == null || baseUrl == "")
            {
                return;
            }
            this._gameAssets = new GamehallAssetLibrary();
            this._gameAssets.addEventListener(GamehallAssetLibrary.READY, this.onGameAssetsReady);
            this._gameAssets.addEventListener(GamehallAssetLibrary.ERROR, this.onGameAssetsError);
            this._gameAssets.load(baseUrl);
        }

        private function onGameAssetsReady(event:Event):void
        {
            this.render();
        }

        private function onGameAssetsError(event:Event):void
        {
            this._status = "Board graphics unavailable";
            this.render();
        }

        private function render():void
        {
            if (this._panel == null || this._frame == null)
            {
                return;
            }
            this._boardWindow.setFrameCaption(this.gameTitle(this._gameType));
            this.setTextVisible("start_title", false);
            this.setTextVisible("ok_link", false);
            this.setTextVisible("status_text", false);
            this.setTextVisible("turn_link", false);
            while (this._panel.numChildren > 0)
            {
                this._panel.removeChildAt(0);
            }
            this._panel.graphics.clear();
            if (this._mode == "board")
            {
                this.drawGameBoard();
            }
            else
            {
                this.drawGameStart();
            }
            this.drawPanelText();
        }

        private function drawGameStart():void
        {
            switch (this.gameKey(this._gameType))
            {
                case GamehallGameTypes.TICTACTOE:
                    this.drawTicTacToeStart();
                    return;
                case GamehallGameTypes.CHESS:
                    this.drawChessStart();
                    return;
                case GamehallGameTypes.POKER:
                    this.drawPokerStart();
                    return;
                default:
                    this.drawBattleshipsStart();
                    return;
            }
        }

        private function drawGameBoard():void
        {
            switch (this.gameKey(this._gameType))
            {
                case GamehallGameTypes.TICTACTOE:
                    this.drawTicTacToeBoard();
                    return;
                case GamehallGameTypes.CHESS:
                    this.drawChessBoard();
                    return;
                case GamehallGameTypes.POKER:
                    this.drawPokerBoard();
                    return;
                default:
                    this.drawBattleshipsBoard();
                    return;
            }
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
            if (this.gameKey(this._gameType) == GamehallGameTypes.BATTLESHIPS)
            {
                this.queueShips(5, 1);
                this.queueShips(4, 2);
                this.queueShips(3, 3);
                this.queueShips(2, 4);
            }
        }

        private function queueShips(length:int, count:int):void
        {
            for (var i:int = 0; i < count; i++)
            {
                this._placeQueue.push(length);
            }
        }

        private function drawBattleshipsStart():void
        {
            if (this._placeWaiting)
            {
                this.drawGameScreenFallback();
                return;
            }
            this.drawBattleshipsPlacement();
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
            if (this.gameKey(this._gameType) != GamehallGameTypes.BATTLESHIPS)
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
                this.render();
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
            this.render();
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

        private function drawBattleshipsBoard():void
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

        private function drawTicTacToeStart():void
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

        private function drawTicTacToeBoard():void
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

        private function drawClassicGameScreen():void
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

        private function drawGameScreenFallback():void
        {
            var g:* = this._panel.graphics;
            g.beginFill(0x000000);
            g.drawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            g.endFill();
            g.lineStyle(1, 0x66CC00);
            g.drawRect(1, 1, SCREEN_WIDTH - 2, SCREEN_HEIGHT - 2);
        }

        private function drawBoardFallback():void
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

        private function drawFallbackShips():void
        {
            this._panel.graphics.lineStyle(1, 0x66CC00);
            this.drawShipFallback(50, 83, 93);
            this.drawShipFallback(50, 103, 75);
            this.drawShipFallback(50, 123, 56);
            this.drawShipFallback(50, 142, 36);
        }

        private function drawShipFallback(x:int, y:int, width:int):void
        {
            var g:* = this._panel.graphics;
            g.drawRoundRect(x, y, width, 16, 10, 10);
            g.moveTo(x + 7, y + 4);
            g.lineTo(x + width - 7, y + 4);
            g.moveTo(x + 7, y + 11);
            g.lineTo(x + width - 7, y + 11);
        }

        private function drawPanelText():void
        {
            if (this._mode == "start")
            {
                if (this.gameKey(this._gameType) == GamehallGameTypes.BATTLESHIPS)
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
                }
            }
            else
            {
                if (this.gameKey(this._gameType) == GamehallGameTypes.TICTACTOE)
                {
                    this._panel.addChild(this.createPanelText(this._status, 17, 247, 135, 14, 9, 0xEEEEEE, TextFormatAlign.LEFT, false, false));
                    this._panel.addChild(this.createPanelText("New game", 148, 247, 100, 14, 9, 0xEEEEEE, TextFormatAlign.RIGHT, true, false));
                    return;
                }
                this._panel.addChild(this.createPanelText(this._status, 10, 250, 135, 14, 9, 0x00CC00, TextFormatAlign.LEFT, false));
                var action:String = this.gameKey(this._gameType) == GamehallGameTypes.POKER ? GamehallCommands.OPEN : GamehallUpdates.TURN;
                this._panel.addChild(this.createPanelText(action, 150, 250, 100, 14, 9, 0x00CC00, TextFormatAlign.RIGHT, true, true));
            }
        }

        private function createPanelText(caption:String, x:int, y:int, width:int, height:int, size:int, color:uint, align:String, underline:Boolean, bold:Boolean = false):TextField
        {
            return GamehallFonts.createPanelText(caption, x, y, width, height, size, color, align, underline, bold);
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

        private function turnStatus():String
        {
            if (this._turnSeat < 0)
            {
                return this._status;
            }
            if (this.gameKey(this._gameType) == GamehallGameTypes.BATTLESHIPS)
            {
                return this._turnSeat == this._localSeat ? "Your turn!" : "The Enemy's Turn";
            }
            return this._turnSeat == this._localSeat ? "Your turn" : "Opponent's turn";
        }

        private function addAsset(name:String, x:int, y:int):void
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

        private function assetDisplay(name:String):DisplayObject
        {
            return this._gameAssets == null ? null : this._gameAssets.assetDisplay(name);
        }

        private function hasReadyAsset(name:String):Boolean
        {
            return this._gameAssets != null && this._gameAssets.hasAsset(name);
        }

        private function setTextVisible(name:String, visible:Boolean):void
        {
            if (this._boardWindow != null)
            {
                this._boardWindow.setTextVisible(name, visible);
            }
        }

        private function setCaption(name:String, caption:String):void
        {
            if (this._boardWindow != null)
            {
                this._boardWindow.setCaption(name, caption);
            }
        }

        private function gameTitle(gameType:String):String
        {
            switch (this.gameKey(gameType))
            {
                case GamehallGameTypes.TICTACTOE:
                    return "TicTacToe";
                case GamehallGameTypes.CHESS:
                    return "Chess";
                case GamehallGameTypes.POKER:
                    return "Poker";
                default:
                    return "Battleships";
            }
        }

        private function gameKey(gameType:String):String
        {
            return GamehallGameTypes.normalize(gameType);
        }

        private function activateWindow():void
        {
            if (this._boardWindow != null)
            {
                this._boardWindow.activate();
            }
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            this.destroyFrame();
            if (this._boardWindow != null)
            {
                this._boardWindow.dispose();
                this._boardWindow = null;
            }
            if (this._gameAssets != null)
            {
                this._gameAssets.removeEventListener(GamehallAssetLibrary.READY, this.onGameAssetsReady);
                this._gameAssets.removeEventListener(GamehallAssetLibrary.ERROR, this.onGameAssetsError);
                this._gameAssets.dispose();
                this._gameAssets = null;
            }
            super.dispose();
        }
    }
}
