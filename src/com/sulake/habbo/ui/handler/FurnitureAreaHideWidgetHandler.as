package com.sulake.habbo.ui.handler
{
    import com.sulake.habbo.room.events.RoomEngineAreaHideStateWidgetEvent;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.furniture.areahide.AreaHideFurniWidget;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.session.enum.RoomControllerLevel;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import flash.events.Event;

    public class FurnitureAreaHideWidgetHandler implements IRoomWidgetHandler
    {
        private var _disposed:Boolean;
        private var _widget:AreaHideFurniWidget;
        private var _container:IRoomWidgetHandlerContainer;

        public function get disposed():Boolean { return this._disposed; }

        public function dispose():void
        {
            if (!this._disposed)
            {
                this.container = null;
                this._disposed = true;
            }
        }

        public function get type():String { return RoomWidgetEnum.AREA_HIDE; }
        public function set widget(k:AreaHideFurniWidget):void { this._widget = k; }
        public function get container():IRoomWidgetHandlerContainer { return this._container; }
        public function set container(k:IRoomWidgetHandlerContainer):void { this._container = k; }
        public function getWidgetMessages():Array { return null; }
        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent { return null; }

        public function getProcessedEvents():Array
        {
            return [RoomEngineTriggerWidgetEvent.RETWE_REQUEST_AREA_HIDE, RoomEngineAreaHideStateWidgetEvent.UPDATE_STATE_AREA_HIDE];
        }

        public function processEvent(k:Event):void
        {
            var _local_2:RoomEngineObjectEvent;
            var _local_3:IRoomObject;
            var _local_4:IRoomObjectModel;
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_AREA_HIDE:
                    if (this.validateRights())
                    {
                        _local_2 = k as RoomEngineObjectEvent;
                        _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
                        if (_local_3 == null)
                        {
                            return;
                        }
                        _local_4 = _local_3.getModel();
                        this._widget.open(
                            _local_3.getId(),
                            Boolean(_local_3.getState(0)),
                            _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_ROOT_X),
                            _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_ROOT_Y),
                            _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_WIDTH),
                            _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_LENGTH),
                            _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_INVISIBILITY) == 1,
                            _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_WALLITEMS) == 1,
                            _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_INVERT) == 1);
                    }
                    return;
                case RoomEngineAreaHideStateWidgetEvent.UPDATE_STATE_AREA_HIDE:
                    var _local_5:RoomEngineAreaHideStateWidgetEvent = k as RoomEngineAreaHideStateWidgetEvent;
                    this._widget.updateStatus(_local_5.objectId, _local_5.isOn);
                    return;
            }
        }

        private function validateRights():Boolean
        {
            return this._container.roomSession.isRoomOwner ||
                this._container.roomSession.roomControllerLevel >= RoomControllerLevel.GUEST ||
                this._container.sessionDataManager.isAnyRoomController;
        }

        public function update():void
        {
        }
    }
}
