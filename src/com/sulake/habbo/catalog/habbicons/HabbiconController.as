package com.sulake.habbo.catalog.habbicons
{
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.catalog.PurchaseErrorMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.PurchaseNotAllowedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.PurchaseOKMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.HabbiconInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.HabbiconShopDataMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.HabbiconStatusChangedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.OwnedHabbiconsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.RoomUserHabbiconMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.BuyHabbiconCollectionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.BuyHabbiconMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.ClaimHabbiconRewardMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.FavouriteHabbiconMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.RequestHabbiconInfoMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.RequestHabbiconShopDataMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.SendHabbiconInstantMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.UnfavouriteHabbiconMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.UseHabbiconInRoomMessageComposer;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconInfoMessageParser;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconShopDataMessageParser;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconStatusChangedMessageParser;
    import com.sulake.habbo.communication.messages.parser.habbicons.OwnedHabbiconsMessageParser;
    import com.sulake.habbo.communication.messages.parser.habbicons.RoomUserHabbiconMessageParser;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboInventory;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDRoomEngine;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    public class HabbiconController extends Component implements IHabbiconController, ILinkEventTracker
    {
        private static const RECENT_HABBICON_LIMIT:int = 10;
        private static const UNSEEN_CATEGORY_HABBICONS:int = 8;

        public static var instance:HabbiconController;

        private var _communication:IHabboCommunicationManager;
        private var _windowManager:IHabboWindowManager;
        private var _localization:IHabboLocalizationManager;
        private var _inventory:IHabboInventory;
        private var _roomEngine:IRoomEngine;
        private var _roomSessionManager:IRoomSessionManager;
        private var _messageEvents:Vector.<IMessageEvent>;
        private var _events:EventDispatcher;
        private var _owned:Dictionary;
        private var _recent:Array;
        private var _collectionsById:Dictionary;
        private var _shopItems:Dictionary;
        private var _shopCollections:Vector.<HabbiconCollectionData>;
        private var _view:HabbiconView;
        private var _hasLoadedOwned:Boolean;
        private var _hasLoadedShop:Boolean;
        private var _shopRequestPending:Boolean;
        private var _pendingPurchaseRefresh:Boolean;
        private var _assetsStarted:Boolean;

        public function HabbiconController(context:IContext, flags:uint = 0, assets:IAssetLibrary = null)
        {
            super(context, flags, assets);
            instance = this;
        }

        override protected function get dependencies():Vector.<ComponentDependency>
        {
            return super.dependencies.concat(new <ComponentDependency>[
                new ComponentDependency(new IIDHabboCommunicationManager(), function(manager:IHabboCommunicationManager):void
                {
                    _communication = manager;
                }, true),
                new ComponentDependency(new IIDHabboWindowManager(), function(manager:IHabboWindowManager):void
                {
                    _windowManager = manager;
                }, true),
                new ComponentDependency(new IIDHabboLocalizationManager(), function(manager:IHabboLocalizationManager):void
                {
                    _localization = manager;
                }, false),
                new ComponentDependency(new IIDHabboInventory(), function(inventory:IHabboInventory):void
                {
                    _inventory = inventory;
                }, false),
                new ComponentDependency(new IIDRoomEngine(), function(engine:IRoomEngine):void
                {
                    _roomEngine = engine;
                }, false),
                new ComponentDependency(new IIDHabboRoomSessionManager(), function(manager:IRoomSessionManager):void
                {
                    _roomSessionManager = manager;
                }, false)
            ]);
        }

        override protected function initComponent():void
        {
            this._messageEvents = new Vector.<IMessageEvent>(0);
            this._events = new EventDispatcher();
            this._owned = new Dictionary();
            this._recent = [];
            this._collectionsById = new Dictionary();
            this._shopItems = new Dictionary();
            this._shopCollections = new Vector.<HabbiconCollectionData>(0);
            context.addLinkEventTracker(this);
            this.addMessageEvent(new OwnedHabbiconsMessageEvent(this.onOwnedHabbicons));
            this.addMessageEvent(new HabbiconStatusChangedMessageEvent(this.onHabbiconStatusChanged));
            this.addMessageEvent(new HabbiconShopDataMessageEvent(this.onHabbiconShopData));
            this.addMessageEvent(new HabbiconInfoMessageEvent(this.onHabbiconInfo));
            this.addMessageEvent(new RoomUserHabbiconMessageEvent(this.onRoomUserHabbicon));
            this.addMessageEvent(new PurchaseOKMessageEvent(this.onPurchaseOk));
            this.addMessageEvent(new PurchaseErrorMessageEvent(this.onPurchaseFailed));
            this.addMessageEvent(new PurchaseNotAllowedMessageEvent(this.onPurchaseFailed));
            this.ensureAssetManagerStarted();
        }

        public function get linkPattern():String
        {
            return "habbicons/";
        }

        public function linkReceived(link:String):void
        {
            var parts:Array;
            if (!this.habbiconsEnabled())
            {
                return;
            }
            parts = link.split("/");
            if (parts.length >= 2 && parts[1] == "open")
            {
                this.openHabbiconHub();
            }
        }

        public function get windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public function get localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public function get hasLoadedShopData():Boolean
        {
            return this._hasLoadedShop;
        }

        public function get ownedHabbicons():Array
        {
            var result:Array = [];
            for each (var item:HabbiconOwnedItem in this._owned)
            {
                result.push(item);
            }
            return result;
        }

        public function get recentHabbiconIds():Array
        {
            return this._recent.concat();
        }

        public function get shopCollections():Vector.<HabbiconCollectionData>
        {
            return this._shopCollections.concat();
        }

        public function get unseenHabbiconCount():int
        {
            if (this._inventory == null || this._inventory.unseenItemTracker == null)
            {
                return 0;
            }
            return this._inventory.unseenItemTracker._Str_5621(UNSEEN_CATEGORY_HABBICONS);
        }

        public function addEventListener(type:String, listener:Function):void
        {
            this._events.addEventListener(type, listener);
        }

        public function removeEventListener(type:String, listener:Function):void
        {
            this._events.removeEventListener(type, listener);
        }

        public function openHabbiconHub():void
        {
            if (!this.habbiconsEnabled() || this._windowManager == null)
            {
                return;
            }
            this.ensureAssetManagerStarted();
            this.resetUnseenHabbicons();
            if (this._view == null || this._view.disposed)
            {
                this._view = new HabbiconView(this);
            }
            this._view.show();
            this.getShopData(false);
        }

        public function getShopData(force:Boolean = false):void
        {
            if (!this.habbiconsEnabled())
            {
                return;
            }
            this.ensureAssetManagerStarted();
            if (this._hasLoadedShop && !force)
            {
                this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED));
                return;
            }
            if (this._shopRequestPending)
            {
                return;
            }
            this._shopRequestPending = this.send(new RequestHabbiconShopDataMessageComposer());
        }

        public function getHabbiconInfo(habbiconId:int):void
        {
            if (habbiconId > 0)
            {
                this.send(new RequestHabbiconInfoMessageComposer(habbiconId));
            }
        }

        public function noteHabbiconUsed(habbiconId:int):void
        {
            if (!this.habbiconsEnabled() || habbiconId <= 0)
            {
                return;
            }
            this.addRecentHabbiconId(habbiconId);
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.RECENT_HABBICONS_UPDATED, habbiconId));
        }

        public function isUnseenHabbicon(habbiconId:int):Boolean
        {
            return this._inventory != null && this._inventory.unseenItemTracker != null && this._inventory.unseenItemTracker.isUnseen(UNSEEN_CATEGORY_HABBICONS, habbiconId);
        }

        public function removeUnseenHabbicon(habbiconId:int):void
        {
            if (this._inventory == null || this._inventory.unseenItemTracker == null)
            {
                return;
            }
            this._inventory.unseenItemTracker._Str_16745(UNSEEN_CATEGORY_HABBICONS, habbiconId);
            this._inventory.unseenItemTracker._Str_17159(UNSEEN_CATEGORY_HABBICONS);
        }

        public function resetUnseenHabbicons():void
        {
            if (this._inventory != null && this._inventory.unseenItemTracker != null)
            {
                this._inventory.unseenItemTracker._Str_8813(UNSEEN_CATEGORY_HABBICONS);
            }
        }

        public function buyHabbicon(habbiconId:int):void
        {
            this._pendingPurchaseRefresh = true;
            this.send(new BuyHabbiconMessageComposer(habbiconId));
        }

        public function buyHabbiconCollection(collectionId:int):void
        {
            this._pendingPurchaseRefresh = true;
            this.send(new BuyHabbiconCollectionMessageComposer(collectionId));
        }

        public function claimHabbicon(habbiconId:int):void
        {
            this._pendingPurchaseRefresh = true;
            this.send(new ClaimHabbiconRewardMessageComposer(habbiconId));
        }

        public function favoriteHabbicon(habbiconId:int):void
        {
            this.send(new FavouriteHabbiconMessageComposer(habbiconId));
        }

        public function unfavoriteHabbicon(habbiconId:int):void
        {
            this.send(new UnfavouriteHabbiconMessageComposer(habbiconId));
        }

        public function useHabbiconInRoom(habbiconId:int):void
        {
            if (habbiconId <= 0)
            {
                return;
            }
            this.removeUnseenHabbicon(habbiconId);
            this.noteHabbiconUsed(habbiconId);
            this.send(new UseHabbiconInRoomMessageComposer(habbiconId));
        }

        public function sendHabbiconInstantMessage(chatId:int, habbiconId:int, confirmationId:int):void
        {
            if (chatId == 0 || habbiconId <= 0)
            {
                return;
            }
            this.removeUnseenHabbicon(habbiconId);
            this.noteHabbiconUsed(habbiconId);
            this.send(new SendHabbiconInstantMessageComposer(chatId, habbiconId, confirmationId));
        }

        public function tryGetOwnedHabbicon(habbiconId:int):HabbiconOwnedItem
        {
            return this._owned[habbiconId] as HabbiconOwnedItem;
        }

        public function tryGetShopItem(habbiconId:int):HabbiconShopItem
        {
            return this._shopItems[habbiconId] as HabbiconShopItem;
        }

        public function localize(key:String, fallback:String = ""):String
        {
            if (this._localization == null)
            {
                return fallback;
            }
            return this._localization.getLocalization(key, fallback);
        }

        public function resolveHabbiconDisplayName(habbiconId:int, fallback:String = null):String
        {
            var nameKey:String = HabbiconAssetManager.getHabbiconNameKey(habbiconId);
            if (nameKey != null && nameKey.length > 0)
            {
                return this.localize("habbicon_" + nameKey.toLowerCase() + "_name", fallback != null ? fallback : nameKey);
            }
            return fallback != null && fallback.length > 0 ? fallback : this.localize("habbicon.generic.name", "Habbicon");
        }

        public function createHabbiconBitmap(habbiconId:int, small:Boolean = false):BitmapData
        {
            var bitmap:BitmapData = HabbiconAssetManager.getPreviewBitmap(habbiconId, small);
            return bitmap != null ? bitmap.clone() : null;
        }

        private function addMessageEvent(event:IMessageEvent):void
        {
            if (this._communication == null)
            {
                return;
            }
            this._messageEvents.push(this._communication.addHabboConnectionMessageEvent(event));
        }

        private function send(composer:IMessageComposer):Boolean
        {
            var connection:IConnection = this._communication != null ? this._communication.connection : null;
            if (connection == null)
            {
                return false;
            }
            connection.send(composer);
            return true;
        }

        private function ensureAssetManagerStarted():void
        {
            if (this._assetsStarted || !this.habbiconsEnabled())
            {
                return;
            }
            HabbiconAssetManager.configure(this);
            HabbiconAssetManager.addEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
            HabbiconAssetManager.preload();
            this._assetsStarted = true;
        }

        private function onOwnedHabbicons(event:OwnedHabbiconsMessageEvent):void
        {
            var parser:OwnedHabbiconsMessageParser = event.getParser();
            var oldOwned:Dictionary = this._owned;
            var wasLoaded:Boolean = this._hasLoadedOwned;
            var owned:HabbiconOwnedItem;
            this._owned = new Dictionary();
            for each (owned in parser.habbicons)
            {
                this._owned[owned.habbiconId] = owned;
                if (wasLoaded && HabbiconState.isOwnedState(owned.habbiconState) && oldOwned[owned.habbiconId] == null)
                {
                    this.handleNewOwnedHabbicon(owned.habbiconId);
                }
            }
            this.setRecentHabbiconIds(parser.recentHabbiconIds);
            this._hasLoadedOwned = true;
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED));
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED));
        }

        private function onHabbiconStatusChanged(event:HabbiconStatusChangedMessageEvent):void
        {
            var parser:HabbiconStatusChangedMessageParser = event.getParser();
            var item:HabbiconOwnedItem = this._owned[parser.habbiconId] as HabbiconOwnedItem;
            var oldState:int = item != null ? item.habbiconState : 0;
            if (HabbiconState.isOwnedState(parser.habbiconState))
            {
                if (item == null)
                {
                    item = new HabbiconOwnedItem();
                    item.habbiconId = parser.habbiconId;
                    this._owned[parser.habbiconId] = item;
                    this.handleNewOwnedHabbicon(parser.habbiconId);
                }
                item.habbiconState = parser.habbiconState;
                if (oldState == HabbiconState.CLAIMABLE && (parser.habbiconState == HabbiconState.OWNED || parser.habbiconState == HabbiconState.FAVOURITE))
                {
                    this.handleNewOwnedHabbicon(parser.habbiconId);
                }
            }
            else
            {
                delete this._owned[parser.habbiconId];
            }
            this.updateCachedShopItemState(parser.habbiconId, parser.habbiconState, null);
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.STATUS_CHANGED, parser.habbiconId));
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, parser.habbiconId));
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED, parser.habbiconId));
        }

        private function onHabbiconShopData(event:HabbiconShopDataMessageEvent):void
        {
            var parser:HabbiconShopDataMessageParser = event.getParser();
            var collection:HabbiconCollectionData;
            var shopItem:HabbiconShopItem;
            this._collectionsById = new Dictionary();
            this._shopItems = new Dictionary();
            this._shopCollections = new Vector.<HabbiconCollectionData>(0);
            for each (collection in parser.collections)
            {
                if (collection != null)
                {
                    this._collectionsById[collection.collectionId] = collection;
                    this._shopCollections.push(collection);
                    for each (shopItem in collection.habbicons)
                    {
                        this._shopItems[shopItem.habbiconId] = shopItem;
                    }
                }
            }
            this._hasLoadedShop = true;
            this._shopRequestPending = false;
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED));
        }

        private function onHabbiconInfo(event:HabbiconInfoMessageEvent):void
        {
            var parser:HabbiconInfoMessageParser = event.getParser();
            var item:HabbiconShopItem = parser.habbicon;
            if (item == null)
            {
                return;
            }
            this._shopItems[item.habbiconId] = item;
            this.updateCachedShopItemState(item.habbiconId, item.state, item);
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED, item.habbiconId, item.collectionId));
        }

        private function onRoomUserHabbicon(event:RoomUserHabbiconMessageEvent):void
        {
            var parser:RoomUserHabbiconMessageParser = event.getParser();
            var roomId:int = this._roomEngine != null ? this._roomEngine.activeRoomId : 0;
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.ROOM_USE_HABBICON, parser.habbiconId, 0, parser.roomIndex));
            if (this._roomEngine != null && roomId != 0)
            {
                this._roomEngine.updateObjectUserAction(roomId, parser.roomIndex, RoomObjectVariableEnum.FIGURE_HABBICON, parser.habbiconId);
            }
        }

        private function onPurchaseOk(event:PurchaseOKMessageEvent):void
        {
            if (this._pendingPurchaseRefresh)
            {
                this._pendingPurchaseRefresh = false;
                this.getShopData(true);
            }
        }

        private function onPurchaseFailed(event:IMessageEvent):void
        {
            this._pendingPurchaseRefresh = false;
        }

        private function onHabbiconAssetsLoaded(event:Event):void
        {
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED));
            this._events.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED));
        }

        private function updateCachedShopItemState(habbiconId:int, state:int, replacement:HabbiconShopItem = null):void
        {
            var collection:HabbiconCollectionData;
            var index:int;
            var item:HabbiconShopItem = replacement != null ? replacement : this._shopItems[habbiconId] as HabbiconShopItem;
            for each (collection in this._shopCollections)
            {
                if (collection != null && collection.rewardHabbiconId == habbiconId)
                {
                    collection.rewardState = state;
                    return;
                }
            }
            if (item == null)
            {
                return;
            }
            item.state = state;
            this._shopItems[habbiconId] = item;
            collection = this._collectionsById[item.collectionId] as HabbiconCollectionData;
            if (collection == null || collection.habbicons == null)
            {
                return;
            }
            for (index = 0; index < collection.habbicons.length; index++)
            {
                if (HabbiconShopItem(collection.habbicons[index]).habbiconId == habbiconId)
                {
                    collection.habbicons[index] = item;
                    break;
                }
            }
        }

        private function handleNewOwnedHabbicon(habbiconId:int):void
        {
            if (this._inventory != null && this._inventory.unseenItemTracker != null)
            {
                // The 2016 unseen tracker only exposes server-driven add/update APIs.
                // Habbicon ownership still refreshes locally via the status/owned packets.
            }
        }

        private function setRecentHabbiconIds(ids:Array):void
        {
            this._recent = [];
            if (ids == null)
            {
                return;
            }
            for each (var id:int in ids)
            {
                this._recent.push(id);
            }
        }

        private function addRecentHabbiconId(habbiconId:int):void
        {
            var index:int = int(this._recent.indexOf(habbiconId));
            if (index >= 0)
            {
                this._recent.splice(index, 1);
            }
            this._recent.unshift(habbiconId);
            if (this._recent.length > RECENT_HABBICON_LIMIT)
            {
                this._recent.length = RECENT_HABBICON_LIMIT;
            }
        }

        private function habbiconsEnabled():Boolean
        {
            return this.getBoolean("habbicons.enabled");
        }

        override public function dispose():void
        {
            var messageEvent:IMessageEvent;
            if (disposed)
            {
                return;
            }
            if (instance == this)
            {
                instance = null;
            }
            if (this._communication != null && this._messageEvents != null)
            {
                for each (messageEvent in this._messageEvents)
                {
                    this._communication.removeHabboConnectionMessageEvent(messageEvent);
                }
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            if (context != null)
            {
                context.removeLinkEventTracker(this);
            }
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
            this._messageEvents = null;
            this._events = null;
            this._owned = null;
            this._recent = null;
            this._collectionsById = null;
            this._shopItems = null;
            this._shopCollections = null;
            this._communication = null;
            this._windowManager = null;
            this._localization = null;
            this._inventory = null;
            this._roomEngine = null;
            this._roomSessionManager = null;
            super.dispose();
        }
    }
}
