package com.sulake.habbo.roomevents.wired_trading.contracts
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts.ChestContractOpenMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts.ChestContractUpdateResultMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.contracts.RequestChestContractContentsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.contracts.SaveChestContractMessageComposer;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractUpdateResultMessageParser;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_trading.UbuntuPresetManager;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.AddEditContractElement;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.IContractView;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.PaymentContract;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.RewardContract;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.TradeContract;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.util.AbstractContract;

    public class WiredContractController implements IDisposable
    {
        private static const UNSET_LOCATION:int = int.MAX_VALUE;

        private var _disposed:Boolean;
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _presetManager:PresetManager;
        private var _messageEvents:Vector.<IMessageEvent>;
        private var _pendingContractId:int = -1;
        private var _addEdit:AddEditContractElement;
        private var _payment:PaymentContract;
        private var _reward:RewardContract;
        private var _trade:TradeContract;
        private var _xCache:int = UNSET_LOCATION;
        private var _yCache:int = UNSET_LOCATION;

        public function WiredContractController(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._presetManager = new UbuntuPresetManager(roomEvents);
            this._messageEvents = new Vector.<IMessageEvent>();
            this._messageEvents.push(new ChestContractOpenMessageEvent(
                this.onOpenContract));
            this._messageEvents.push(new ChestContractContentsMessageEvent(
                this.onContractContents));
            this._messageEvents.push(new ChestContractUpdateResultMessageEvent(
                this.onContractUpdateResult));
            for each (var event:IMessageEvent in this._messageEvents)
                this.addMessageEvent(event);
        }

        private function onOpenContract(event:ChestContractOpenMessageEvent):void
        {
            this._pendingContractId = event.getParser().contractId;
            this.communicationManager.connection.send(
                new RequestChestContractContentsMessageComposer(
                    this._pendingContractId));
        }

        private function onContractContents(
            event:ChestContractContentsMessageEvent):void
        {
            var contents:ChestContractContentsMessageParser = event.getParser();
            if (contents.contractId != this._pendingContractId) return;
            this._pendingContractId = -1;
            this.closeAllOpenFrames();
            var view:IContractView;
            if (contents.contractType == 0)
            {
                if (this._payment == null)
                    this._payment = new PaymentContract(this, this._presetManager);
                this._payment.show(contents);
                view = this._payment;
            }
            else if (contents.contractType == 1)
            {
                if (this._trade == null)
                    this._trade = new TradeContract(this, this._presetManager);
                this._trade.show(contents);
                view = this._trade;
            }
            else if (contents.contractType == 2)
            {
                if (this._reward == null)
                    this._reward = new RewardContract(this, this._presetManager);
                this._reward.show(contents);
                view = this._reward;
            }
            if (view != null && this._xCache != UNSET_LOCATION &&
                this._yCache != UNSET_LOCATION)
            {
                view.window.x = this._xCache;
                view.window.y = this._yCache;
            }
        }

        public function saveContract(contract:AbstractContract):void
        {
            var validationError:String = contract.validate();
            if (validationError != null)
            {
                this._roomEvents.windowManager.alert(
                    "${wiredfurni.error.title}", validationError, 0, null);
                return;
            }
            var data:Array = [];
            contract.addContentsToComposer(data);
            this.communicationManager.connection.send(
                new SaveChestContractMessageComposer(data));
        }

        private function onContractUpdateResult(
            event:ChestContractUpdateResultMessageEvent):void
        {
            var result:ChestContractUpdateResultMessageParser = event.getParser();
            if (result.isSuccess)
            {
                this.closeAllOpenFrames();
                return;
            }
            var key:String = "wiredcontracts.error." + result.failCode;
            var message:String =
                this._roomEvents.localization.getLocalizationWithParams(key, key);
            this._roomEvents.windowManager.alert(
                "${wiredfurni.error.title}", message, 0, null);
        }

        public function clear():void
        {
            this._pendingContractId = -1;
            this.closeAllOpenFrames();
            this._xCache = UNSET_LOCATION;
            this._yCache = UNSET_LOCATION;
            if (this._addEdit != null) this._addEdit.forgetLocation();
        }

        public function closeAllOpenFrames():void
        {
            if (this._addEdit != null) this._addEdit.hide();
            if (this._payment != null && this._payment.isShowing())
                this._payment.hide();
            else if (this._reward != null && this._reward.isShowing())
                this._reward.hide();
            else if (this._trade != null && this._trade.isShowing())
                this._trade.hide();
        }

        public function cacheWindowLocation(window:IWindow):void
        {
            this._xCache = window.x;
            this._yCache = window.y;
        }

        public function get addEditContractElement():AddEditContractElement
        {
            if (this._addEdit == null)
                this._addEdit = new AddEditContractElement(
                    this, this._presetManager);
            return this._addEdit;
        }

        public function get communicationManager():IHabboCommunicationManager
        {
            return this._roomEvents.communication;
        }
        public function addMessageEvent(event:IMessageEvent):void
        {
            if (this.communicationManager != null)
                this.communicationManager.addHabboConnectionMessageEvent(event);
        }
        public function removeMessageEvent(event:IMessageEvent):void
        {
            if (this.communicationManager != null)
                this.communicationManager.removeHabboConnectionMessageEvent(event);
        }
        public function get roomEvents():HabboUserDefinedRoomEvents
        {
            return this._roomEvents;
        }

        public function dispose():void
        {
            if (this._disposed) return;
            if (this._addEdit != null) this._addEdit.dispose();
            if (this._trade != null) this._trade.dispose();
            if (this._reward != null) this._reward.dispose();
            if (this._payment != null) this._payment.dispose();
            this._addEdit = null;
            this._trade = null;
            this._reward = null;
            this._payment = null;
            for each (var event:IMessageEvent in this._messageEvents)
                this.removeMessageEvent(event);
            this._messageEvents = null;
            this._presetManager = null;
            this._roomEvents = null;
            this._disposed = true;
        }

        public function get disposed():Boolean { return this._disposed; }
    }
}
