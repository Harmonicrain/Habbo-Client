package com.sulake.habbo.ui.widget.furniture.gamehall.leaderboard
{
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.communication.messages.parser.games.OpenGamehallLeaderboardMessageParser;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.handler.GamehallLeaderboardWidgetHandler;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.window.IHabboWindowManager;

    public class GamehallLeaderboardWidget extends RoomWidgetBase
    {
        private var _view:GamehallLeaderboardView;

        public function GamehallLeaderboardWidget(handler:IRoomWidgetHandler, windowManager:IHabboWindowManager, assets:IAssetLibrary=null, localizations:IHabboLocalizationManager=null)
        {
            super(handler, windowManager, assets, localizations);
            if (handler is GamehallLeaderboardWidgetHandler)
            {
                GamehallLeaderboardWidgetHandler(handler).widget = this;
            }
        }

        override public function get mainWindow():IWindow
        {
            return this._view == null ? null : this._view.window;
        }

        public function openLeaderboard(data:OpenGamehallLeaderboardMessageParser=null):void
        {
            if (this._view == null)
            {
                this._view = new GamehallLeaderboardView(this.windowManager, this.localizations, this.assets, this.requestLeaderboard, this.showProfile, this.avatarRenderManager);
            }
            this._view.show(data);
        }

        private function requestLeaderboard(gameType:String, period:String, offset:int, limit:int):void
        {
            if (this._handler is GamehallLeaderboardWidgetHandler)
            {
                GamehallLeaderboardWidgetHandler(this._handler).requestLeaderboard(gameType, period, offset, limit);
            }
        }

        private function showProfile(userId:int):void
        {
            if (this._handler is GamehallLeaderboardWidgetHandler)
            {
                GamehallLeaderboardWidgetHandler(this._handler).showExtendedProfile(userId);
            }
        }

        private function get avatarRenderManager():IAvatarRenderManager
        {
            return this._handler is GamehallLeaderboardWidgetHandler
                ? GamehallLeaderboardWidgetHandler(this._handler).avatarRenderManager
                : null;
        }

        override public function dispose():void
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            super.dispose();
        }
    }
}
