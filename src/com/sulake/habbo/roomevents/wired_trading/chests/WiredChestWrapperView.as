package com.sulake.habbo.roomevents.wired_trading.chests
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.SaveChestSafetyMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.StartChestDepositMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.WithdrawAllChestFurniMessageComposer;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_trading.UbuntuPresetManager;
    import com.sulake.habbo.roomevents.wired_trading.chests.settings.ChestNotificationSettingsUI;
    import com.sulake.habbo.roomevents.wired_trading.chests.settings.ChestSettingsUI;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.IChestSubController;
    import com.sulake.habbo.roomevents.wired_trading.chests.upgrade_confirmation.WiredChestUpgradeConfirmationView;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.room.object.IRoomObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class WiredChestWrapperView implements IDisposable
    {
        private var _disposed:Boolean;
        private var _controller:WiredChestController;
        private var _windowManager:IHabboWindowManager;
        private var _window:IFrameWindow;
        private var _lockInfoBubble:IWindowContainer;
        private var _upgradeView:WiredChestUpgradeConfirmationView;
        private var _chestId:int;
        private var _chestObject:IRoomObject;
        private var _isChestOwner:Boolean;
        private var _isRoomOwner:Boolean;
        private var _subController:IChestSubController;
        private var _maxCapacityCache:int = -1;
        private var _ignoreCheckboxEvents:Boolean;
        private var _ignoreCapacityEvents:Boolean;
        private var _ignoreSelectEvents:Boolean;
        private var _ignoreResizeEvents:Boolean;
        private var _lastResizableWidth:int = -1;
        private var _lastResizableHeight:int = -1;
        private var _horizontalChrome:int;
        private var _verticalChrome:int;
        private var _settings:ChestSettingsUI;
        private var _notificationSettings:ChestNotificationSettingsUI;
        private var _presets:PresetManager;

        public function WiredChestWrapperView(controller:WiredChestController,
            windowManager:IHabboWindowManager)
        {
            this._controller = controller;
            this._windowManager = windowManager;
            this._window = windowManager.buildFromXML(XML(controller.assets
                .getAssetByName("chest_generic_xml").content), 1) as IFrameWindow;
            this._horizontalChrome = this._window.width - this.chestContents.width;
            this._verticalChrome = this._window.height - this.chestContents.height
                - this.footer.height - this.header.height;
            this.closeButton.addEventListener("WME_CLICK", this.onWindowClose);
            this.lockInfoButton.addEventListener("WME_CLICK", this.onInfoClick);
            this.withdrawAllButton.addEventListener("WME_CLICK", this.onWithdrawAllClick);
            this.startDepositButton.addEventListener("WME_CLICK", this.onDepositClick);
            this.upgradeButton.addEventListener("WME_CLICK", this.onUpgradeClick);
            this.settingsButton.addEventListener("WME_CLICK", this.onSettingsClick);
            this.notificationSettingsButton.addEventListener("WME_CLICK",
                this.onNotificationSettingsClick);
            this.viewLogsButton.addEventListener("WME_CLICK", this.onViewLogsClick);
            this.lockCheckbox.addEventListener("WE_SELECT", this.onAttemptLock);
            this.lockCheckbox.addEventListener("WE_UNSELECT", this.onAttemptUnlock);
            this.lockCheckbox.addEventListener("WE_SELECTED", this.onOptionsChanged);
            this.lockCheckbox.addEventListener("WE_UNSELECTED", this.onOptionsChanged);
            this.autoLockCheckbox.addEventListener("WE_SELECTED", this.onOptionsChanged);
            this.autoLockCheckbox.addEventListener("WE_UNSELECTED", this.onOptionsChanged);
            this.capacityInput.addEventListener("WME_CLICK_AWAY", this.onOptionsChanged);
            this.capacityInput.addEventListener("WKE_KEY_DOWN", this.onCapacityKeyDown);
            this.capacityInput.addEventListener("WE_CHANGE", this.onCapacityChange);
            this._window.addEventListener("WE_RESIZED", this.onResize);
            this._lockInfoBubble = this._window.findChildByName("lock_info_bubble")
                as IWindowContainer;
            this._window.desktop.addChild(this._lockInfoBubble);
            this._lockInfoBubble.visible = false;
            this._lockInfoBubble.addEventListener("WE_DEACTIVATED", this.onBubbleDeactivate);
            this.setSubController(null);
            // buildFromXML attaches the frame to the desktop immediately in
            // this client generation. A chest must remain detached until the
            // server instructs us to open a concrete chest.
            this.hide();
        }
        private function onResize(event:WindowEvent):void
        {
            if (!this._ignoreResizeEvents)
            {
                this.chestContents.height = this._window.height - this._verticalChrome
                    - this.footer.height - this.header.height;
            }
        }
        private function onSettingsClick(event:WindowMouseEvent):void
        {
            var data:Map = this.getStuffDataMap();
            if (data == null || this._chestId == 0 || this._subController == null) { return; }
            this.chestSettingsUI.onEdit(this._chestId, this._subController.type,
                this._chestObject.getModel().getNumber("furniture_type_id"),
                this.isStarterChest, data);
        }
        private function onNotificationSettingsClick(event:WindowMouseEvent):void
        {
            var data:Map = this.getStuffDataMap();
            if (data == null || this._chestId == 0 || this._subController == null) { return; }
            this.chestNotificationSettingsUI.onEdit(
                this._chestId, this._subController.type, data);
        }
        private function onViewLogsClick(event:WindowMouseEvent):void
        {
            if (this._chestId > 0 && this.canRead)
            {
                this._controller.roomEvents.transactionLogsController
                    .openChestLogs(this._chestId);
            }
        }
        private function onUpgradeClick(event:WindowMouseEvent):void
        {
            if (this._chestId == 0 || this._chestObject == null) { return; }
            if (this._upgradeView == null)
            {
                this._upgradeView = new WiredChestUpgradeConfirmationView(this._controller);
            }
            this._upgradeView.initialize(this._chestId, this._subController.type,
                this._chestObject.getModel().getNumber("furniture_type_id"),
                this.currentCapacityLevel);
            this._upgradeView.show();
        }
        private function onDepositClick(event:WindowMouseEvent):void
        {
            if (this._chestId != 0)
            {
                this._controller.send(new StartChestDepositMessageComposer(this._chestId));
            }
        }
        private function onWithdrawAllClick(event:WindowMouseEvent):void
        {
            this._windowManager.confirm("${wiredchests.withdraw_all.confirm.title}",
                "${wiredchests.withdraw_all.confirm.desc}", 0, this.onWithdrawAllConfirmed);
        }
        private function onWithdrawAllConfirmed(dialog:IConfirmDialog,
            event:WindowEvent):void
        {
            dialog.dispose();
            if (event.type == "WE_OK")
            {
                this._controller.send(new WithdrawAllChestFurniMessageComposer(this._chestId));
            }
        }
        private function onInfoClick(event:WindowMouseEvent):void
        {
            this._lockInfoBubble.visible = true;
            var rectangle:Rectangle = new Rectangle();
            this.lockInfoButton.getGlobalRectangle(rectangle);
            this._lockInfoBubble.position = new Point(rectangle.x + rectangle.width + 3,
                rectangle.y + 1 + rectangle.height / 2 - this._lockInfoBubble.height / 2);
            this._lockInfoBubble.activate();
        }
        private function onBubbleDeactivate(event:WindowEvent):void
        {
            this._lockInfoBubble.visible = false;
        }
        private function onWindowClose(event:WindowEvent):void
        {
            if (event.type == "WME_CLICK") { this.hide(); }
        }
        public function show(subController:IChestSubController, object:IRoomObject,
            chestId:int, chestOwner:Boolean, roomOwner:Boolean):void
        {
            this._chestObject = object;
            this._chestId = chestId;
            this._isChestOwner = chestOwner;
            this._isRoomOwner = roomOwner;
            if (this._subController != null && this._subController != subController)
            {
                this._subController.clear();
                if (this._subController.allowResizing)
                {
                    this._lastResizableWidth = this.chestContents.width;
                    this._lastResizableHeight = this.chestContents.height;
                }
                if (this._settings != null) { this._settings.hide(); }
                if (this._notificationSettings != null) { this._notificationSettings.hide(); }
            }
            this._subController = subController;
            if (this._window.parent == null)
            {
                var desktop:IDesktopWindow = this._windowManager.getDesktop(1);
                if (desktop != null) { desktop.addChild(this._window); }
            }
            this.resetCaches();
            this.setSubController(subController);
            this.updateLayout();
            this.updateUIOptions();
            this.updateUI();
            this._lockInfoBubble.visible = false;
            this._window.activate();
        }
        public function hide():void
        {
            if (this.isShowing())
            {
                var desktop:IDesktopWindow = this._windowManager.getDesktop(1);
                if (desktop != null) { desktop.removeChild(this._window); }
            }
            this._lockInfoBubble.visible = false;
            this.setSubController(null);
            this._controller.setClosedStatus();
            this._chestId = 0;
            this._chestObject = null;
            if (this._subController != null) { this._subController.clear(); }
            this._subController = null;
            this.resetCaches();
            if (this._settings != null) { this._settings.hide(); }
            if (this._notificationSettings != null) { this._notificationSettings.hide(); }
        }
        public function isShowing():Boolean
        {
            return this._window != null && this._window.parent != null;
        }
        public function viewingChestUpdated():void
        {
            this.resetCaches();
            if (this.isShowing() && !this.canRead && !this.isVisibleForEveryone)
            {
                this.hide();
                return;
            }
            this.updateLayout();
            this.updateUIOptions();
            this.updateUI();
        }
        public function onPermissionsChanged():void
        {
            if (this.isShowing() && !this.canRead && !this.isVisibleForEveryone)
            {
                this.hide();
                return;
            }
            if (this.isShowing())
            {
                this.updateLayout();
                this.updateUI();
            }
        }
        public function updateLayout():void
        {
            var data:Map = this.getStuffDataMap();
            if (data == null || this._subController == null) { return; }
            var wired:Boolean = data.getValue("is_wired_enabled") == "1";
            this._ignoreResizeEvents = true;
            this.settingsButton.visible = this.canRead;
            this.notificationSettingsButton.visible = this.canRead;
            this.viewLogsButton.visible = this.canRead;
            this.lockingOptions.visible = this.canRead && wired;
            this.capacityOptions.visible = this.canRead;
            this.capacityOverrideContainer.visible = this.canRead && wired;
            this.upgradeCapacityContainer.visible = this.canRead;
            this.itemCountText.visible = this.canRead && !wired;
            this.itemCountTextBottom.visible = !this.canRead;
            this.lockInfoButton.visible = this.canRead && wired;
            this.withdrawAllButton.visible = this.canRead;
            this.startDepositButton.caption = this.canRead
                ? "${wiredchests.start_deposit}" : "${wiredchests.donate}";
            this._window.height = this.mainList.height + this._verticalChrome;
            this._ignoreResizeEvents = false;
        }
        public function updateUIOptions():void
        {
            var data:Map = this.getStuffDataMap();
            if (data == null) { return; }
            this._ignoreCheckboxEvents = true;
            this._ignoreCapacityEvents = true;
            Util.select(this.lockCheckbox, data.getValue("locked") != "0");
            Util.select(this.autoLockCheckbox, data.getValue("auto_lock") != "0");
            this.capacityInput.text = data.getValue("capacity");
            this._ignoreCheckboxEvents = false;
            this._ignoreCapacityEvents = false;
            this.maxCapacityText.text = this._controller.localization
                .getLocalizationWithParams("wiredchests.max_capacity", "",
                    "max_capacity", String(this.maxCapacity));
        }
        public function updateUI():void
        {
            var data:Map = this.getStuffDataMap();
            if (data == null || this._subController == null) { return; }
            var canDonate:Boolean = data.getValue("everyone_can_donate") == "1";
            var name:String = data.getValue("chest_name");
            var description:String = data.getValue("chest_desc");
            if (description == null || description == "")
            {
                description = "${wiredchests.description_placeholder}";
            }
            var capacity:int = int(data.getValue("capacity"));
            this.itemCountText.caption = this._controller.localization
                .getLocalizationWithParams("wiredchests.space_used2", "",
                    "count", this._subController.itemCount, "total", capacity);
            this.itemCountTextBottom.caption = this._controller.localization
                .getLocalizationWithParams("wiredchests.space_used", "",
                    "count", this._subController.itemCount, "total", capacity);
            this._window.caption = name != null && name.length > 0
                ? name : this._subController.title;
            this.description.text = description;
            Util.disableSection(this.lockCheckbox,
                !this._isChestOwner && (!this._isRoomOwner || this.lockCheckbox.Selected));
            Util.disableSection(this.autoLockCheckbox, !this._isChestOwner);
            Util.disableSection(this.capacityInputBorder, !this._isChestOwner);
            Util.disableSection(this.withdrawAllButton, !this.canWithdraw);
            Util.disableSection(this.startDepositButton,
                !canDonate && (!this.canEdit
                    || (this.lockCheckbox.Selected && !this._isChestOwner)));
            Util.disableSection(this.settingsButton, !this._isChestOwner);
            Util.disableSection(this.notificationSettingsButton, !this._isChestOwner);
            Util.disableSection(this.viewLogsButton, !this.canRead);
            Util.disableSection(this.upgradeButton, this.isStarterChest || !this._isChestOwner);
            this.upgradeRegion.toolTipCaption = this.isStarterChest
                ? "${wiredchests.upgrade.result.error.10}"
                : !this._isChestOwner
                    ? "${wiredchests.upgrade.error.reason.not_owner}" : "";
            this._subController.updateUI();
        }
        private function onOptionsChanged(event:WindowEvent):void
        {
            if (this._ignoreCheckboxEvents) { return; }
            this._controller.send(new SaveChestSafetyMessageComposer(this._chestId,
                this.lockCheckbox.Selected, this.autoLockCheckbox.Selected,
                int(this.capacityInput.text)));
        }
        private function onCapacityChange(event:WindowEvent):void
        {
            if (!this._ignoreCapacityEvents && int(this.capacityInput.text) > this.maxCapacity)
            {
                this._ignoreCapacityEvents = true;
                this.capacityInput.text = String(this.maxCapacity);
                this._ignoreCapacityEvents = false;
            }
        }
        private function onCapacityKeyDown(event:WindowKeyboardEvent):void
        {
            if (event.keyCode == 13) { this.onOptionsChanged(null); }
        }
        private function onAttemptLock(event:WindowEvent):void
        {
            if (this._ignoreCheckboxEvents || this._ignoreSelectEvents
                || this._isChestOwner) { return; }
            event.preventWindowOperation();
            this._windowManager.confirm("${wiredchests.lock.confirm.title}",
                "${wiredchests.lock.confirm.desc}", 0, this.onConfirmLock);
        }
        private function onAttemptUnlock(event:WindowEvent):void
        {
            if (this._ignoreCheckboxEvents || this._ignoreSelectEvents) { return; }
            event.preventWindowOperation();
            this._windowManager.confirm("${wiredchests.unlock.confirm.title}",
                "${wiredchests.unlock.confirm.desc}", 0, this.onConfirmUnlock);
        }
        private function onConfirmLock(dialog:IConfirmDialog, event:WindowEvent):void
        {
            dialog.dispose();
            if (event.type == "WE_OK")
            {
                this._ignoreSelectEvents = true;
                this.lockCheckbox.select();
                this._ignoreSelectEvents = false;
            }
        }
        private function onConfirmUnlock(dialog:IConfirmDialog, event:WindowEvent):void
        {
            dialog.dispose();
            if (event.type == "WE_OK")
            {
                this._ignoreSelectEvents = true;
                this.lockCheckbox.unselect();
                this._ignoreSelectEvents = false;
            }
        }
        private function setSubController(value:IChestSubController):void
        {
            this._ignoreResizeEvents = true;
            var next:IWindowContainer = value == null ? null : value.view;
            if (this.chestContents.numChildren > 0)
            {
                var old:IWindowContainer = this.chestContents.getChildAt(0) as IWindowContainer;
                if (old == next) { this._ignoreResizeEvents = false; return; }
                old.setParamFlag(128, false);
                old.setParamFlag(2048, false);
                this.chestContents.removeChild(old);
            }
            if (next != null)
            {
                next.setParamFlag(128, false);
                next.setParamFlag(2048, false);
                if (!value.allowResizing || this._lastResizableHeight < 0)
                {
                    this._window.width = next.width + this._horizontalChrome;
                    this.chestContents.height = next.height;
                }
                else
                {
                    this._window.width = this._lastResizableWidth + this._horizontalChrome;
                    this.chestContents.height = this._lastResizableHeight;
                }
                this._window.setParamFlag(65536, value.allowResizing);
                this.chestContents.addChild(next);
                if (value.allowResizing)
                {
                    next.width = this.chestContents.width;
                    next.height = this.chestContents.height;
                    next.setParamFlag(128, true);
                    next.setParamFlag(2048, true);
                }
            }
            this._ignoreResizeEvents = false;
        }
        private function getStuffDataMap():Map
        {
            if (this._chestObject == null || this._chestObject.getModel() == null) { return null; }
            return this._chestObject.getModel().getStringToStringMap("furniture_data");
        }
        private function resetCaches():void { this._maxCapacityCache = -1; }
        private function get currentCapacityLevel():int
        {
            var data:Map = this.getStuffDataMap();
            return data == null ? 0 : int(data.getValue("capacity_level"));
        }
        private function get maxCapacity():int
        {
            if (this._maxCapacityCache >= 0) { return this._maxCapacityCache; }
            var kind:String = this._subController != null
                && this._subController.type == ChestType.COINS ? "coins" : "furni";
            if (this.isStarterChest)
            {
                this._maxCapacityCache = this._controller.getInteger(
                    "wired." + kind + "_chest.starter_capacity", 0);
            }
            else
            {
                this._maxCapacityCache = this._controller.getInteger(
                    "wired." + kind + "_chest.initial_capacity", 0)
                    + this._controller.getInteger(
                        "wired." + kind + "_chest.upgrade_capacity", 0)
                        * this.currentCapacityLevel;
            }
            return this._maxCapacityCache;
        }
        private function get isStarterChest():Boolean
        {
            if (this._chestObject == null) { return false; }
            var typeId:int = this._chestObject.getModel().getNumber("furniture_type_id");
            var data:IFurnitureData = this._controller.sessionDataManager
                .getFloorItemData(typeId);
            var infix:String = this._controller.getProperty("wired.chests_starter_infix", "");
            return data != null && infix != "" && data.className.indexOf(infix) >= 0;
        }
        public function get canWithdraw():Boolean
        {
            return this._subController != null && !this._subController.isEmpty
                && this.canEdit && (!this.lockCheckbox.Selected || this._isChestOwner);
        }
        public function get canEdit():Boolean
        {
            return this._isChestOwner || (this._controller.roomEvents.wiredMenu != null
                && this._controller.roomEvents.wiredMenu.hasWritePermission);
        }
        public function get canRead():Boolean
        {
            return this._isChestOwner || (this._controller.roomEvents.wiredMenu != null
                && this._controller.roomEvents.wiredMenu.hasReadPermission);
        }
        public function get isVisibleForEveryone():Boolean
        {
            var data:Map = this.getStuffDataMap();
            return data != null && data.getValue("everyone_can_open") == "1";
        }
        public function get viewingChestId():int { return this._chestId; }
        public function get viewingChestFurni():IRoomObject { return this._chestObject; }
        public function get chestSettingsUI():ChestSettingsUI
        {
            if (this._presets == null) { this._presets = new UbuntuPresetManager(
                this._controller.roomEvents); }
            if (this._settings == null)
            {
                this._settings = new ChestSettingsUI(this._controller, this._presets);
            }
            return this._settings;
        }
        public function get chestNotificationSettingsUI():ChestNotificationSettingsUI
        {
            if (this._presets == null) { this._presets = new UbuntuPresetManager(
                this._controller.roomEvents); }
            if (this._notificationSettings == null)
            {
                this._notificationSettings = new ChestNotificationSettingsUI(
                    this._controller, this._presets);
            }
            return this._notificationSettings;
        }
        public function dispose():void
        {
            if (this._disposed) { return; }
            if (this._settings != null) { this._settings.dispose(); }
            if (this._notificationSettings != null) { this._notificationSettings.dispose(); }
            if (this._upgradeView != null) { this._upgradeView.dispose(); }
            this.hide();
            this._window.dispose();
            this._lockInfoBubble.dispose();
            this._window = null;
            this._lockInfoBubble = null;
            this._controller = null;
            this._windowManager = null;
            this._presets = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
        private function get closeButton():IWindow
        { return this._window.findChildByName("header_button_close"); }
        private function get mainList():IItemListWindow
        { return this._window.findChildByName("main_list") as IItemListWindow; }
        private function get chestContents():IWindowContainer
        { return this._window.findChildByName("chest_contents") as IWindowContainer; }
        private function get lockInfoButton():IRegionWindow
        { return this._window.findChildByName("lock_info_button") as IRegionWindow; }
        private function get description():ITextWindow
        { return this._window.findChildByName("desc") as ITextWindow; }
        private function get settingsButton():IWindow
        { return this._window.findChildByName("settings_button"); }
        private function get notificationSettingsButton():IWindow
        { return this._window.findChildByName("notification_settings_button"); }
        private function get viewLogsButton():IButtonWindow
        { return this._window.findChildByName("view_logs_btn") as IButtonWindow; }
        private function get lockingOptions():IItemListWindow
        { return this._window.findChildByName("locking_options") as IItemListWindow; }
        private function get capacityOptions():IWindowContainer
        { return this._window.findChildByName("capacity_options") as IWindowContainer; }
        private function get capacityOverrideContainer():IItemListWindow
        { return this._window.findChildByName("capacity_override_container") as IItemListWindow; }
        private function get upgradeCapacityContainer():IItemListWindow
        { return this._window.findChildByName("upgrade_capacity_container") as IItemListWindow; }
        private function get itemCountText():ITextWindow
        { return this._window.findChildByName("item_count_text") as ITextWindow; }
        private function get itemCountTextBottom():ITextWindow
        { return this._window.findChildByName("item_count_text_bottom") as ITextWindow; }
        private function get header():IWindowContainer
        { return this._window.findChildByName("header") as IWindowContainer; }
        private function get footer():IWindowContainer
        { return this._window.findChildByName("footer") as IWindowContainer; }
        private function get lockCheckbox():ICheckBoxWindow
        { return this._window.findChildByName("lock_chest_cbx") as ICheckBoxWindow; }
        private function get autoLockCheckbox():ICheckBoxWindow
        { return this._window.findChildByName("auto_lock_chest_cbx") as ICheckBoxWindow; }
        private function get capacityInput():ITextFieldWindow
        { return this._window.findChildByName("capacity_input") as ITextFieldWindow; }
        private function get capacityInputBorder():IBorderWindow
        { return this._window.findChildByName("capacity_input_border") as IBorderWindow; }
        private function get maxCapacityText():ITextWindow
        { return this._window.findChildByName("max_capacity_txt") as ITextWindow; }
        private function get upgradeButton():IWindow
        { return this._window.findChildByName("upgrade_capacity_btn"); }
        private function get upgradeRegion():IRegionWindow
        { return this._window.findChildByName("upgrade_capacity_region") as IRegionWindow; }
        private function get withdrawAllButton():IButtonWindow
        { return this._window.findChildByName("withdraw_all_btn") as IButtonWindow; }
        private function get startDepositButton():IButtonWindow
        { return this._window.findChildByName("start_deposit_btn") as IButtonWindow; }
    }
}
