package com.sulake.habbo.roomevents
{
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.notifications.IHabboNotifications;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.WiredClickUserMessageComposer;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboNotifications;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.iid.IIDSessionDataManager;
    import __AS3__.vec.Vector;
    import com.sulake.habbo.room.IRoomEngineServices;
    import com.sulake.habbo.room.ISelectedRoomObjectData;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.communication.enum.HabboCommunicationEvent;
    import flash.display.BitmapData;
    import flash.events.Event;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePickerHelper;
    import com.sulake.habbo.roomevents.wired_menu.WiredMenuController;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import com.sulake.habbo.roomevents.wired_trading.contracts.WiredContractController;
    import com.sulake.habbo.roomevents.wired_trading.reward_notification.RewardNotificationController;
    import com.sulake.habbo.roomevents.wired_trading.transactions.WiredTransactionDetailsController;
    import com.sulake.habbo.roomevents.wired_trading.transactions.WiredTransactionLogsController;

    public class HabboUserDefinedRoomEvents extends Component implements IHabboUserDefinedRoomEvents 
    {
        private var _windowManager:IHabboWindowManager;
        private var _communication:IHabboCommunicationManager;
        private var _localization:IHabboLocalizationManager;
        private var _notifications:IHabboNotifications;
        private var _userDefinedRoomEventsCtrl:UserDefinedRoomEventsCtrl;
        private var _incomingMessages:IncomingMessages;
        private var _wiredCapabilities:WiredCapabilities;
        private var _variablesSynchronizer:WiredVariablesSynchronizer;
        private var _wiredEnvironment:WiredEnvironment;
        private var _wiredMenu:WiredMenuController;
        private var _wiredChestController:WiredChestController;
        private var _wiredContractController:WiredContractController;
        private var _rewardNotificationController:RewardNotificationController;
        private var _transactionLogsController:WiredTransactionLogsController;
        private var _transactionDetailsController:WiredTransactionDetailsController;
        private var _variablePickerHelper:NewVariablePickerHelper;
        private var _roomEngine:IRoomEngine;
        private var _roomSessionManager:IRoomSessionManager;
        private var _roomSession:IRoomSession;
        private var _sessionDataManager:ISessionDataManager;
        private var _toolbar:IHabboToolbar;
        private var _catalog:IHabboCatalog;
        private var _userName:String;

        public function HabboUserDefinedRoomEvents(k:IContext, _arg_2:uint=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._userDefinedRoomEventsCtrl = new UserDefinedRoomEventsCtrl(this);
        }

        public function get communication():IHabboCommunicationManager
        {
            return this._communication;
        }

        public function get windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public function get localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        override protected function get dependencies():Vector.<ComponentDependency>
        {
            return (super.dependencies.concat(new <ComponentDependency>[new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager):void
            {
                _communication = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager):void
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager):void
            {
                _localization = k;
            }), new ComponentDependency(new IIDHabboNotifications(), function (k:IHabboNotifications):void
            {
                _notifications = k;
            }), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine):void
            {
                _roomEngine = k;
            }), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager):void
            {
                _roomSessionManager = k;
            }, false, [{
                "type":RoomSessionEvent.CREATED,
                "callback":this.roomSessionStateEventHandler
            }, {
                "type":RoomSessionEvent.STARTED,
                "callback":this.roomSessionStateEventHandler
            }, {
                "type":RoomSessionEvent.ROOM_DATA,
                "callback":this.roomSessionStateEventHandler
            }, {
                "type":RoomSessionEvent.ENDED,
                "callback":this.roomSessionStateEventHandler
            }]), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager):void
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar):void
            {
                _toolbar = k;
                refreshWiredUiConsumers();
            }, false, [{
                "type":HabboToolbarEvent.HTE_TOOLBAR_CLICK,
                "callback":this.onHabboToolbarEvent
            }]), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog):void
            {
                _catalog = k;
            })]));
        }

        override protected function initComponent():void
        {
            this._variablePickerHelper = new NewVariablePickerHelper(this);
            this._wiredCapabilities = new WiredCapabilities(this);
            this._variablesSynchronizer = new WiredVariablesSynchronizer(this);
            this._wiredEnvironment = new WiredEnvironment(this);
            this._wiredMenu = new WiredMenuController(this);
            context.addLinkEventTracker(this._wiredMenu);
            this._wiredChestController = new WiredChestController(this);
            this._wiredContractController = new WiredContractController(this);
            this._rewardNotificationController =
                new RewardNotificationController(this);
            context.addLinkEventTracker(this._rewardNotificationController);
            this._transactionLogsController =
                new WiredTransactionLogsController(this);
            this._transactionDetailsController =
                new WiredTransactionDetailsController(this);
            this._incomingMessages = new IncomingMessages(this);
            context.events.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_ESTABLISHED, this.onConnectionEvent);
            context.events.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_AUTHENTICATED, this.onConnectionEvent);
            // This component can be created after the room session has already started.
            // Do not wait for a future room transition to negotiate its room capabilities.
            this.synchronizeCurrentRoomSession();
        }

        public function showWiredNotification(localizationKey:String):void
        {
            if (this._notifications == null) { return; }
            var extraData:Object = {};
            extraData["time_display"] = 2500;
            this._notifications.addItem(this._localization.getLocalization(localizationKey, localizationKey), "wired", null, null, extraData);
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            var componentContext:IContext = context;
            if (this._incomingMessages != null)
            {
                this._incomingMessages.dispose();
                this._incomingMessages = null;
            }
            if (this._wiredEnvironment != null)
            {
                this._wiredEnvironment.dispose();
                this._wiredEnvironment = null;
            }
            if (this._wiredMenu != null)
            {
                if (componentContext != null)
                {
                    componentContext.removeLinkEventTracker(this._wiredMenu);
                }
                this._wiredMenu.dispose();
                this._wiredMenu = null;
            }
            if (this._wiredChestController != null)
            {
                this._wiredChestController.dispose();
                this._wiredChestController = null;
            }
            if (this._wiredContractController != null)
            {
                this._wiredContractController.dispose();
                this._wiredContractController = null;
            }
            if (this._rewardNotificationController != null)
            {
                if (componentContext != null)
                {
                    componentContext.removeLinkEventTracker(
                        this._rewardNotificationController);
                }
                this._rewardNotificationController.dispose();
                this._rewardNotificationController = null;
            }
            if (this._transactionLogsController != null)
            {
                this._transactionLogsController.dispose();
                this._transactionLogsController = null;
            }
            if (this._transactionDetailsController != null)
            {
                this._transactionDetailsController.dispose();
                this._transactionDetailsController = null;
            }
            if (componentContext != null && componentContext.events != null)
            {
                componentContext.events.removeEventListener(
                    HabboCommunicationEvent.HABBO_CONNECTION_EVENT_ESTABLISHED,
                    this.onConnectionEvent);
                componentContext.events.removeEventListener(
                    HabboCommunicationEvent.HABBO_CONNECTION_EVENT_AUTHENTICATED,
                    this.onConnectionEvent);
            }
            if (this._wiredCapabilities != null)
            {
                this._wiredCapabilities.dispose();
                this._wiredCapabilities = null;
            }
            if (this._variablesSynchronizer != null)
            {
                this._variablesSynchronizer.dispose();
                this._variablesSynchronizer = null;
            }
            if (this._variablePickerHelper != null)
            {
                this._variablePickerHelper.dispose();
                this._variablePickerHelper = null;
            }
            super.dispose();
        }

        private function onConnectionEvent(k:Event):void
        {
            if (this._wiredCapabilities == null)
            {
                return;
            }
            this._wiredCapabilities.resetConnection();
            if (this._variablesSynchronizer != null)
            {
                this._variablesSynchronizer.clear();
            }
            if (k.type == HabboCommunicationEvent.HABBO_CONNECTION_EVENT_AUTHENTICATED)
            {
                this.synchronizeCurrentRoomSession();
                this._wiredCapabilities.request(this.roomId);
            }
        }

        public function _Str_15677(k:int, _arg_2:String):void
        {
            var _local_3:ISelectedRoomObjectData = (this._roomEngine as IRoomEngineServices).getPlacedObjectData(this.roomId);
            if (((_local_3) && (_local_3.id == -(k))))
            {
                (this._roomEngine as IRoomEngineServices).setPlacedObjectData(this.roomId, null);
                return;
            }
            this._userDefinedRoomEventsCtrl._Str_15677(k, _arg_2);
        }

        public function send(k:IMessageComposer, _arg_2:Boolean=false):void
        {
            this._communication.connection.send(k);
        }

        public function userSelected(k:int):void
        {
            if (this._wiredMenu != null)
            {
                this._wiredMenu.inspectUser(k);
            }
            if (this.hasClickUserWired())
            {
                this.send(new WiredClickUserMessageComposer(
                    k, com.sulake.habbo.room.RoomObjectEventHandler.wiredHeldTicks));
            }
        }

        public function furnitureSelected(k:int):void
        {
            if (this._wiredMenu != null)
            {
                this._wiredMenu.inspectFurni(k);
            }
        }

        public function showInspectButton():Boolean
        {
            return this._wiredMenu != null
                && this.isWiredFeatureEnabled(WiredCapabilityCodes.WIRED_MENU)
                && this._wiredMenu.hasReadPermission
                && this._wiredMenu.wiredInspectButton;
        }

        public function showToolbarMenuButton():Boolean
        {
            return this._wiredMenu != null
                && this.isWiredFeatureEnabled(WiredCapabilityCodes.WIRED_MENU)
                && this._wiredMenu.hasReadPermission
                && this._wiredMenu.wiredMenuButton;
        }

        public function inspectObject(type:int, id:int):void
        {
            if (this._wiredMenu != null && this.showInspectButton())
            {
                this._wiredMenu.linkReceived(
                    "wiredmenu/open/inspection/" + type + "/" + id);
            }
        }

        public function refreshWiredUiConsumers():void
        {
            if (this._toolbar != null)
            {
                this._toolbar.setIconVisibility(
                    HabboToolbarIconEnum.WIRED_MENU,
                    this.showToolbarMenuButton());
            }
            if (this._wiredChestController != null)
            {
                this._wiredChestController.onPermissionsChanged();
            }
        }

        private function onHabboToolbarEvent(k:HabboToolbarEvent):void
        {
            if (k.iconId == HabboToolbarIconEnum.WIRED_MENU &&
                this.showToolbarMenuButton())
            {
                this.openWiredMenu();
            }
        }

        public function get achievementsInRoom():Vector.<String>
        {
            return this._wiredEnvironment != null
                ? this._wiredEnvironment.achievements
                : new Vector.<String>();
        }

        public function resetWiredRoomState():void
        {
            if (this._wiredMenu != null)
            {
                this._wiredMenu.resetRoom();
            }
            if (this._wiredChestController != null)
            {
                this._wiredChestController.resetRoom();
            }
            if (this._wiredContractController != null)
            {
                this._wiredContractController.clear();
            }
            if (this._rewardNotificationController != null)
            {
                this._rewardNotificationController.closeAllViews();
            }
            if (this._transactionLogsController != null)
            {
                this._transactionLogsController.resetRoom();
            }
            if (this._transactionDetailsController != null)
            {
                this._transactionDetailsController.resetRoom();
            }
            if (this._wiredEnvironment != null)
            {
                this._wiredEnvironment.leaveRoom();
            }
            if (this._wiredCapabilities != null)
            {
                this._wiredCapabilities.resetRoom();
            }
            if (this._variablesSynchronizer != null)
            {
                this._variablesSynchronizer.clear();
            }
        }

        public function hasClickUserWired():Boolean
        {
            return this._wiredEnvironment != null
                && this._wiredEnvironment.hasClickUserWired;
        }

        /** July's user click option 1 makes the active room use game-mode click routing. */
        public function get isGameMode():Boolean
        {
            return this._wiredEnvironment != null
                && this._wiredEnvironment.clickUserOption == WiredEnvironment.CLICK_USER_WALK_BEHIND;
        }

        public function get notifications():IHabboNotifications
        {
            return this._notifications;
        }

        public function openWiredMenu(tab:String = "monitor"):void
        {
            if (this._wiredMenu != null)
            {
                this._wiredMenu.show(tab);
            }
        }

        /**
         * July bases the persistent notification toggle on Wired Menu write
         * permission. Until the menu snapshot arrives, existing room rights
         * are the conservative equivalent.
         */
        public function get hasWiredMenuWritePermission():Boolean
        {
            if (this._roomSession == null)
            {
                return false;
            }
            return this._roomSession.isRoomOwner
                || this._roomSession.roomControllerLevel > 0
                || (this._sessionDataManager != null
                    && this._sessionDataManager.isAnyRoomController);
        }

        public function isWiredFeatureEnabled(k:int):Boolean
        {
            if (this._wiredCapabilities == null)
            {
                return false;
            }
            if (k == WiredCapabilityCodes.PROTOCOL)
            {
                return this._wiredCapabilities.isConnectionSupported(k);
            }
            return this._wiredCapabilities.isRoomEnabled(k, this.roomId);
        }

        public function getXmlWindow(k:String):IWindow
        {
            var _local_3:IAsset;
            var _local_4:XmlAsset;
            var _local_2:IWindow;
            try
            {
                _local_3 = assets.getAssetByName((k + "_xml"));
                _local_4 = XmlAsset(_local_3);
                _local_2 = this._windowManager.buildFromXML(XML(_local_4.content));
            }
            catch(e:Error)
            {
            }
            return _local_2;
        }

        public function refreshButton(k:IWindowContainer, _arg_2:String, _arg_3:Boolean, _arg_4:Function, _arg_5:int, _arg_6:String=null):void
        {
            if (!_arg_6)
            {
                _arg_6 = _arg_2;
            }
            var _local_7:IBitmapWrapperWindow = (k.findChildByName(_arg_2) as IBitmapWrapperWindow);
            if (!_arg_3)
            {
                _local_7.visible = false;
            }
            else
            {
                this._Str_11416(_local_7, _arg_6, _arg_4, _arg_5);
                _local_7.visible = true;
            }
        }

        private function _Str_11416(k:IBitmapWrapperWindow, _arg_2:String, _arg_3:Function, _arg_4:int):void
        {
            k.id = _arg_4;
            k.procedure = _arg_3;
            if (k.bitmap != null)
            {
                return;
            }
            k.bitmap = this.getButtonImage(_arg_2);
            k.width = k.bitmap.width;
            k.height = k.bitmap.height;
        }

        public function getButtonImage(k:String, _arg_2:String="_png"):BitmapData
        {
            var _local_3:String = (k + _arg_2);
            var _local_4:IAsset = assets.getAssetByName(_local_3);
            var _local_5:BitmapDataAsset = BitmapDataAsset(_local_4);
            var _local_6:BitmapData = BitmapData(_local_5.content);
            return _local_6.clone();
        }

        public function get _Str_7247():UserDefinedRoomEventsCtrl
        {
            return this._userDefinedRoomEventsCtrl;
        }

        public function get wiredCtrl():UserDefinedRoomEventsCtrl
        {
            return this._userDefinedRoomEventsCtrl;
        }

        public function get variablesSynchronizer():WiredVariablesSynchronizer
        {
            return this._variablesSynchronizer;
        }

        public function get variablePickerHelper():NewVariablePickerHelper
        {
            return this._variablePickerHelper;
        }

        public function get wiredMenu():WiredMenuController
        {
            return this._wiredMenu;
        }

        public function get wiredChestController():WiredChestController
        {
            return this._wiredChestController;
        }

        public function get wiredContractController():WiredContractController
        {
            return this._wiredContractController;
        }

        public function get rewardNotificationController():RewardNotificationController
        {
            return this._rewardNotificationController;
        }

        public function get transactionLogsController():WiredTransactionLogsController
        {
            return this._transactionLogsController;
        }

        public function get transactionDetailsController():WiredTransactionDetailsController
        {
            return this._transactionDetailsController;
        }

        public function get roomSession():IRoomSession
        {
            return this._roomSession;
        }

        public function get roomEngine():IRoomEngine
        {
            return this._roomEngine;
        }

        private function roomSessionStateEventHandler(k:RoomSessionEvent):void
        {
            if (this._roomEngine == null)
            {
                return;
            }
            switch (k.type)
            {
                case RoomSessionEvent.CREATED:
                    this.resetWiredRoomState();
                    this._roomSession = k.session;
                    return;
                case RoomSessionEvent.STARTED:
                    this.resetWiredRoomState();
                    this._roomSession = k.session;
                    if (this._wiredMenu != null)
                    {
                        this._wiredMenu.applyRoomSessionPreferences();
                    }
                    if (this._wiredCapabilities != null)
                    {
                        this._wiredCapabilities.request(this.roomId);
                    }
                    return;
                case RoomSessionEvent.ROOM_DATA:
                    this._roomSession = k.session;
                    if (this._wiredMenu != null)
                    {
                        this._wiredMenu.applyRoomSessionPreferences();
                    }
                    if (this._wiredCapabilities != null)
                    {
                        // ROOM_DATA arrives after the server has completed room entry. Retrying
                        // here closes the STARTED/current-room ordering race without reloading.
                        this._wiredCapabilities.request(this.roomId);
                    }
                    return;
                case RoomSessionEvent.ENDED:
                    this.resetWiredRoomState();
                    this._roomSession = k.session;
                    return;
            }
        }

        private function synchronizeCurrentRoomSession():void
        {
            if (((this._roomSessionManager == null) || (this._roomEngine == null)))
            {
                return;
            }
            var k:IRoomSession = this._roomSessionManager.getSession(this._roomEngine.activeRoomId);
            if (k == null)
            {
                return;
            }
            if (this._roomSession != k)
            {
                this.resetWiredRoomState();
                this._roomSession = k;
            }
            if (this._wiredCapabilities != null)
            {
                this._wiredCapabilities.request(k.roomId);
            }
        }

        public function get roomId():int
        {
            return (this._roomSession) ? this._roomSession.roomId : 0;
        }

        public function get userName():String
        {
            return this._userName;
        }

        public function set userName(k:String):void
        {
            this._userName = k;
        }

        public function get sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public function get catalog():IHabboCatalog
        {
            return this._catalog;
        }
    }
}
