package com.sulake.habbo.inventory.wired_trading
{
    import __AS3__.vec.Vector;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade.WiredTradeAcceptMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade.WiredTradeCancelMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade.WiredTradeItemsMessageComposer;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.habbo.inventory.IInventoryModel;
    import com.sulake.habbo.inventory.enum.InventorySubCategory;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.habbo.inventory.trading.ITradingModel;
    import com.sulake.habbo.inventory.wired_trading.requirements.WiredTradeRequirementsModel;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.utils.getTimer;

    /**
     * July AIR single-user Wired Trading state machine.
     */
    public class WiredTradingModel implements IInventoryModel, ITradingModel
    {
        public static const FAILURE_NONE:int = 0;
        public static const STATE_READY:uint = 0;
        public static const STATE_ADDING_ITEMS:uint = 1;
        public static const STATE_COUNTDOWN:uint = 2;
        public static const STATE_CONFIRMING:uint = 3;
        public static const STATE_CONFIRMED:uint = 4;

        private var _inventory:HabboInventory;
        private var _communication:IHabboCommunicationManager;
        private var _localization:IHabboLocalizationManager;
        private var _view:WiredTradingView;
        private var _requirements:WiredTradeRequirementsModel;
        private var _running:Boolean;
        private var _disposed:Boolean;
        private var _state:uint;
        private var _ownItems:Map;
        private var _ownNumItems:int;
        private var _ownNumCredits:int;
        private var _wiredItems:Map;
        private var _wiredNumItems:int;
        private var _wiredNumCredits:int;
        private var _canAccept:Boolean;
        private var _extra:int;
        private var _timeoutSeconds:int;
        private var _tradeStartTime:int;

        public function WiredTradingModel(
            inventory:HabboInventory,
            windowManager:IHabboWindowManager,
            communication:IHabboCommunicationManager,
            assets:IAssetLibrary,
            roomEngine:IRoomEngine,
            localization:IHabboLocalizationManager,
            soundManager:IHabboSoundManager)
        {
            this._inventory = inventory;
            this._communication = communication;
            this._localization = localization;
            this._view = new WiredTradingView(
                this, windowManager, assets, roomEngine, localization, soundManager);
            this._requirements = new WiredTradeRequirementsModel(this);
            this.clear();
        }

        public function onWiredTradeInitiate(
            requirement:TradeRequirement,
            showRequirementsImmediate:Boolean,
            overridePreviousTrade:Boolean,
            timeoutSeconds:int):void
        {
            if (overridePreviousTrade)
            {
                this.close(false, false, false);
            }
            if (this._running)
            {
                this.close(false, false, false);
            }
            this._timeoutSeconds = timeoutSeconds;
            this._tradeStartTime = getTimer();
            this._requirements.setRequirements(requirement, showRequirementsImmediate);
            this.initializeNewTrade();
            this._view.startSecondsLeftTimer();
            this._inventory.toggleInventorySubPage(InventorySubCategory.WIRED_TRADING);
            this._inventory.furniModel.updateView();
            if (overridePreviousTrade)
            {
                this._requirements.highlightRefresh();
            }
        }

        private function initializeNewTrade():void
        {
            this._running = true;
            this.clear();
            this.state = STATE_ADDING_ITEMS;
            this._inventory.onWiredTradeActiveChanged();
            this._inventory.furniModel.updateView();
        }

        private function clear():void
        {
            this._ownItems = new Map();
            this._ownNumItems = 0;
            this._ownNumCredits = 0;
            this._wiredItems = new Map();
            this._wiredNumItems = 0;
            this._wiredNumCredits = 0;
            this._canAccept = false;
            this._extra = 0;
            if (this._view != null)
            {
                this._view.updateAllUI();
            }
        }

        public function requestAddItemsToTrading(
            itemIds:Vector.<int>,
            isWallItem:Boolean,
            type:int,
            category:int,
            groupable:Boolean,
            stuffData:IStuffData):void
        {
            if (this._state == STATE_ADDING_ITEMS && itemIds.length > 0)
            {
                this.send(new WiredTradeItemsMessageComposer(false, itemIds));
            }
        }

        public function requestRemoveItemFromTrading(index:int):void
        {
            if (this._state != STATE_ADDING_ITEMS || index < 0
                || index >= this._ownItems.length)
            {
                return;
            }
            var group:GroupItem = this._ownItems.getWithIndex(index) as GroupItem;
            var item:FurnitureItem = group == null ? null : group._Str_3205();
            if (item != null)
            {
                this.send(new WiredTradeItemsMessageComposer(
                    true, Vector.<int>([item.id])));
            }
        }

        public function requestAccept():Boolean
        {
            if (this._state != STATE_ADDING_ITEMS || !this._canAccept)
            {
                return false;
            }
            this.send(new WiredTradeAcceptMessageComposer(false));
            this.state = STATE_COUNTDOWN;
            return true;
        }

        public function confirmCountdownReady():void
        {
            if (this._state == STATE_COUNTDOWN)
            {
                this.state = STATE_CONFIRMING;
            }
        }

        public function requestConfirm():Boolean
        {
            if (this._state != STATE_CONFIRMING)
            {
                return false;
            }
            this.send(new WiredTradeAcceptMessageComposer(true));
            this.state = STATE_CONFIRMED;
            return true;
        }

        public function requestCancelTrading():void
        {
            this.send(new WiredTradeCancelMessageComposer());
        }

        public function updateItemGroupMaps(
            ownItems:Map,
            ownNumItems:int,
            ownNumCredits:int,
            wiredItems:Map,
            wiredNumItems:int,
            wiredNumCredits:int,
            canAccept:Boolean,
            extra:int):void
        {
            if (!this._running)
            {
                return;
            }
            this._ownItems = ownItems;
            this._ownNumItems = ownNumItems;
            this._ownNumCredits = ownNumCredits;
            this._wiredItems = wiredItems;
            this._wiredNumItems = wiredNumItems;
            this._wiredNumCredits = wiredNumCredits;
            this._canAccept = canAccept;
            this._extra = extra;
            this._view.updateAllUI();
            this._requirements.requirementsStateUpdated();
            this._inventory.furniModel._Str_17963();
        }

        public function tradeIsCancelled(reason:int):void
        {
            this.close(true, false);
            this._view.alertTradeCancelled(reason);
        }

        public function tradeIsCompleted():void
        {
            this.close(true, false);
        }

        public function close(
            hideView:Boolean,
            notifyServer:Boolean,
            refreshFurni:Boolean=true):void
        {
            if (!this._running)
            {
                return;
            }
            this._view.stopSecondsLeftTimer();
            this._view.stopConfirmCountdown();
            if (this._state != STATE_READY && notifyServer)
            {
                this.requestCancelTrading();
            }
            this._running = false;
            this.clear();
            this.state = STATE_READY;
            this._inventory.onWiredTradeActiveChanged();
            if (hideView)
            {
                this._inventory.toggleInventorySubPage(InventorySubCategory.EMPTY);
            }
            if (refreshFurni)
            {
                this._inventory.furniModel.updateView();
                this._inventory.furniModel._Str_17963();
            }
        }

        private function send(composer:IMessageComposer):void
        {
            if (this._communication != null && this._communication.connection != null)
            {
                this._communication.connection.send(composer);
            }
        }

        public function getOwnItemIdsInTrade():Array
        {
            var ids:Array = [];
            if (this._ownItems == null || this._ownItems.disposed)
            {
                return ids;
            }
            for (var i:int = 0; i < this._ownItems.length; i++)
            {
                var group:GroupItem = this._ownItems.getWithIndex(i) as GroupItem;
                if (group == null)
                {
                    continue;
                }
                for (var j:int = 0; j < group.getTotalCount(); j++)
                {
                    var item:FurnitureItem = group._Str_5087(j);
                    if (item != null)
                    {
                        ids.push(item.ref);
                    }
                }
            }
            return ids;
        }

        public function getWindowContainer():IWindowContainer
        {
            return this._view.getWindowContainer();
        }

        public function onInventoryOpen():void
        {
        }

        public function initCategory(category:String):void
        {
        }

        public function onCategorySwitch(category:String):void
        {
            if (this._running && category != InventorySubCategory.WIRED_TRADING
                && this._state != STATE_READY)
            {
                this.close(false, true);
            }
        }

        public function onInventoryClose():void
        {
            if (this._running)
            {
                this.close(false, true);
            }
        }

        public function updateView():void
        {
        }

        public function onSubcategorySwitch(category:String):void
        {
            this.onCategorySwitch(category);
        }

        public function getInventory():HabboInventory
        {
            return this._inventory;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            if (this._running)
            {
                this.close(false, false, false);
            }
            this._requirements.dispose();
            this._requirements = null;
            this._view.dispose();
            this._view = null;
            this._inventory = null;
            this._communication = null;
            this._localization = null;
            this._disposed = true;
        }

        public function get disposed():Boolean { return this._disposed; }
        public function get inventory():HabboInventory { return this._inventory; }
        public function get running():Boolean { return this._running; }
        public function get state():uint { return this._state; }
        public function set state(value:uint):void
        {
            this._state = value;
            if (this._view != null)
            {
                this._view.tradeStateUpdated();
            }
        }
        public function get ownItems():Map { return this._ownItems; }
        public function get ownNumItems():int { return this._ownNumItems; }
        public function get ownNumCredits():int { return this._ownNumCredits; }
        public function get wiredItems():Map { return this._wiredItems; }
        public function get wiredNumItems():int { return this._wiredNumItems; }
        public function get wiredNumCredits():int { return this._wiredNumCredits; }
        public function get canAccept():Boolean { return this._canAccept; }
        public function get extra():int { return this._extra; }
        public function get localization():IHabboLocalizationManager
        {
            return this._localization;
        }
        public function get requirementsModel():WiredTradeRequirementsModel
        {
            return this._requirements;
        }
        public function get tradingView():WiredTradingView
        {
            return this._view;
        }
        public function isPayment():Boolean
        {
            return this._requirements.requirement == null
                || this._requirements.requirement.isPaymentOnly();
        }
        public function get paymentLayoutType():String
        {
            return this._requirements.requirement == null
                ? null : this._requirements.requirement.layoutType;
        }
        public function get tradeTypeLocalization():String
        {
            return this._localization.getLocalization(
                this.isPayment()
                    ? "inventory.wired_trading.payment"
                    : "inventory.wired_trading.trade");
        }
        public function get secondsLeft():int
        {
            if (this._timeoutSeconds <= 0 || this._tradeStartTime <= 0)
            {
                return -1;
            }
            var elapsed:int = (getTimer() - this._tradeStartTime) / 1000;
            return Math.max(0, this._timeoutSeconds - elapsed);
        }
    }
}
