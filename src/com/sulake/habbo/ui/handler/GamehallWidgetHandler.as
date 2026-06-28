package com.sulake.habbo.ui.handler
{
    import com.sulake.habbo.room.events.RoomEngineGamehallEvent;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.furniture.gamehall.GamehallGameWidget;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import flash.events.Event;

    public class GamehallWidgetHandler implements IRoomWidgetHandler
    {
        private var _disposed:Boolean = false;
        private var _container:IRoomWidgetHandlerContainer;
        private var _widget:GamehallGameWidget;

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        public function get type():String
        {
            return RoomWidgetEnum.GAMEHALL_BOARD;
        }

        public function set container(value:IRoomWidgetHandlerContainer):void
        {
            this._container = value;
        }

        public function get container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public function set widget(value:GamehallGameWidget):void
        {
            this._widget = value;
        }

        public function getProcessedEvents():Array
        {
            return [
                RoomEngineGamehallEvent.OPEN,
                RoomEngineGamehallEvent.UPDATE,
                RoomEngineGamehallEvent.CLOSE
            ];
        }

        public function processEvent(event:Event):void
        {
            if (this._disposed || this._widget == null)
            {
                return;
            }

            var gameEvent:RoomEngineGamehallEvent = event as RoomEngineGamehallEvent;
            if (gameEvent == null)
            {
                return;
            }

            switch (gameEvent.type)
            {
                case RoomEngineGamehallEvent.OPEN:
                    this._widget.open(
                        gameEvent.stationId,
                        gameEvent.gameType,
                        gameEvent.localSeat,
                        gameEvent.seatCount,
                        gameEvent.verb,
                        gameEvent.args,
                        gameEvent.reason);
                    break;
                case RoomEngineGamehallEvent.UPDATE:
                    this._widget.applyUpdate(gameEvent.stationId, gameEvent.verb, gameEvent.args, gameEvent.reason);
                    break;
                case RoomEngineGamehallEvent.CLOSE:
                    this._widget.close(gameEvent.stationId, gameEvent.reason);
                    break;
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
