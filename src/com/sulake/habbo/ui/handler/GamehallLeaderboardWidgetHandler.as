package com.sulake.habbo.ui.handler
{
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.communication.messages.parser.games.OpenGamehallLeaderboardMessageParser;
    import com.sulake.habbo.communication.messages.outgoing.games.RequestGamehallLeaderboardMessageComposer;
    import com.sulake.habbo.room.events.RoomEngineGamehallEvent;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.furniture.gamehall.leaderboard.GamehallLeaderboardWidget;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import flash.events.Event;

    public class GamehallLeaderboardWidgetHandler implements IRoomWidgetHandler
    {
        private var _disposed:Boolean = false;
        private var _container:IRoomWidgetHandlerContainer;
        private var _widget:GamehallLeaderboardWidget;

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        public function get type():String
        {
            return RoomWidgetEnum.GAMEHALL_LEADERBOARD;
        }

        public function set container(value:IRoomWidgetHandlerContainer):void
        {
            this._container = value;
        }

        public function get container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public function set widget(value:GamehallLeaderboardWidget):void
        {
            this._widget = value;
        }

        public function getProcessedEvents():Array
        {
            return [RoomEngineGamehallEvent.LEADERBOARD_OPEN];
        }

        public function processEvent(event:Event):void
        {
            if (this._disposed || this._widget == null)
            {
                return;
            }
            if (event.type == RoomEngineGamehallEvent.LEADERBOARD_OPEN)
            {
                var gamehallEvent:RoomEngineGamehallEvent = event as RoomEngineGamehallEvent;
                var parser:OpenGamehallLeaderboardMessageParser = gamehallEvent != null && gamehallEvent.args.length > 0
                    ? gamehallEvent.args[0] as OpenGamehallLeaderboardMessageParser
                    : null;
                this._widget.openLeaderboard(parser);
            }
        }

        public function getWidgetMessages():Array
        {
            return [];
        }

        public function processWidgetMessage(message:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function requestLeaderboard(gameType:String, period:String, offset:int, limit:int):void
        {
            if (this._disposed || this._container == null || this._container.connection == null)
            {
                return;
            }
            this._container.connection.send(new RequestGamehallLeaderboardMessageComposer(gameType, period, offset, limit));
        }

        public function get avatarRenderManager():IAvatarRenderManager
        {
            return this._container == null ? null : this._container.avatarRenderManager;
        }

        public function showExtendedProfile(userId:int):void
        {
            if (this._disposed || this._container == null || this._container.habboGroupsManager == null || userId <= 0)
            {
                return;
            }
            this._container.habboGroupsManager.showExtendedProfile(userId);
        }

        public function update():void
        {
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this._widget = null;
            this._container = null;
            this._disposed = true;
        }
    }
}
