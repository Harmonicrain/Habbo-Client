package com.sulake.habbo.toolbar.extensions
{
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.CloseConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.RoomReadyMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.games.RequestGamehallLeaderboardMessageComposer;
    import com.sulake.habbo.communication.messages.parser.room.session.RoomReadyMessageParser;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.habbo.toolbar.ToolbarDisplayExtensionIds;
    import flash.utils.getTimer;

    public class GamehallLeaderboardPromptExtension implements IDisposable
    {
        private static const GAMEHALL_MODELS:Object = {
            "hallA": "TICTACTOE",
            "hallB": "BATTLESHIPS",
            "hallC": "CHESS",
            "hallD": "POKER"
        };

        private var _toolbar:HabboToolbar;
        private var _window:IWindowContainer;
        private var _button:IButtonWindow;
        private var _buttonLabel:ITextWindow;
        private var _roomReadyEvent:IMessageEvent;
        private var _closeConnectionEvent:IMessageEvent;
        private var _lastRequestTime:int;
        private var _currentGameType:String = "ALL";

        public function GamehallLeaderboardPromptExtension(toolbar:HabboToolbar)
        {
            this._toolbar = toolbar;
            if (this._toolbar.connection != null)
            {
                this._roomReadyEvent = new RoomReadyMessageEvent(this.onRoomReady);
                this._closeConnectionEvent = new CloseConnectionMessageEvent(this.onCloseConnection);
                this._toolbar.connection.addMessageEvent(this._roomReadyEvent);
                this._toolbar.connection.addMessageEvent(this._closeConnectionEvent);
            }
        }

        public function get disposed():Boolean
        {
            return this._toolbar == null;
        }

        public function dispose():void
        {
            if (this.disposed)
            {
                return;
            }
            this.hide();
            if (this._toolbar.connection != null)
            {
                if (this._roomReadyEvent != null)
                {
                    this._toolbar.connection.removeMessageEvent(this._roomReadyEvent);
                    this._roomReadyEvent = null;
                }
                if (this._closeConnectionEvent != null)
                {
                    this._toolbar.connection.removeMessageEvent(this._closeConnectionEvent);
                    this._closeConnectionEvent = null;
                }
            }
            this.destroyWindow();
            this._toolbar = null;
        }

        private function onRoomReady(event:IMessageEvent):void
        {
            var roomReady:RoomReadyMessageEvent = event as RoomReadyMessageEvent;
            if (roomReady == null || roomReady.getParser() == null)
            {
                this.hide();
                return;
            }
            var parser:RoomReadyMessageParser = roomReady.getParser();
            var gameType:String = GAMEHALL_MODELS[parser.roomType] as String;
            if (gameType != null)
            {
                this._currentGameType = gameType;
                this.show();
            }
            else
            {
                this._currentGameType = "ALL";
                this.hide();
            }
        }

        private function onCloseConnection(event:IMessageEvent):void
        {
            this.hide();
        }

        private function show():void
        {
            if (this._toolbar == null || this._toolbar.extensionView == null)
            {
                return;
            }
            if (this._window == null)
            {
                this.createWindow();
            }
            if (this._window == null)
            {
                return;
            }
            if (!this._toolbar.extensionView.hasExtension(ToolbarDisplayExtensionIds.GAMEHALL_LEADERBOARD_PROMPT))
            {
                this._toolbar.extensionView.attachExtension(
                    ToolbarDisplayExtensionIds.GAMEHALL_LEADERBOARD_PROMPT,
                    this._window,
                    ExtensionFixedSlotsEnum._Str_8642);
            }
        }

        private function hide():void
        {
            if (this._toolbar != null && this._toolbar.extensionView != null)
            {
                this._toolbar.extensionView.detachExtension(ToolbarDisplayExtensionIds.GAMEHALL_LEADERBOARD_PROMPT);
            }
        }

        private function createWindow():void
        {
            var asset:XmlAsset = this._toolbar.assets.getAssetByName("gamehall_leaderboard_prompt_xml") as XmlAsset;
            if (asset == null)
            {
                return;
            }
            this._window = this._toolbar.windowManager.buildFromXML(asset.content as XML, 1) as IWindowContainer;
            if (this._window == null)
            {
                return;
            }
            this._window.procedure = this.onWindowEvent;

            var message:ITextWindow = this._window.findChildByName("prompt_message") as ITextWindow;
            if (message != null)
            {
                message.text = this._toolbar.localization.getLocalization(
                    "gamehall.leaderboard.prompt.message",
                    "This games room has a high score leaderboard!");
            }

            this._button = this._window.findChildByName("view_high_scores_button") as IButtonWindow;
            var buttonText:String = this._toolbar.localization.getLocalization(
                "gamehall.leaderboard.prompt.button",
                "View high scores");
            if (this._button != null)
            {
                this._button.caption = "";
                this._button.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
            this._buttonLabel = this._window.findChildByName("view_high_scores_label") as ITextWindow;
            if (this._buttonLabel != null)
            {
                this._buttonLabel.text = buttonText;
                this._buttonLabel.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
        }

        private function destroyWindow():void
        {
            if (this._buttonLabel != null)
            {
                this._buttonLabel.removeEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                this._buttonLabel = null;
            }
            if (this._button != null)
            {
                this._button.removeEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                this._button = null;
            }
            if (this._window != null)
            {
                this._window.procedure = null;
                this._window.dispose();
                this._window = null;
            }
        }

        private function onWindowEvent(event:WindowEvent, window:IWindow):void
        {
            if (event.type != WindowMouseEvent.CLICK || window == null)
            {
                return;
            }
            if (window.name == "view_high_scores_button" || window.name == "view_high_scores_label")
            {
                this.sendLeaderboardRequest();
            }
        }

        private function onButtonClicked(event:WindowMouseEvent):void
        {
            this.sendLeaderboardRequest();
        }

        private function sendLeaderboardRequest():void
        {
            if (this._toolbar != null && this._toolbar.connection != null)
            {
                var now:int = getTimer();
                if (now - this._lastRequestTime < 250)
                {
                    return;
                }
                this._lastRequestTime = now;
                this._toolbar.connection.send(new RequestGamehallLeaderboardMessageComposer(this._currentGameType));
            }
        }
    }
}
