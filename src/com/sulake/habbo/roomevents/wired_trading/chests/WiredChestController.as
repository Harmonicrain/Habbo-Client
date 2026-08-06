package com.sulake.habbo.roomevents.wired_trading.chests
{
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestOpenInstructionMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.CloseChestMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.OpenChestMessageComposer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.CoinChestSubController;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.FurniChestSubController;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.IChestSubController;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.room.object.IRoomObject;
    import __AS3__.vec.Vector;

    /**
     * July AIR chest coordinator. It owns one active/requested chest and drops
     * stale fragments, room-object updates and close acknowledgements.
     */
    public class WiredChestController implements IDisposable
    {
        public static const STATUS_CLOSED:int = 0;
        public static const STATUS_OPENING:int = 1;
        public static const STATUS_OPEN:int = 2;

        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _disposed:Boolean;
        private var _status:int = STATUS_CLOSED;
        private var _wrapper:WiredChestWrapperView;
        private var _subControllers:Vector.<IChestSubController>;
        private var _requestedChestId:int;
        private var _activeChestId:int;
        private var _messageEvents:Vector.<IMessageEvent>;

        public function WiredChestController(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._messageEvents = new Vector.<IMessageEvent>();
            this.addMessageEvent(new ChestOpenInstructionMessageEvent(this.onOpenInstruction));
            this._wrapper = new WiredChestWrapperView(this, roomEvents.windowManager);
            this._subControllers = new Vector.<IChestSubController>();
            this._subControllers.push(new FurniChestSubController(this));
            this._subControllers.push(new CoinChestSubController(this));
            roomEvents.roomEngine.events.addEventListener(RoomEngineObjectEvent.REMOVED,
                this.onRoomObjectRemoved);
            roomEvents.roomEngine.events.addEventListener(RoomEngineObjectEvent.CONTENT_UPDATED,
                this.onRoomObjectUpdated);
        }

        private function onOpenInstruction(event:ChestOpenInstructionMessageEvent):void
        {
            this.open(event.getParser().chestId);
        }
        public function open(chestId:int):void
        {
            if (chestId <= 0 || !this._roomEvents.isWiredFeatureEnabled(
                WiredCapabilityCodes.CHESTS))
            {
                return;
            }
            if (this._activeChestId != 0 && this._activeChestId != chestId)
            {
                this.setClosedStatus();
            }
            this._requestedChestId = chestId;
            this.send(new OpenChestMessageComposer(chestId));
        }
        public function close():void
        {
            if (this._wrapper != null) { this._wrapper.hide(); }
            else { this.setClosedStatus(); }
        }
        public function setClosedStatus():void
        {
            if (this._activeChestId != 0)
            {
                this.send(new CloseChestMessageComposer(this._activeChestId));
            }
            this._requestedChestId = 0;
            this._activeChestId = 0;
            this._status = STATUS_CLOSED;
        }
        public function setOpeningStatus(chestId:int):void
        {
            this._requestedChestId = 0;
            this._activeChestId = chestId;
            this._status = STATUS_OPENING;
        }
        public function setOpenStatus(chestId:int, subController:IChestSubController):void
        {
            this._requestedChestId = 0;
            this._activeChestId = chestId;
            this._status = STATUS_OPEN;
            var object:IRoomObject = this._roomEvents.roomEngine.getRoomObject(
                this._roomEvents.roomEngine.activeRoomId, chestId,
                RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            if (object == null || object.getModel() == null)
            {
                this._wrapper.hide();
                return;
            }
            var owner:Boolean = object.getModel().getNumber("furniture_owner_id")
                == this._roomEvents.sessionDataManager.userId;
            var roomOwner:Boolean = this._roomEvents.roomSession != null
                && this._roomEvents.roomSession.isRoomOwner;
            this._wrapper.show(subController, object, chestId, owner, roomOwner);
        }
        private function onRoomObjectRemoved(event:RoomEngineObjectEvent):void
        {
            if (event.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE
                && event.objectId == this._activeChestId && this._status == STATUS_OPEN)
            {
                this._wrapper.hide();
            }
        }
        private function onRoomObjectUpdated(event:RoomEngineObjectEvent):void
        {
            if (event.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE
                && event.objectId == this._activeChestId && this._status == STATUS_OPEN)
            {
                this._wrapper.viewingChestUpdated();
            }
        }
        public function onPermissionsChanged():void
        {
            if (this._wrapper != null) { this._wrapper.onPermissionsChanged(); }
        }
        public function resetRoom():void
        {
            if (this._wrapper != null) { this._wrapper.hide(); }
            else { this.setClosedStatus(); }
        }
        public function addMessageEvent(event:IMessageEvent):void
        {
            if (event == null || this._roomEvents.communication == null) { return; }
            this._messageEvents.push(event);
            this._roomEvents.communication.addHabboConnectionMessageEvent(event);
        }
        public function removeMessageEvent(event:IMessageEvent):void
        {
            if (event == null || this._roomEvents.communication == null) { return; }
            this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
            var index:int = this._messageEvents.indexOf(event);
            if (index >= 0) { this._messageEvents.removeAt(index); }
        }
        public function send(composer:IMessageComposer):void { this._roomEvents.send(composer); }
        public function get status():int { return this._status; }
        public function get chestWrapperView():WiredChestWrapperView { return this._wrapper; }
        public function get activeChestId():int { return this._activeChestId; }
        public function get requestedChestId():int { return this._requestedChestId; }
        public function get roomEvents():HabboUserDefinedRoomEvents { return this._roomEvents; }
        public function get localization():IHabboLocalizationManager { return this._roomEvents.localization; }
        public function get sessionDataManager():ISessionDataManager
        {
            return this._roomEvents.sessionDataManager;
        }
        public function get catalog():IHabboCatalog { return this._roomEvents.catalog; }
        public function get roomEngine():IRoomEngine { return this._roomEvents.roomEngine; }
        public function get windowManager():IHabboWindowManager
        {
            return this._roomEvents.windowManager;
        }
        public function get assets():IAssetLibrary { return this._roomEvents.assets; }
        public function getProperty(key:String, fallback:String = ""):String
        {
            var value:String = this._roomEvents.getProperty(key);
            return value == null ? fallback : value;
        }
        public function getInteger(key:String, fallback:int = 0):int
        {
            var value:String = this.getProperty(key, String(fallback));
            var parsed:Number = parseInt(value);
            return isNaN(parsed) ? fallback : int(parsed);
        }
        public function dispose():void
        {
            if (this._disposed) { return; }
            this._roomEvents.roomEngine.events.removeEventListener(RoomEngineObjectEvent.REMOVED,
                this.onRoomObjectRemoved);
            this._roomEvents.roomEngine.events.removeEventListener(RoomEngineObjectEvent.CONTENT_UPDATED,
                this.onRoomObjectUpdated);
            // The wrapper still owns the active sub-controller view. Detach it
            // before disposing the sub-controllers so hide() cannot call into an
            // already-disposed view during component shutdown.
            if (this._wrapper != null) { this._wrapper.hide(); }
            for each (var sub:IChestSubController in this._subControllers) { sub.dispose(); }
            this._subControllers = null;
            while (this._messageEvents.length > 0)
            {
                var event:IMessageEvent = this._messageEvents.pop();
                this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
                event.dispose();
            }
            this._messageEvents = null;
            if (this._wrapper != null) { this._wrapper.dispose(); }
            this._wrapper = null;
            this._roomEvents = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
