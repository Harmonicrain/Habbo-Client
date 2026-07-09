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
    import flash.display.Sprite;
    import flash.events.Event;

    public class GamehallGameWidget extends RoomWidgetBase
    {
        private var _boardWindow:GamehallBoardWindow;
        private var _frame:IWindowContainer;
        private var _panel:Sprite;
        private var _gameAssets:GamehallAssetLibrary;
        private var _view:GamehallGameView;
        private var _stationId:int = -1;
        private var _gameType:String = "";
        private var _localSeat:int;
        private var _seatCount:int;

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
            this._gameType = gameType == null ? "" : gameType;
            this._localSeat = localSeat;
            this._seatCount = seatCount;
            this.createView();
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
            var normalized:String = verb == null ? "" : verb.toUpperCase();
            if (normalized == GamehallUpdates.CLOSE)
            {
                this.close(stationId, reason);
                return;
            }
            if (this._view != null)
            {
                this._view.applyUpdate(normalized, args, reason);
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

        private function createView():void
        {
            if (this._view != null)
            {
                this._view.dispose();
            }
            this._view = GamehallViewFactory.create(this._gameType, this.sendMove, this.render);
            this._view.reset(this._localSeat, this._seatCount);
        }

        private function closeCurrent(reason:String=""):void
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this.destroyFrame();
            this._stationId = -1;
            this._gameType = "";
            this._localSeat = 0;
            this._seatCount = 0;
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
            if (event.type == WindowMouseEvent.CLICK && window != null && window.name == "header_button_close")
            {
                this.sendClose();
                return;
            }
            if (this._view != null)
            {
                this._view.handleWindowEvent(event, window);
            }
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
            if (this._view != null)
            {
                this._view.applyUpdate("", null, "Board graphics unavailable");
            }
            this.render();
        }

        private function render():void
        {
            if (this._panel == null || this._frame == null || this._view == null)
            {
                return;
            }
            this._boardWindow.setFrameCaption(this.gameTitle(this._gameType));
            this._boardWindow.setTextVisible("start_title", false);
            this._boardWindow.setTextVisible("ok_link", false);
            this._boardWindow.setTextVisible("status_text", false);
            this._boardWindow.setTextVisible("turn_link", false);
            while (this._panel.numChildren > 0)
            {
                this._panel.removeChildAt(0);
            }
            this._panel.graphics.clear();
            this._view.render(this._panel, this._gameAssets);
        }

        private function gameTitle(gameType:String):String
        {
            switch (GamehallGameTypes.normalize(gameType))
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
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
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
