package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.ObjectIdAndValuePair;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.VariableInfoAndHolders;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu.*;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionInfo;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogPage;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.preferences.AccountPreferencesEvent;
    import com.sulake.habbo.communication.messages.parser.preferences.AccountPreferencesParser;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu.*;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.SetChestRoomLocksMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions.RequestRoomTransactionLogsMessageComposer;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.*;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     * July 2026 Wired Menu shell.  The menu is room-scoped and only opens after
     * the server advertises the Wired Menu capability. Creator Tools are a
     * separate product and are intentionally not exposed here.
     */
    public final class WiredMenuController implements IDisposable, ILinkEventTracker
    {
        private static const COLOR_RED:String = "ff5733";
        private static const COLOR_ORANGE:String = "BD7800";
        private static const COLOR_GREEN:String = "008000";

        public static const MONITOR:String = "monitor";
        public static const OVERVIEW:String = "variable_overview";
        public static const INSPECTION:String = "inspection";
        public static const CHESTS:String = "chests";
        public static const SETTINGS:String = "settings";
        public static const INFO:String = "info";

        private static const TABS:Array =
            [MONITOR, OVERVIEW, INSPECTION, CHESTS, SETTINGS];

        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _window:IFrameWindow;
        private var _activeTab:String;
        private var _messageEvents:Array = [];
        private var _modifyMask:int = 8;
        private var _readMask:int = 15;
        private var _timezone:String = "UTC";
        private var _writePermission:Boolean;
        private var _readPermission:Boolean = true;
        private var _ignoreSettings:Boolean;
        private var _menuButton:Boolean = true;
        private var _inspectButton:Boolean = true;
        private var _playtest:Boolean;
        private var _allNotifications:Boolean;
        private var _whisperDisabled:Boolean;
        private var _uiStyle:String = "";
        private var _selectedVariableId:String;
        private var _requestedVariableId:String;
        private var _allVariables:Vector.<WiredVariable> =
            new Vector.<WiredVariable>();
        private var _overviewTarget:int = 0;
        private var _timezoneValues:Array = [];
        private var _wiredStyleValues:Array = ["", "illumina"];
        private var _inspectionPickerIds:Array = [];
        private var _inspectionExisting:Object = {};
        private var _selectedInspectionVariableId:String;
        private var _inspectionVariablePicker:IDropMenuWindow;
        private var _inspectionPinned:Boolean;
        private var _monitorHeavy:Boolean;
        private var _monitorOverThreshold:Boolean;
        private var _configuredWiredIds:Array = [];
        private var _wiredIdsHighlighted:Boolean;
        private var _variablesById:Object = {};
        private var _inspectedType:int = -1;
        private var _inspectedId:int = -1;
        private var _inspectionReady:Boolean;
        private var _errorTable:TableView;
        private var _variableListTable:TableView;
        private var _propertyTable:TableView;
        private var _textTable:TableView;
        private var _inspectionTable:TableView;
        private var _inspectionPreviewer:WiredMenuInspectionPreviewer;
        private var _chestTransactionsTable:TableView;
        private var _chestTransactions:WiredTransactionLogPage;
        private var _holderHighlighter:WiredMenuHolderHighlighter;
        private var _logsWindow:WiredMenuLogsWindow;
        private var _errorInfoWindow:WiredMenuErrorInfoWindow;
        private var _variableManagementWindow:
            WiredMenuVariableManagementWindow;
        private var _monitorTimer:Timer;
        private var _overviewTimer:Timer;
        private var _inspectionTimer:Timer;
        private var _chestTimer:Timer;
        private var _chestLockTimer:Timer;
        private var _chestLockPending:Boolean;
        private var _holderIds:Array = [];
        private var _holdersHighlighted:Boolean;
        private var _disposed:Boolean;

        public function WiredMenuController(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._holderHighlighter =
                new WiredMenuHolderHighlighter(roomEvents);
            this._logsWindow = new WiredMenuLogsWindow(
                roomEvents, this.requestLogsPage);
            this._errorInfoWindow =
                new WiredMenuErrorInfoWindow(roomEvents);
            this._variableManagementWindow =
                new WiredMenuVariableManagementWindow(
                    roomEvents, this.requestUserVariablesPage,
                    this.requestPermanentVariables,
                    this.mutatePermanentVariable);
            this._monitorTimer = new Timer(500);
            this._monitorTimer.addEventListener(
                TimerEvent.TIMER, this.onMonitorPoll);
            this._overviewTimer = new Timer(500);
            this._overviewTimer.addEventListener(
                TimerEvent.TIMER, this.onOverviewPoll);
            this._inspectionTimer = new Timer(500);
            this._inspectionTimer.addEventListener(
                TimerEvent.TIMER, this.onInspectionPoll);
            this._chestTimer = new Timer(20000);
            this._chestTimer.addEventListener(
                TimerEvent.TIMER, this.onChestPoll);
            this._chestLockTimer = new Timer(500, 1);
            this._chestLockTimer.addEventListener(
                TimerEvent.TIMER_COMPLETE, this.onChestLockTimeout);
            this.addMessageEvent(new WiredMenuPermissionsEvent(this.onPermissions));
            this.addMessageEvent(new WiredMenuRoomSettingsEvent(this.onRoomSettings));
            this.addMessageEvent(new WiredMenuRoomStatsEvent(this.onRoomStats));
            this.addMessageEvent(new WiredMenuErrorsEvent(this.onErrors));
            this.addMessageEvent(new WiredMenuInspectionEvent(this.onInspection));
            this.addMessageEvent(new WiredMenuErrorEvent(this.onInspectionError));
            this.addMessageEvent(new WiredMenuMutationResultEvent(this.onMutation));
            this.addMessageEvent(new WiredMenuLogsPageEvent(this.onLogs));
            this.addMessageEvent(new WiredMenuVariableHoldersEvent(this.onVariableHolders));
            this.addMessageEvent(new WiredMenuUserVariablesPageEvent(this.onUserVariables));
            this.addMessageEvent(new WiredMenuPermanentVariablesEvent(this.onPermanentVariables));
            this.addMessageEvent(
                new WiredTransactionLogsMessageEvent(this.onChestTransactionLogs));
            this.addMessageEvent(new AccountPreferencesEvent(this.onAccountPreferences));
        }

        private function addMessageEvent(event:IMessageEvent):void
        {
            this._messageEvents.push(
                this._roomEvents.communication.addHabboConnectionMessageEvent(event));
        }

        public function show(tab:String = MONITOR):void
        {
            if (this._roomEvents.roomId <= 0 ||
                !this._roomEvents.isWiredFeatureEnabled(WiredCapabilityCodes.WIRED_MENU))
            {
                this._roomEvents.showWiredNotification("wiredmenu.invalid_room.desc");
                return;
            }
            this.ensureWindow();
            this.selectTab(TABS.indexOf(tab) >= 0 ? tab : MONITOR);
            if (this._window.parent == null)
            {
                this._roomEvents.windowManager.getDesktop(1).addChild(this._window);
            }
            this._window.center();
            this._window.activate();
        }

        public function get linkPattern():String
        {
            return "wiredmenu/";
        }

        public function linkReceived(link:String):void
        {
            if (link == null)
            {
                return;
            }
            var parts:Array = link.split("/");
            if (parts.length < 2)
            {
                return;
            }
            if (parts[1] == "logs")
            {
                this.show(MONITOR);
                if (this._logsWindow != null)
                {
                    this._logsWindow.show();
                }
                return;
            }
            if (parts[1] != "open")
            {
                return;
            }
            var tab:String = parts.length > 2 ? String(parts[2]) : MONITOR;
            this.show(tab);
            if (tab == INSPECTION && parts.length >= 5)
            {
                var type:int = int(parts[3]);
                var objectId:int = int(parts[4]);
                if ((type == 0 && objectId != 0)
                    || (type == 1 && objectId > 0)
                    || (type == -10 && objectId == 0))
                {
                    this._roomEvents.send(
                        new InspectWiredObjectComposer(type, objectId));
                }
            }
            else if (tab == OVERVIEW && parts.length >= 4)
            {
                try
                {
                    this._selectedVariableId =
                        decodeURIComponent(String(parts[3]));
                }
                catch (error:Error)
                {
                    this._selectedVariableId = null;
                    return;
                }
                this._roomEvents.variablesSynchronizer.getAllVariables(
                    this.onVariablesLoaded, true);
            }
        }

        public function hide():void
        {
            if (this._monitorTimer != null)
            {
                this._monitorTimer.stop();
            }
            if (this._chestTimer != null)
            {
                this._chestTimer.stop();
            }
            if (this._overviewTimer != null)
            {
                this._overviewTimer.stop();
            }
            if (this._inspectionTimer != null)
            {
                this._inspectionTimer.stop();
            }
            if (this._window != null && this._window.parent != null)
            {
                (this._window.parent as IWindowContainer).removeChild(this._window);
            }
        }

        public function resetRoom():void
        {
            if (this._holderHighlighter != null)
            {
                this._holderHighlighter.clear();
            }
            this._holdersHighlighted = false;
            if (this._logsWindow != null)
            {
                this._logsWindow.close();
            }
            if (this._errorInfoWindow != null)
            {
                this._errorInfoWindow.hide();
            }
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.close();
            }
            this.hide();
            this._activeTab = null;
            this._inspectedType = -1;
            this._inspectedId = -1;
            this._inspectionReady = false;
            if (this._inspectionPreviewer != null)
            {
                this._inspectionPreviewer.clear();
            }
            this._chestTransactions = null;
            if (this._chestTransactionsTable != null)
            {
                this._chestTransactionsTable.clear();
            }
        }

        private function ensureWindow():void
        {
            if (this._window != null)
            {
                return;
            }
            this._window = this._roomEvents.getXmlWindow("wired_menu_view") as IFrameWindow;
            if (this._window == null)
            {
                throw new Error("wired_menu_view_xml could not be created");
            }
            var close:IWindow = this._window.findChildByTag("close");
            if (close != null)
            {
                close.addEventListener(WindowMouseEvent.CLICK, this.onClose);
            }
            var context:ITabContextWindow =
                this._window.findChildByName("tab_context") as ITabContextWindow;
            for each (var id:String in TABS)
            {
                var button:ITabButtonWindow =
                    this._window.findChildByName("top_view_" + id + "_button")
                    as ITabButtonWindow;
                if (button != null)
                {
                    button.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                        this.onTabSelected);
                }
            }
            var chests:IWindow = this._window.findChildByName("top_view_chests_button");
            if (chests != null)
            {
                chests.visible = this._roomEvents.isWiredFeatureEnabled(
                    WiredCapabilityCodes.MENU_CHESTS);
            }
            // July ships the empty Info view as a dormant, disabled tab.
            var info:IWindow =
                this._window.findChildByName("top_view_" + INFO + "_button");
            if (info != null)
            {
                info.visible = false;
                info.width = 0;
            }
            var infoContainer:IWindow =
                this._window.findChildByName(INFO + "_container");
            if (infoContainer != null)
            {
                infoContainer.visible = false;
            }
            this.alignVisibleTabs(context);
            this.initializeTables();
            var inspectionPreview:IWindowContainer =
                this._window.findChildByName("preview_container")
                as IWindowContainer;
            if (inspectionPreview != null)
            {
                this._inspectionPreviewer =
                    new WiredMenuInspectionPreviewer(
                        inspectionPreview, this._roomEvents);
                this.updateInspectionPreview();
            }
            this.bindSettingsControls();
            this.bindVariableControls();
            this.initializeTimezonePicker();
            this.initializeWiredStylePicker();
            this.initializeDiscordLink();
            this.bindChestControls();
            this.applyPreferences();
        }

        private function initializeTables():void
        {
            var tableAsset:XmlAsset =
                this._roomEvents.assets.getAssetByName("table_view_xml") as XmlAsset;
            if (tableAsset == null)
            {
                throw new Error("table_view_xml is required by Wired Menu");
            }
            this._errorTable = this.createTable("log_table_container", [
                new TableColumn("name", this.loc("wiredmenu.monitor.column.type"), 0.33),
                new TableColumn("category", this.loc("wiredmenu.monitor.column.category"), 0.22),
                new TableColumn("count", this.loc("wiredmenu.monitor.column.occurrences"), 0.15),
                new TableColumn("latest", this.loc("wiredmenu.monitor.column.latest"), 0.30)
            ], tableAsset);
            if (this._errorTable != null)
            {
                this._errorTable.onRowClickedCallback =
                    this.onErrorSelected;
            }
            this._variableListTable = this.createTable("variable_list_container", [
                new TableColumn("name",
                    this.loc("wiredmenu.variable_overview.picker"), 1, "left")
            ], tableAsset);
            if (this._variableListTable != null)
            {
                this._variableListTable.onRowSelectedCallback =
                    this.onVariableSelected;
            }
            this._propertyTable =
                this.createTable("variable_properties_table_container", [
                    new TableColumn("property",
                        this.loc("wiredmenu.variable_overview.properties.column.property"),
                        0.52, "left"),
                    new TableColumn("value",
                        this.loc("wiredmenu.variable_overview.properties.column.value"),
                        0.48, "left")
                ], tableAsset);
            this._textTable =
                this.createTable("variable_texts_table_container", [
                    new TableColumn("value",
                        this.loc("wiredmenu.variable_overview.text.column.value"),
                        0.25, "left"),
                    new TableColumn("text",
                        this.loc("wiredmenu.variable_overview.text.column.text"),
                        0.75, "left")
                ], tableAsset);
            this._inspectionTable =
                this.createTable("variable_values_table_container", [
                    new TableColumn("variable",
                        this.loc("wiredmenu.inspection.variables.variable"),
                        0.65, "left"),
                    new TableColumn("value",
                        this.loc("wiredmenu.inspection.variables.value"),
                        0.35, "right")
                ], tableAsset);
            if (this._inspectionTable != null)
            {
                this._inspectionTable.onCellEditCallback =
                    this.onInspectionCellEdited;
                this._inspectionTable.onRowSelectedCallback =
                    this.onInspectionRowSelected;
            }
            this._chestTransactionsTable =
                this.createTable("logs_table_container", [
                    new TableColumn("type",
                        this.loc("wiredmenu.chests.room_logs.column.type"), 0.28),
                    new TableColumn("username",
                        this.loc("wiredmenu.chests.room_logs.column.username"), 0.24),
                    new TableColumn("withdraws",
                        this.loc("wiredmenu.chests.room_logs.column.withdraws"), 0.24),
                    new TableColumn("deposits",
                        this.loc("wiredmenu.chests.room_logs.column.deposits"), 0.24)
                ], tableAsset);
        }

        private function bindChestControls():void
        {
            this.bindClick("lock_own_button", this.onLockOwnChests);
            this.bindClick("unlock_own_button", this.onUnlockOwnChests);
            this.bindClick("lock_all_button", this.onLockAllChests);
            this.bindClick("view_in_detail_button", this.onViewChestLogs);
            this.updateChestButtons();
        }

        private function createTable(containerName:String, columns:Array,
                                     asset:XmlAsset):TableView
        {
            var parent:IWindowContainer =
                this._window.findChildByName(containerName) as IWindowContainer;
            if (parent == null)
            {
                return null;
            }
            var table:TableView = new TableView(this._roomEvents.windowManager,
                parent, true, false, asset);
            table.initialize(Vector.<TableColumn>(columns), true, true);
            return table;
        }

        private function loc(key:String):String
        {
            return this._roomEvents.localization.getLocalization(key, key);
        }

        private function alignVisibleTabs(context:ITabContextWindow):void
        {
            if (context == null)
            {
                return;
            }
            var count:int = 0;
            var index:int;
            for (index = 0; index < context.numTabs; index++)
            {
                if (context.getTabButtonAt(index).visible)
                {
                    count++;
                }
            }
            if (count == 0)
            {
                return;
            }
            for (index = 0; index < context.numTabs; index++)
            {
                var item:ITabButtonWindow = context.getTabButtonAt(index);
                if (item.visible)
                {
                    item.width = int(item.parent.width / count);
                }
            }
        }

        private function bindSettingsControls():void
        {
            var names:Array = [
                "modify_1_checkbox", "modify_2_checkbox", "modify_3_checkbox",
                "read_0_checkbox", "read_1_checkbox", "read_2_checkbox",
                "read_3_checkbox", "preference_toolbar_checkbox",
                "preference_inspect_button_checkbox",
                "preference_playtest_checkbox",
                "preference_all_notifications_checkbox"
            ];
            for each (var name:String in names)
            {
                var checkbox:ICheckBoxWindow =
                    this._window.findChildByName(name) as ICheckBoxWindow;
                if (checkbox != null)
                {
                    checkbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                        this.onSettingChanged);
                    checkbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED,
                        this.onSettingChanged);
                }
            }
            this.bindClick("reload_room_btn", this.onReload);
            this.bindClick("roll_back_btn", this.onRollback);
            this.bindClick("clear_log_btn", this.onClearErrors);
            this.bindClick("log_overview_btn", this.onOpenLogs);
        }

        private function bindVariableControls():void
        {
            var overview:IWindowContainer =
                this._window.findChildByName("variable_overview_container")
                as IWindowContainer;
            var inspection:IWindowContainer =
                this._window.findChildByName("inspection_container")
                as IWindowContainer;
            this.bindTypeButton(overview, "type_furni_button",
                this.onOverviewType);
            this.bindTypeButton(overview, "type_user_button",
                this.onOverviewType);
            this.bindTypeButton(overview, "type_global_button",
                this.onOverviewType);
            this.bindTypeButton(overview, "type_context_button",
                this.onOverviewType);
            this.bindScopedClick(overview, "manage_button",
                this.onManageVariable);
            this.bindScopedClick(overview, "highlight_holders_button",
                this.onHighlightHolders);
            this.bindTypeButton(inspection, "type_furni_button",
                this.onInspectionType);
            this.bindTypeButton(inspection, "type_user_button",
                this.onInspectionType);
            this.bindTypeButton(inspection, "type_global_button",
                this.onInspectionType);
            this.bindScopedClick(inspection, "add_var_btn",
                this.onAddVariable);
            this.bindScopedClick(inspection, "delete_var_btn",
                this.onDeleteVariable);
            this.bindScopedClick(inspection, "create_var_btn",
                this.onCreateVariable);
            this.bindScopedClick(inspection, "highlight_wired_btn",
                this.onHighlightWired);
            var pin:ICheckBoxWindow = inspection == null ? null :
                inspection.findChildByName("pin_checkbox") as ICheckBoxWindow;
            if (pin != null)
            {
                pin.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onPinChanged);
                pin.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED,
                    this.onPinChanged);
            }
            var source:IDropMenuWindow =
                this._window.findChildByName("timezone_picker")
                as IDropMenuWindow;
            var pickerContainer:IWindowContainer = inspection == null ? null :
                inspection.findChildByName("var_picker_container")
                as IWindowContainer;
            if (source != null && pickerContainer != null)
            {
                this._inspectionVariablePicker =
                    source.clone() as IDropMenuWindow;
                this._inspectionVariablePicker.name =
                    "inspection_variable_picker";
                this._inspectionVariablePicker.x = 0;
                this._inspectionVariablePicker.y = 0;
                this._inspectionVariablePicker.width =
                    pickerContainer.width;
                pickerContainer.addChild(this._inspectionVariablePicker);
            }
            var input:ITextFieldWindow = inspection == null ? null :
                inspection.findChildByName("value_input")
                as ITextFieldWindow;
            if (input != null)
            {
                input.restrict = "0-9\\-";
                input.maxChars = 11;
            }
            var bubble:IWindow = inspection == null ? null :
                inspection.findChildByName("create_var_bubble");
            if (bubble != null)
            {
                bubble.visible = false;
            }
            this.setTypePickerState(overview, this._overviewTarget);
            this.setTypePickerState(inspection, 0);
            if (this._inspectedType == -1)
            {
                this._inspectedType = 0;
                this._inspectedId = -1;
                this._inspectionReady = false;
            }
            this.updateInspectionPreview();
        }

        private function bindScopedClick(container:IWindowContainer,
                                         name:String,
                                         handler:Function):void
        {
            var window:IWindow = container == null ? null :
                container.findChildByName(name);
            if (window != null)
            {
                window.addEventListener(WindowMouseEvent.CLICK, handler);
            }
        }

        private function bindTypeButton(container:IWindowContainer,
                                        name:String,
                                        handler:Function):void
        {
            var window:IWindow = container == null ? null :
                container.findChildByName(name);
            if (window != null)
            {
                window.addEventListener(WindowMouseEvent.UP, handler);
                window.addEventListener(WindowMouseEvent.OUT, handler);
            }
        }

        private function initializeTimezonePicker():void
        {
            var picker:IDropMenuWindow =
                this._window.findChildByName("timezone_picker")
                as IDropMenuWindow;
            if (picker == null)
            {
                return;
            }
            var raw:String = this._roomEvents.getProperty("wired.timezones");
            var configured:Array =
                raw == null || raw == "" ? ["UTC"] : raw.split(",");
            this._timezoneValues = [];
            for each (var candidate:String in configured)
            {
                candidate = candidate == null ? "" : candidate.replace(
                    /^\s+|\s+$/g, "");
                if (candidate != ""
                    && this._timezoneValues.indexOf(candidate) < 0)
                {
                    this._timezoneValues.push(candidate);
                }
            }
            if (this._timezoneValues.indexOf("UTC") < 0)
            {
                this._timezoneValues.unshift("UTC");
            }
            picker.populate(this._timezoneValues);
            picker.selection = Math.max(0,
                this._timezoneValues.indexOf(this._timezone));
            picker.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                this.onTimezoneSelected);
        }

        private function onTimezoneSelected(event:WindowEvent):void
        {
            if (this._ignoreSettings)
            {
                return;
            }
            var picker:IDropMenuWindow = event.target as IDropMenuWindow;
            if (picker == null || picker.selection < 0
                || picker.selection >= this._timezoneValues.length)
            {
                return;
            }
            this._timezone = String(
                this._timezoneValues[picker.selection]);
            this._roomEvents.send(new UpdateWiredRoomSettingsComposer(
                this._modifyMask, this._readMask, this._timezone));
        }

        /**
         * July only exposes this picker when wired.ui_picker_enabled is true.
         * The clean client currently contains the Illumina editor style, so do
         * not advertise July's Volter choice until that style is ported too.
         */
        private function initializeWiredStylePicker():void
        {
            var border:IWindow =
                this._window.findChildByName("wired_style_border");
            var picker:IDropMenuWindow =
                this._window.findChildByName("wired_style_picker")
                as IDropMenuWindow;
            var raw:String =
                this._roomEvents.getProperty("wired.ui_picker_enabled");
            var enabled:Boolean = raw != null
                && (raw == "1" || raw.toLowerCase() == "true");
            if (border != null)
            {
                border.visible = enabled;
            }
            if (picker == null)
            {
                return;
            }
            var defaultLabel:String =
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.settings.preferences.wired_style.default",
                    "Default (Illumina)", "name", "Illumina");
            picker.populate([defaultLabel, "Illumina"]);
            var index:int = this._wiredStyleValues.indexOf(this._uiStyle);
            picker.selection = index < 0 ? 0 : index;
            picker.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                this.onWiredStyleSelected);
        }

        private function onWiredStyleSelected(event:WindowEvent):void
        {
            if (this._ignoreSettings)
            {
                return;
            }
            var picker:IDropMenuWindow = event.target as IDropMenuWindow;
            if (picker == null || picker.selection < 0
                || picker.selection >= this._wiredStyleValues.length)
            {
                return;
            }
            this._uiStyle = String(
                this._wiredStyleValues[picker.selection]);
            this.sendPreferences();
        }

        private function initializeDiscordLink():void
        {
            var region:IWindow =
                this._window.findChildByName("discord_region");
            if (region == null)
            {
                return;
            }
            var link:String =
                this._roomEvents.getProperty("wired.discord.link");
            link = link == null ? "" : link.replace(/^\s+|\s+$/g, "");
            region.visible = link != "";
            if (region.visible)
            {
                region.addEventListener(
                    WindowMouseEvent.CLICK, this.onDiscordClick);
            }
        }

        private function onDiscordClick(event:WindowMouseEvent):void
        {
            var link:String =
                this._roomEvents.getProperty("wired.discord.link");
            link = link == null ? "" : link.replace(/^\s+|\s+$/g, "");
            if (link != "")
            {
                HabboWebTools.openWebPageAndMinimizeClient(link);
            }
        }

        private function bindClick(name:String, handler:Function):void
        {
            var window:IWindow = this._window.findChildByName(name);
            if (window != null)
            {
                window.addEventListener(WindowMouseEvent.CLICK, handler);
            }
        }

        private function onTabSelected(event:WindowEvent):void
        {
            var name:String = event.target.name;
            var prefix:String = "top_view_";
            var suffix:String = "_button";
            if (name.indexOf(prefix) != 0 ||
                name.lastIndexOf(suffix) != name.length - suffix.length)
            {
                return;
            }
            this.selectTab(name.substring(prefix.length,
                name.length - suffix.length));
        }

        private function onChestTransactionLogs(event:IMessageEvent):void
        {
            var page:WiredTransactionLogPage =
                (event as WiredTransactionLogsMessageEvent).getParser().page;
            if (page == null ||
                page.listType != WiredTransactionLogPage.LIST_ROOM ||
                page.amount != 10 || page.currentPage != 1)
            {
                return;
            }
            this._chestTransactions = page;
            this.renderChestTransactions();
        }

        private function renderChestTransactions():void
        {
            if (this._chestTransactionsTable == null ||
                this._chestTransactions == null)
            {
                return;
            }
            var rows:Vector.<ITableObject> = new Vector.<ITableObject>();
            for each (var info:WiredTransactionInfo
                in this._chestTransactions.logs)
            {
                rows.push(new WiredMenuChestTransactionTableObject(
                    this._roomEvents, info));
            }
            this._chestTransactionsTable.setObjects(rows);
        }

        private function onChestPoll(event:TimerEvent):void
        {
            if (this._activeTab == CHESTS)
            {
                this.requestChestPreview();
            }
        }

        private function requestChestPreview():void
        {
            this._roomEvents.send(
                new RequestRoomTransactionLogsMessageComposer(10, 1));
        }

        private function onLockOwnChests(event:WindowMouseEvent):void
        {
            this.sendChestLock(true, false);
        }

        private function onUnlockOwnChests(event:WindowMouseEvent):void
        {
            this.sendChestLock(false, false);
        }

        private function onLockAllChests(event:WindowMouseEvent):void
        {
            if (!this.isRoomOwnerOrStaff() || this._chestLockPending)
            {
                return;
            }
            this._roomEvents.windowManager.confirm(
                "${wiredmenu.chests.chest_control.lock_all.warning.title}",
                "${wiredmenu.chests.chest_control.lock_all.warning.desc}",
                0, this.onLockAllChestConfirmation);
        }

        private function onLockAllChestConfirmation(
            dialog:IConfirmDialog, event:WindowEvent):void
        {
            dialog.dispose();
            if (event.type == WindowEvent.WINDOW_EVENT_OK)
            {
                this.sendChestLock(true, true);
            }
        }

        private function sendChestLock(lock:Boolean, all:Boolean):void
        {
            if (this._chestLockPending ||
                (all ? !this.isRoomOwnerOrStaff() : !this._writePermission))
            {
                return;
            }
            this._roomEvents.send(
                new SetChestRoomLocksMessageComposer(lock, all));
            this._chestLockPending = true;
            this._chestLockTimer.reset();
            this._chestLockTimer.start();
            this.updateChestButtons();
        }

        private function onChestLockTimeout(event:TimerEvent):void
        {
            this._chestLockPending = false;
            this.updateChestButtons();
        }

        private function onViewChestLogs(event:WindowMouseEvent):void
        {
            this._roomEvents.transactionLogsController.openRoomLogs();
        }

        private function updateChestButtons():void
        {
            if (this._window == null)
            {
                return;
            }
            var lockOwn:IButtonWindow =
                this._window.findChildByName("lock_own_button") as IButtonWindow;
            var unlockOwn:IButtonWindow =
                this._window.findChildByName("unlock_own_button") as IButtonWindow;
            var lockAll:IButtonWindow =
                this._window.findChildByName("lock_all_button") as IButtonWindow;
            if (lockOwn != null)
            {
                Util.disableSection(lockOwn,
                    !this._writePermission || this._chestLockPending);
            }
            if (unlockOwn != null)
            {
                Util.disableSection(unlockOwn,
                    !this._writePermission || this._chestLockPending);
            }
            if (lockAll != null)
            {
                Util.disableSection(lockAll,
                    !this.isRoomOwnerOrStaff() || this._chestLockPending);
            }
        }

        private function isRoomOwnerOrStaff():Boolean
        {
            return this._roomEvents.roomSession != null
                && (this._roomEvents.roomSession.isRoomOwner
                    || (this._roomEvents.sessionDataManager != null
                        && this._roomEvents.sessionDataManager
                            .isAnyRoomController));
        }

        public function selectTab(id:String):void
        {
            if (this._window == null || TABS.indexOf(id) < 0)
            {
                return;
            }
            if (id == CHESTS && !this._roomEvents.isWiredFeatureEnabled(
                WiredCapabilityCodes.MENU_CHESTS))
            {
                return;
            }
            for each (var tabId:String in TABS)
            {
                var container:IWindow =
                    this._window.findChildByName(tabId + "_container");
                if (container != null)
                {
                    container.visible = tabId == id;
                }
            }
            this._activeTab = id;
            if (this._monitorTimer != null)
            {
                if (id == MONITOR)
                {
                    this._monitorTimer.start();
                }
                else
                {
                    this._monitorTimer.stop();
                }
            }
            if (this._overviewTimer != null)
            {
                if (id == OVERVIEW)
                {
                    this._overviewTimer.start();
                }
                else
                {
                    this._overviewTimer.stop();
                }
            }
            if (this._inspectionTimer != null)
            {
                if (id == INSPECTION)
                {
                    this._inspectionTimer.start();
                }
                else
                {
                    this._inspectionTimer.stop();
                }
            }
            if (this._chestTimer != null)
            {
                if (id == CHESTS)
                {
                    this._chestTimer.start();
                }
                else
                {
                    this._chestTimer.stop();
                }
            }
            var title:ITextWindow =
                this._window.findChildByName("header_title") as ITextWindow;
            if (title != null)
            {
                title.text = this._roomEvents.localization.getLocalization(
                    "wiredmenu." + id + ".title", id);
            }
            this.requestTabData(id);
        }

        private function requestTabData(id:String):void
        {
            // Packet-backed refreshes are kept at this boundary so selecting a
            // tab never trusts stale state from a previous room.
            if (id == OVERVIEW || id == INSPECTION)
            {
                this._roomEvents.variablesSynchronizer.getAllVariables(
                    this.onVariablesLoaded, true);
                if (id == INSPECTION && this._inspectedType == -10)
                {
                    this._roomEvents.send(
                        new InspectWiredObjectComposer(-10, 0));
                }
            }
            else if (id == MONITOR)
            {
                this._roomEvents.send(new RequestWiredRoomStatsComposer());
                this._roomEvents.send(new RequestWiredErrorsComposer());
            }
            else if (id == SETTINGS)
            {
                this._roomEvents.send(new RequestWiredRoomSettingsComposer());
            }
            else if (id == CHESTS)
            {
                this._chestTransactions = null;
                if (this._chestTransactionsTable != null)
                {
                    this._chestTransactionsTable.clear();
                }
                this.requestChestPreview();
            }
        }

        private function onMonitorPoll(event:TimerEvent):void
        {
            if (this._window != null && this._window.parent != null
                && this._activeTab == MONITOR)
            {
                this._roomEvents.send(
                    new RequestWiredRoomStatsComposer());
                this._roomEvents.send(
                    new RequestWiredErrorsComposer());
            }
        }

        private function onOverviewPoll(event:TimerEvent):void
        {
            if (this._window == null || this._window.parent == null
                || this._activeTab != OVERVIEW)
            {
                return;
            }
            this._roomEvents.variablesSynchronizer.getAllVariables(
                this.onVariablesLoaded, true);
            if (this._holdersHighlighted
                && this._selectedVariableId != null)
            {
                this._requestedVariableId = this._selectedVariableId;
                this._roomEvents.send(new RequestVariableHoldersComposer(
                    this._selectedVariableId));
            }
        }

        private function onInspectionPoll(event:TimerEvent):void
        {
            if (this._window != null && this._window.parent != null
                && this._activeTab == INSPECTION
                && this.hasValidInspectedHolder())
            {
                this._roomEvents.send(new InspectWiredObjectComposer(
                    this._inspectedType, this._inspectedId));
            }
        }

        private function onVariablesLoaded(variables:*):void
        {
            if (this._window == null)
            {
                return;
            }
            this._allVariables = new Vector.<WiredVariable>();
            this._variablesById = {};
            for each (var variable:WiredVariable in variables)
            {
                if (variable == null || variable.isInvisible
                    || this._allVariables.length >= 4096)
                {
                    continue;
                }
                this._allVariables.push(variable);
                this._variablesById[variable.variableId] = variable;
            }
            this.renderOverviewVariables();
            this.populateInspectionVariablePicker();
            if (this._variableManagementWindow != null)
            {
                var creatable:Array = [];
                for each (variable in this._allVariables)
                {
                    if (variable.variableTarget == 1
                        && variable.isPersisted
                        && variable.canCreateAndDelete)
                    {
                        creatable.push({id:variable.variableId,
                            name:variable.variableName});
                    }
                }
                this._variableManagementWindow.setCreatableVariables(
                    creatable);
            }
        }

        private function renderOverviewVariables():void
        {
            var rows:Vector.<ITableObject> = new Vector.<ITableObject>();
            var requested:String = this._selectedVariableId;
            var requestedRow:ITableObject;
            for each (var variable:WiredVariable in this._allVariables)
            {
                if (variable.variableTarget != this._overviewTarget
                    || rows.length >= 500)
                {
                    continue;
                }
                var row:WiredMenuTableObject =
                    new WiredMenuTableObject(variable.variableId,
                        {name:variable.variableName}, variable);
                rows.push(row);
                if (variable.variableId == requested
                    || variable.variableName == requested)
                {
                    requestedRow = row;
                }
            }
            if (this._variableListTable != null)
            {
                this._variableListTable.setObjects(rows);
                if (rows.length > 0)
                {
                    this._variableListTable.trySelect(
                        requestedRow == null ? rows[0] : requestedRow, true);
                }
                else
                {
                    this._selectedVariableId = null;
                }
            }
        }

        private function onVariableSelected(row:ITableObject):void
        {
            if (this._holderHighlighter != null)
            {
                this._holderHighlighter.clear();
            }
            this._holdersHighlighted = false;
            this._holderIds = [];
            var item:WiredMenuTableObject = row as WiredMenuTableObject;
            var variable:WiredVariable = item == null ? null :
                item.data as WiredVariable;
            this._selectedVariableId = variable == null ? null :
                variable.variableId;
            if (this._selectedVariableId == null)
            {
                return;
            }
            this._requestedVariableId = this._selectedVariableId;
            this._roomEvents.send(
                new RequestVariableHoldersComposer(this._selectedVariableId));
        }

        private function onOverviewType(event:WindowMouseEvent):void
        {
            var type:int = IWindow(event.target).id;
            if (event.type == WindowMouseEvent.OUT)
            {
                if (type == this._overviewTarget)
                {
                    event.preventWindowOperation();
                }
                return;
            }
            event.preventWindowOperation();
            this._overviewTarget = type;
            var container:IWindowContainer =
                this._window.findChildByName("variable_overview_container")
                as IWindowContainer;
            this.setTypePickerState(container, this._overviewTarget);
            this._selectedVariableId = null;
            this.renderOverviewVariables();
        }

        private function onInspectionType(event:WindowMouseEvent):void
        {
            var type:int = IWindow(event.target).id;
            if (event.type == WindowMouseEvent.OUT)
            {
                if (type == this._inspectedType
                    || (this._inspectedType == -1 && type == 0))
                {
                    event.preventWindowOperation();
                }
                return;
            }
            event.preventWindowOperation();
            var container:IWindowContainer =
                this._window.findChildByName("inspection_container")
                as IWindowContainer;
            this.setTypePickerState(container, type);
            this._inspectedType = type;
            this._inspectedId = type == -10 ? 0 : -1;
            this._inspectionReady = false;
            this._inspectionExisting = {};
            this._selectedInspectionVariableId = null;
            if (this._inspectionTable != null)
            {
                this._inspectionTable.clear();
            }
            this.populateInspectionVariablePicker();
            if (type == -10)
            {
                this._roomEvents.send(
                    new InspectWiredObjectComposer(-10, 0));
            }
            this.updateInspectionPreview();
            this.updateInspectionButtons();
        }

        private function updateInspectionPreview():void
        {
            if (this._inspectionPreviewer == null)
            {
                return;
            }
            if (this._inspectedType == -10)
            {
                this._inspectionPreviewer.showGlobal();
            }
            else if (!this._inspectionReady)
            {
                if (this._inspectedType == 1)
                {
                    this._inspectionPreviewer.showUserInstruction();
                }
                else
                {
                    this._inspectionPreviewer.showFurniInstruction();
                }
            }
            else if (this._inspectedType == 1)
            {
                this._inspectionPreviewer.showUser(this._inspectedId);
            }
            else if (this._inspectedType == 0)
            {
                this._inspectionPreviewer.showFurni(this._inspectedId);
            }
            else
            {
                this._inspectionPreviewer.clear();
            }
        }

        private function setTypePickerState(container:IWindowContainer,
                                            selected:int):void
        {
            if (container == null)
            {
                return;
            }
            var names:Array = ["type_furni_button", "type_user_button",
                "type_global_button", "type_context_button"];
            for each (var name:String in names)
            {
                var button:IWindow = container.findChildByName(name);
                if (button != null)
                {
                    button.setStateFlag(16, button.id == selected);
                    if (button.id != selected)
                    {
                        button.setStateFlag(4, false);
                    }
                }
            }
        }

        private function onInspectionRowSelected(row:ITableObject):void
        {
            var item:WiredMenuInspectionTableObject =
                row as WiredMenuInspectionTableObject;
            this._selectedInspectionVariableId =
                item == null || item.variable == null ? null :
                item.variable.variableId;
            this.updateInspectionButtons();
        }

        private function populateInspectionVariablePicker():void
        {
            if (this._inspectionVariablePicker == null)
            {
                return;
            }
            var labels:Array = [];
            this._inspectionPickerIds = [];
            for each (var variable:WiredVariable in this._allVariables)
            {
                if (variable.variableTarget != this._inspectedType
                    || !variable.canCreateAndDelete
                    || this._inspectionExisting[variable.variableId])
                {
                    continue;
                }
                this._inspectionPickerIds.push(variable.variableId);
                labels.push(variable.variableName);
            }
            this._inspectionVariablePicker.populate(labels);
            this._inspectionVariablePicker.selection =
                labels.length == 0 ? -1 : 0;
        }

        private function onAddVariable(event:WindowMouseEvent):void
        {
            if (!this._writePermission
                || !this.hasValidInspectedHolder())
            {
                return;
            }
            this.populateInspectionVariablePicker();
            var inspection:IWindowContainer =
                this._window.findChildByName("inspection_container")
                as IWindowContainer;
            var bubble:IWindow = inspection == null ? null :
                inspection.findChildByName("create_var_bubble");
            if (bubble != null)
            {
                bubble.visible = true;
                bubble.activate();
            }
        }

        private function onCreateVariable(event:WindowMouseEvent):void
        {
            if (!this._writePermission
                || !this.hasValidInspectedHolder()
                || this._inspectionVariablePicker == null)
            {
                return;
            }
            var index:int = this._inspectionVariablePicker.selection;
            if (index < 0 || index >= this._inspectionPickerIds.length)
            {
                return;
            }
            var inspection:IWindowContainer =
                this._window.findChildByName("inspection_container")
                as IWindowContainer;
            var input:ITextFieldWindow = inspection == null ? null :
                inspection.findChildByName("value_input")
                as ITextFieldWindow;
            var raw:String = input == null ? "" : input.text;
            if (!/^-?\d+$/.test(raw))
            {
                return;
            }
            var value:Number = Number(raw);
            if (value < -2147483648 || value > 2147483647)
            {
                return;
            }
            this._roomEvents.send(new ModifyInspectedVariableComposer(
                this._inspectedType, this._inspectedId,
                String(this._inspectionPickerIds[index]), int(value), 1));
            var bubble:IWindow = inspection.findChildByName(
                "create_var_bubble");
            if (bubble != null)
            {
                bubble.visible = false;
            }
        }

        private function onDeleteVariable(event:WindowMouseEvent):void
        {
            if (!this._writePermission
                || !this.hasValidInspectedHolder()
                || this._selectedInspectionVariableId == null)
            {
                return;
            }
            var variable:WiredVariable =
                this._variablesById[this._selectedInspectionVariableId]
                as WiredVariable;
            if (variable == null || !variable.canCreateAndDelete)
            {
                return;
            }
            this._roomEvents.send(new ModifyInspectedVariableComposer(
                this._inspectedType, this._inspectedId,
                this._selectedInspectionVariableId, 0, 2));
        }

        private function onPinChanged(event:WindowEvent):void
        {
            var pin:ICheckBoxWindow = event.target as ICheckBoxWindow;
            this._inspectionPinned = pin != null && pin.Selected;
        }

        private function onHighlightWired(event:WindowMouseEvent):void
        {
            if (this._configuredWiredIds.length == 0)
            {
                return;
            }
            this._wiredIdsHighlighted = !this._wiredIdsHighlighted;
            if (this._wiredIdsHighlighted)
            {
                this._holderHighlighter.show(0, this._configuredWiredIds);
            }
            else
            {
                this._holderHighlighter.clear();
            }
        }

        private function updateInspectionButtons():void
        {
            if (this._window == null)
            {
                return;
            }
            var inspection:IWindowContainer =
                this._window.findChildByName("inspection_container")
                as IWindowContainer;
            if (inspection == null)
            {
                return;
            }
            var add:IWindow = inspection.findChildByName("add_var_btn");
            var remove:IWindow =
                inspection.findChildByName("delete_var_btn");
            var highlight:IWindow =
                inspection.findChildByName("highlight_wired_btn");
            if (add != null)
            {
                if (this._writePermission
                    && this.hasValidInspectedHolder()
                    && this._inspectedType != -10)
                {
                    add.enable();
                }
                else
                {
                    add.disable();
                }
            }
            var selected:WiredVariable =
                this._variablesById[this._selectedInspectionVariableId]
                as WiredVariable;
            if (remove != null)
            {
                if (this._writePermission && selected != null
                    && selected.canCreateAndDelete)
                {
                    remove.enable();
                }
                else
                {
                    remove.disable();
                }
            }
            if (highlight != null)
            {
                highlight.visible = this._inspectedType == 0;
                if (highlight.visible
                    && this._configuredWiredIds.length > 0)
                {
                    highlight.enable();
                }
                else
                {
                    highlight.disable();
                }
            }
        }

        private function onManageVariable(event:WindowMouseEvent):void
        {
            var variable:WiredVariable =
                this._variablesById[this._selectedVariableId]
                as WiredVariable;
            if (variable == null || variable.variableTarget != 1
                || !variable.isPersisted)
            {
                return;
            }
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.show(
                    variable.variableId, variable.variableName);
            }
        }

        private function onHighlightHolders(event:WindowMouseEvent):void
        {
            var variable:WiredVariable =
                this._variablesById[this._selectedVariableId]
                as WiredVariable;
            if (variable == null
                || (variable.variableTarget != 0
                    && variable.variableTarget != 1))
            {
                return;
            }
            this._holdersHighlighted = !this._holdersHighlighted;
            if (this._holdersHighlighted)
            {
                if (this._holderIds.length > 200)
                {
                    this._holdersHighlighted = false;
                    this._roomEvents.showWiredNotification(
                        "wiredmenu.variable_overview.highlight.error.too_many");
                    return;
                }
                this._holderHighlighter.show(
                    variable.variableTarget, this._holderIds);
            }
            else
            {
                this._holderHighlighter.clear();
            }
            IWindow(event.target).caption = this.loc(
                this._holdersHighlighted
                    ? "wiredmenu.variable_overview.unhighlight_holders"
                    : "wiredmenu.variable_overview.highlight_holders");
        }

        private function hasValidInspectedHolder():Boolean
        {
            return this._inspectionReady
                && ((this._inspectedType == 0 && this._inspectedId != 0)
                || (this._inspectedType == 1 && this._inspectedId > 0)
                || (this._inspectedType == -10 && this._inspectedId == 0));
        }

        private function onSettingChanged(event:WindowEvent):void
        {
            if (this._ignoreSettings)
            {
                return;
            }
            this._ignoreSettings = true;
            this.normalizePermissionCheckboxes();
            this._ignoreSettings = false;
            if (event.target.name.indexOf("preference_") == 0)
            {
                this.sendPreferences();
                return;
            }
            this._modifyMask = this.checkboxMask("modify", 1, 3);
            this._readMask = this.checkboxMask("read", 0, 3);
            this._roomEvents.send(new UpdateWiredRoomSettingsComposer(
                this._modifyMask, this._readMask, this._timezone));
        }

        private function checkboxMask(prefix:String, start:int, end:int):int
        {
            var mask:int = 0;
            for (var i:int = start; i <= end; i++)
            {
                var value:ICheckBoxWindow = this.checkbox(prefix + "_" + i + "_checkbox");
                if (value != null && value.Selected)
                {
                    mask |= 1 << i;
                }
            }
            return mask;
        }

        private function sendPreferences():void
        {
            this._menuButton = this.isChecked("preference_toolbar_checkbox");
            this._inspectButton = this.isChecked("preference_inspect_button_checkbox");
            this._playtest = this.isChecked("preference_playtest_checkbox");
            this._allNotifications =
                this.isChecked("preference_all_notifications_checkbox");
            this.applyRoomSessionPreferences();
            this._roomEvents.refreshWiredUiConsumers();
            this._roomEvents.send(new UpdateWiredPreferencesComposer(
                this._menuButton,
                this._inspectButton,
                this._playtest,
                this._whisperDisabled,
                this._allNotifications,
                this._uiStyle));
        }

        private function isChecked(name:String):Boolean
        {
            var value:ICheckBoxWindow = this.checkbox(name);
            return value != null && value.Selected;
        }

        private function normalizePermissionCheckboxes():void
        {
            var modifyTwo:ICheckBoxWindow = this.checkbox("modify_2_checkbox");
            var modifyThree:ICheckBoxWindow = this.checkbox("modify_3_checkbox");
            var readZero:ICheckBoxWindow = this.checkbox("read_0_checkbox");
            var readTwo:ICheckBoxWindow = this.checkbox("read_2_checkbox");
            var readThree:ICheckBoxWindow = this.checkbox("read_3_checkbox");
            if (modifyTwo != null && modifyTwo.Selected && modifyThree != null)
            {
                modifyThree.select();
            }
            if (readTwo != null && readTwo.Selected && readThree != null)
            {
                readThree.select();
            }
            if (readZero != null && readZero.Selected)
            {
                for (var i:int = 1; i <= 3; i++)
                {
                    var read:ICheckBoxWindow = this.checkbox("read_" + i + "_checkbox");
                    if (read != null)
                    {
                        read.select();
                    }
                }
            }
            for (i = 1; i <= 3; i++)
            {
                var modify:ICheckBoxWindow =
                    this.checkbox("modify_" + i + "_checkbox");
                read = this.checkbox("read_" + i + "_checkbox");
                if (modify != null && modify.Selected && read != null)
                {
                    read.select();
                }
            }
        }

        private function checkbox(name:String):ICheckBoxWindow
        {
            return this._window == null ? null :
                this._window.findChildByName(name) as ICheckBoxWindow;
        }

        private function onReload(event:WindowMouseEvent):void
        {
            if (this._writePermission)
            {
                this._roomEvents.send(new ReloadOrRollbackWiredRoomComposer(false));
            }
        }

        private function onRollback(event:WindowMouseEvent):void
        {
            if (this._writePermission)
            {
                this._roomEvents.windowManager.confirm(
                    "${wiredmenu.settings.room_state.roll_back}",
                    "${wiredmenu.settings.room_state.roll_back.warning}",
                    0, this.onRollbackConfirmation);
            }
        }

        private function onRollbackConfirmation(dialog:IConfirmDialog,
                                                event:WindowEvent):void
        {
            dialog.dispose();
            if (event.type == WindowEvent.WINDOW_EVENT_OK &&
                this._writePermission)
            {
                this._roomEvents.send(new ReloadOrRollbackWiredRoomComposer(true));
            }
        }

        private function onOpenLogs(event:WindowMouseEvent):void
        {
            if (this._logsWindow != null)
            {
                this._logsWindow.show();
            }
        }

        private function requestLogsPage(page:int, amount:int,
                                         level:int, source:int,
                                         query:String):void
        {
            this._roomEvents.send(new RequestWiredLogsComposer(
                page, amount, level, source, query));
        }

        private function requestUserVariablesPage(
            variableId:String, page:int, amount:int,
            sortFilter:int, userFilter:int):void
        {
            this._roomEvents.send(new RequestWiredUserVariablesComposer(
                variableId, page, amount, sortFilter, userFilter));
        }

        private function requestPermanentVariables(type:int, id:int):void
        {
            this._roomEvents.send(
                new RequestPermanentVariablesComposer(type, id));
        }

        private function mutatePermanentVariable(
            type:int, id:int, variableId:String,
            value:int, operation:int):void
        {
            this._roomEvents.send(new MutatePermanentVariableComposer(
                type, id, variableId, value, operation));
        }

        private function onClearErrors(event:WindowMouseEvent):void
        {
            if (this._writePermission)
            {
                this._roomEvents.send(new ClearWiredErrorsComposer());
            }
        }

        private function onPermissions(event:IMessageEvent):void
        {
            var parser:WiredMenuPermissionsParser =
                (event as WiredMenuPermissionsEvent).getParser();
            this._writePermission = parser.writePermission;
            this._readPermission = parser.readPermission;
            this._roomEvents.refreshWiredUiConsumers();
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.setCanModify(
                    this._writePermission);
            }
            if (!this._readPermission && this._window != null &&
                this._window.parent != null)
            {
                this.hide();
                this._roomEvents.showWiredNotification("wiredmenu.invalid_room.desc");
            }
            this.updateInspectionButtons();
            this.updateRoomSettingsPermission();
            this.updateChestButtons();
        }

        private function onRoomSettings(event:IMessageEvent):void
        {
            var parser:WiredMenuRoomSettingsParser =
                (event as WiredMenuRoomSettingsEvent).getParser();
            this._modifyMask = parser.modifyMask;
            this._readMask = parser.readMask;
            this._timezone = parser.timezone;
            if (this._window == null)
            {
                return;
            }
            this._ignoreSettings = true;
            this.applyMask("modify", 1, 3, this._modifyMask);
            this.applyMask("read", 0, 3, this._readMask);
            this.normalizePermissionCheckboxes();
            var picker:IDropMenuWindow =
                this._window.findChildByName("timezone_picker")
                as IDropMenuWindow;
            if (picker != null)
            {
                var timezoneIndex:int =
                    this._timezoneValues.indexOf(this._timezone);
                picker.selection = timezoneIndex < 0 ? 0 : timezoneIndex;
            }
            this._ignoreSettings = false;
        }

        private function updateRoomSettingsPermission():void
        {
            if (this._window == null)
            {
                return;
            }
            var settings:IWindow =
                this._window.findChildByName("room_settings_container");
            var canConfigure:Boolean = this._roomEvents.roomSession != null
                && (this._roomEvents.roomSession.isRoomOwner
                    || (this._roomEvents.sessionDataManager != null
                        && this._roomEvents.sessionDataManager
                            .isAnyRoomController));
            if (settings != null)
            {
                if (canConfigure)
                {
                    settings.enable();
                }
                else
                {
                    settings.disable();
                }
            }
        }

        private function applyMask(prefix:String, start:int, end:int, mask:int):void
        {
            for (var i:int = start; i <= end; i++)
            {
                var value:ICheckBoxWindow = this.checkbox(prefix + "_" + i + "_checkbox");
                if (value != null)
                {
                    if ((mask & (1 << i)) != 0) { value.select(); }
                    else { value.unselect(); }
                }
            }
        }

        private function onRoomStats(event:IMessageEvent):void
        {
            if (this._window == null) { return; }
            var parser:WiredMenuRoomStatsParser =
                (event as WiredMenuRoomStatsEvent).getParser();
            var usageColor:String = this.ratioColor(
                parser.executionCost, parser.executionCap, 0.3, 0.7);
            var floorColor:String = this.ratioColor(
                parser.floorCount, parser.floorCap, 0.6, 0.85);
            var wallColor:String = this.ratioColor(
                parser.wallCount, parser.wallCap, 0.6, 0.85);
            this.setText("statistics_usage_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.usage", "",
                    "color", usageColor,
                    "amount", parser.executionCost.toFixed(0),
                    "limit", parser.executionCap.toFixed(0)));
            this.setText("statistics_heavy_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.is_heavy", "",
                    "color", parser.heavy ? COLOR_ORANGE : COLOR_GREEN,
                    "bool", this.loc(parser.heavy
                        ? "wiredmenu.bool.yes" : "wiredmenu.bool.no")));
            this.setText("statistics_floorfurni_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.floorfurni", "",
                    "color", floorColor, "amount", parser.floorCount,
                    "limit", parser.floorCap));
            this.setText("statistics_wallfurni_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.wallfurni", "",
                    "color", wallColor, "amount", parser.wallCount,
                    "limit", parser.wallCap));
            this.setText("statistics_perm_vars_user_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.perm_user_vars", "",
                    "color", this.ratioColor(parser.permanentUserCount,
                        parser.permanentUserCap, 0.5, 0.8),
                    "amount", parser.permanentUserCount,
                    "limit", parser.permanentUserCap));
            this.setText("statistics_perm_vars_furni_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.perm_furni_vars", "",
                    "color", this.ratioColor(parser.permanentFurniCount,
                        parser.permanentFurniCap, 0.5, 0.8),
                    "amount", parser.permanentFurniCount,
                    "limit", parser.permanentFurniCap));
            this.setText("statistics_perm_vars_global_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.perm_global_vars", "",
                    "color", this.ratioColor(parser.permanentGlobalCount,
                        parser.permanentGlobalCap, 0.5, 0.8),
                    "amount", parser.permanentGlobalCount,
                    "limit", parser.permanentGlobalCap));
            this._monitorHeavy = parser.heavy;
            this._monitorOverThreshold =
                usageColor != COLOR_GREEN
                || floorColor != COLOR_GREEN
                || wallColor != COLOR_GREEN;
            this.updateMonitorImage(
                this._monitorHeavy, this._monitorOverThreshold);
        }

        private function ratioColor(value:Number, limit:Number,
                                    lower:Number, upper:Number):String
        {
            var ratio:Number = limit <= 0 ? 0 : value / limit;
            if (ratio < lower)
            {
                return COLOR_GREEN;
            }
            if (ratio < upper)
            {
                return COLOR_ORANGE;
            }
            return COLOR_RED;
        }

        private function updateMonitorImage(heavy:Boolean,
                                            overThreshold:Boolean):void
        {
            var panicking:Boolean = heavy || overThreshold
                || (this._errorTable != null
                    && this._errorTable.rowCount > 0);
            var calm:IWindow =
                this._window.findChildByName("monitor_image_1");
            var panic:IWindow =
                this._window.findChildByName("monitor_image_2");
            if (calm != null)
            {
                calm.visible = !panicking;
            }
            if (panic != null)
            {
                panic.visible = panicking;
            }
        }

        private function onErrors(event:IMessageEvent):void
        {
            if (this._window == null) { return; }
            var parser:WiredMenuErrorsParser =
                (event as WiredMenuErrorsEvent).getParser();
            var rows:Vector.<ITableObject> = new Vector.<ITableObject>();
            for each (var error:Object in parser.errors)
            {
                rows.push(new WiredMenuErrorTableObject(
                    error, this.formatElapsed(Number(error.elapsed)),
                    this.openErrorInfo));
            }
            if (this._errorTable != null)
            {
                this._errorTable.setObjects(rows);
            }
            this.updateMonitorImage(
                this._monitorHeavy, this._monitorOverThreshold);
        }

        private function onErrorSelected(row:ITableObject):void
        {
            var item:WiredMenuErrorTableObject =
                row as WiredMenuErrorTableObject;
            if (item != null)
            {
                this.openErrorInfo(item.data);
            }
        }

        private function openErrorInfo(error:Object):void
        {
            if (error != null && this._errorInfoWindow != null)
            {
                this._errorInfoWindow.show(error);
            }
        }

        private function onLogs(event:IMessageEvent):void
        {
            var parser:WiredMenuLogsPageParser =
                (event as WiredMenuLogsPageEvent).getParser();
            if (this._logsWindow != null)
            {
                this._logsWindow.applyPage(parser);
            }
        }

        private function onVariableHolders(event:IMessageEvent):void
        {
            if (this._window == null) { return; }
            var data:VariableInfoAndHolders =
                (event as WiredMenuVariableHoldersEvent).getParser().data;
            if (data == null || data.variable == null
                || data.variable.variableId != this._requestedVariableId)
            {
                return;
            }
            var variable:WiredVariable = data.variable;
            var properties:Vector.<ITableObject> = new Vector.<ITableObject>();
            properties.push(this.property("name", this.loc(
                "wiredmenu.variable_overview.properties.name"),
                variable.variableName));
            properties.push(this.property("type", this.loc(
                "wiredmenu.variable_overview.properties.type"),
                this.loc("wiredfurni.params.variables.idtype."
                    + variable.variableType)));
            properties.push(this.property("target", this.loc(
                "wiredmenu.variable_overview.properties.target"),
                this.targetName(variable.variableTarget)));
            properties.push(this.property("availability", this.loc(
                "wiredmenu.variable_overview.properties.availability"),
                this._roomEvents.localization.getLocalization(
                    "wiredfurni.params.variables.availability."
                        + variable.availabilityType,
                    this.loc(
                        "wiredfurni.params.variables.availability.misc"))));
            this.addBooleanProperty(properties, "has_value",
                variable.hasValue);
            this.addBooleanProperty(properties, "can_write_to",
                variable.canWriteValue);
            this.addBooleanProperty(properties, "can_create_delete",
                variable.canCreateAndDelete);
            this.addBooleanProperty(properties, "can_intercept",
                variable.canInterceptChanges);
            this.addBooleanProperty(properties, "is_always_available",
                variable.alwaysAvailable);
            this.addBooleanProperty(properties, "can_read_creation_time",
                variable.canReadCreationTime);
            this.addBooleanProperty(properties, "can_read_last_update_time",
                variable.canReadLastUpdateTime);
            this.addBooleanProperty(properties, "is_text_connected",
                variable.hasTextConnector);
            if (this._propertyTable != null)
            {
                this._propertyTable.setObjects(properties, true);
            }
            var values:Vector.<ITableObject> = new Vector.<ITableObject>();
            if (variable.hasTextConnector)
            {
                var keys:Array = variable.textConnector.getKeys();
                for each (var key:Object in keys)
                {
                    values.push(new WiredMenuTableObject(String(key), {
                        value:String(key),
                        text:String(variable.textConnector.getValue(key))
                    }));
                }
            }
            if (this._textTable != null)
            {
                this._textTable.setObjects(values, true);
            }
            this._holderIds = [];
            for each (var holder:ObjectIdAndValuePair in data.holders)
            {
                this._holderIds.push(holder.objectId);
            }
            this.updateOverviewButtons(variable);
        }

        private function addBooleanProperty(
            rows:Vector.<ITableObject>, id:String, value:Boolean):void
        {
            rows.push(this.property(id, this.loc(
                "wiredmenu.variable_overview.properties." + id),
                this.loc(value ? "wiredmenu.bool.yes" : "wiredmenu.bool.no")));
        }

        private function targetName(target:int):String
        {
            if (target == 0)
            {
                return this.loc("wiredfurni.params.sourcetype.furni");
            }
            if (target == 1)
            {
                return this.loc("wiredfurni.params.sourcetype.users");
            }
            if (target == -10)
            {
                return this.loc("wiredfurni.params.sourcetype.global");
            }
            if (target == -20)
            {
                return this.loc("wiredfurni.params.sourcetype.context");
            }
            return "";
        }

        private function updateOverviewButtons(variable:WiredVariable):void
        {
            var overview:IWindowContainer =
                this._window.findChildByName("variable_overview_container")
                as IWindowContainer;
            if (overview == null)
            {
                return;
            }
            var highlight:IWindow =
                overview.findChildByName("highlight_holders_button");
            if (highlight != null)
            {
                if (variable.variableType != 1
                    && (variable.variableTarget == 0
                        || variable.variableTarget == 1))
                {
                    highlight.enable();
                }
                else
                {
                    highlight.disable();
                }
                highlight.caption = this.loc(
                    "wiredmenu.variable_overview.highlight_holders");
            }
            var manage:IWindow = overview.findChildByName("manage_button");
            if (manage != null)
            {
                if (variable.variableTarget == 1 && variable.isPersisted)
                {
                    manage.enable();
                }
                else
                {
                    manage.disable();
                }
            }
        }

        private function onUserVariables(event:IMessageEvent):void
        {
            var parser:WiredMenuUserVariablesPageParser =
                (event as WiredMenuUserVariablesPageEvent).getParser();
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.applyPage(parser);
            }
        }

        private function onPermanentVariables(event:IMessageEvent):void
        {
            var parser:WiredMenuPermanentVariablesParser =
                (event as WiredMenuPermanentVariablesEvent).getParser();
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.applyDetails(parser);
            }
        }

        private function onInspection(event:IMessageEvent):void
        {
            if (this._window != null && this._activeTab == INSPECTION)
            {
                var parser:WiredMenuInspectionParser =
                    (event as WiredMenuInspectionEvent).getParser();
                var holderChanged:Boolean =
                    !this._inspectionReady
                    || this._inspectedType != parser.type
                    || this._inspectedId != parser.objectId;
                this._inspectedType = parser.type;
                this._inspectedId = parser.objectId;
                this._inspectionReady = true;
                if (holderChanged && this._wiredIdsHighlighted
                    && this._holderHighlighter != null)
                {
                    this._holderHighlighter.clear();
                }
                if (holderChanged)
                {
                    this._wiredIdsHighlighted = false;
                }
                this._configuredWiredIds =
                    parser.wiredIds == null ? [] :
                    parser.wiredIds.concat();
                var inspection:IWindowContainer =
                    this._window.findChildByName("inspection_container")
                    as IWindowContainer;
                this.setTypePickerState(inspection, parser.type);
                var rows:Vector.<ITableObject> = new Vector.<ITableObject>();
                this._inspectionExisting = {};
                if (holderChanged)
                {
                    this._selectedInspectionVariableId = null;
                }
                for each (var value:Object in parser.values)
                {
                    this._inspectionExisting[value.id] = true;
                    var variable:WiredVariable =
                        this._variablesById[value.id] as WiredVariable;
                    if (variable != null)
                    {
                        rows.push(new WiredMenuInspectionTableObject(
                            variable, int(value.value),
                            this._writePermission, !holderChanged,
                            this._roomEvents));
                    }
                }
                if (this._selectedInspectionVariableId != null
                    && !this._inspectionExisting[
                        this._selectedInspectionVariableId])
                {
                    this._selectedInspectionVariableId = null;
                }
                if (this._inspectionTable != null)
                {
                    this._inspectionTable.setObjects(rows, holderChanged);
                }
                this.populateInspectionVariablePicker();
                this.updateInspectionPreview();
                this.updateInspectionButtons();
            }
        }

        private function onInspectionCellEdited(row:ITableObject, column:String,
                                                input:String):void
        {
            if (!this._writePermission || column != "value" ||
                !this.hasValidInspectedHolder() ||
                input == null || !/^-?\d+$/.test(input))
            {
                return;
            }
            var parsed:Number = Number(input);
            if (parsed < -2147483648 || parsed > 2147483647)
            {
                return;
            }
            var item:WiredMenuInspectionTableObject =
                row as WiredMenuInspectionTableObject;
            if (item == null || item.variable == null)
            {
                return;
            }
            this._roomEvents.send(new ModifyInspectedVariableComposer(
                this._inspectedType, this._inspectedId,
                item.variable.variableId, int(parsed), 0));
        }

        private function property(id:String, label:String,
                                  value:String):WiredMenuTableObject
        {
            return new WiredMenuTableObject(id,
                {property:label, value:value});
        }

        private function formatElapsed(milliseconds:Number):String
        {
            if (milliseconds < 0)
            {
                return "/";
            }
            if (milliseconds < 1000)
            {
                return int(milliseconds) + "ms";
            }
            if (milliseconds < 60000)
            {
                return int(milliseconds / 1000) + "s ago";
            }
            return int(milliseconds / 60000) + "m ago";
        }

        private function onMutation(event:IMessageEvent):void
        {
            var parser:WiredMenuMutationResultParser =
                (event as WiredMenuMutationResultEvent).getParser();
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.onMutationResult(
                    parser.success);
            }
            if (!parser.success)
            {
                this._roomEvents.showWiredNotification(
                    "wiredmenu.variable_management_detail.notification.modification_failed");
            }
        }

        private function onInspectionError(event:IMessageEvent):void
        {
            var parser:WiredMenuErrorParser =
                (event as WiredMenuErrorEvent).getParser();
            if (parser.errorCode == 0)
            {
                this._inspectedId = this._inspectedType == -10 ? 0 : -1;
                this._inspectionReady = false;
                this._inspectionExisting = {};
                this._selectedInspectionVariableId = null;
                if (this._inspectionTable != null)
                {
                    this._inspectionTable.clear();
                }
                this.updateInspectionPreview();
                this.updateInspectionButtons();
            }
            else
            {
                this._roomEvents.showWiredNotification(
                    "wiredmenu.variable_management.update.error");
            }
        }

        private function onAccountPreferences(event:IMessageEvent):void
        {
            var parser:AccountPreferencesParser =
                (event as AccountPreferencesEvent).getParser();
            this._menuButton = parser.wiredMenuButton;
            this._inspectButton = parser.wiredInspectButton;
            this._playtest = parser.playTestMode;
            this._whisperDisabled = parser.wiredWhisperDisabled;
            this._allNotifications = parser.showAllNotifications;
            this._uiStyle = parser.wiredUiStyle;
            this.applyPreferences();
            this._roomEvents.refreshWiredUiConsumers();
        }

        public function get wiredMenuButton():Boolean
        {
            return this._menuButton;
        }

        public function get wiredInspectButton():Boolean
        {
            return this._inspectButton;
        }

        public function get hasReadPermission():Boolean
        {
            return this._readPermission;
        }

        public function get hasWritePermission():Boolean
        {
            return this._writePermission;
        }

        private function applyPreferences():void
        {
            this.applyRoomSessionPreferences();
            if (this._window == null) { return; }
            this._ignoreSettings = true;
            this.setChecked("preference_toolbar_checkbox", this._menuButton);
            this.setChecked("preference_inspect_button_checkbox", this._inspectButton);
            this.setChecked("preference_playtest_checkbox", this._playtest);
            this.setChecked("preference_all_notifications_checkbox",
                this._allNotifications);
            var picker:IDropMenuWindow =
                this._window.findChildByName("wired_style_picker")
                as IDropMenuWindow;
            if (picker != null)
            {
                var index:int =
                    this._wiredStyleValues.indexOf(this._uiStyle);
                picker.selection = index < 0 ? 0 : index;
            }
            this._ignoreSettings = false;
        }

        public function applyRoomSessionPreferences():void
        {
            if (this._roomEvents != null
                && this._roomEvents.roomSession != null)
            {
                this._roomEvents.roomSession.playTestMode =
                    this._playtest;
            }
        }

        private function setChecked(name:String, selected:Boolean):void
        {
            var checkbox:ICheckBoxWindow = this.checkbox(name);
            if (checkbox != null)
            {
                if (selected) { checkbox.select(); } else { checkbox.unselect(); }
            }
        }

        private function setText(name:String, value:String):void
        {
            var text:ITextWindow = this._window.findChildByName(name) as ITextWindow;
            if (text != null) { text.text = value; }
        }

        /**
         * July uses its newer table framework.  The clean client does not have
         * that framework, so bounded text rows are cloned from a native text
         * control. This preserves fonts/styles and avoids trusting packet text
         * as XML or HTML.
         */
        private function renderLines(containerName:String, lines:Array,
                                     emptyKey:String):void
        {
            var container:IWindowContainer =
                this._window.findChildByName(containerName) as IWindowContainer;
            var template:ITextWindow =
                this._window.findChildByName("preview_instruction_user")
                as ITextWindow;
            if (container == null || template == null) { return; }
            while (container.numChildren > 0)
            {
                container.removeChildAt(0).dispose();
            }
            if (lines.length == 0 && emptyKey != null)
            {
                lines = [this._roomEvents.localization.getLocalization(
                    emptyKey, "—")];
            }
            var maximum:int = Math.min(lines.length, 100);
            for (var i:int = 0; i < maximum; i++)
            {
                var row:ITextWindow = template.clone() as ITextWindow;
                row.name = "wired_menu_row_" + i;
                row.visible = true;
                row.x = 2;
                row.y = i * 18;
                row.width = Math.max(20, container.width - 4);
                row.height = 18;
                row.text = String(lines[i]);
                container.addChild(row);
            }
        }

        private function onClose(event:WindowMouseEvent):void
        {
            this.hide();
        }

        public function inspectUser(id:int):void
        {
            if (!(this._inspectionPinned && this._inspectionReady)
                && this._window != null && this._window.parent != null &&
                this._activeTab == INSPECTION
                && this._inspectedType == 1)
            {
                var inspection:IWindowContainer =
                    this._window.findChildByName("inspection_container")
                    as IWindowContainer;
                this.setTypePickerState(inspection, 1);
                this._inspectedId = id;
                this._inspectionReady = false;
                this.updateInspectionPreview();
                this._roomEvents.send(new InspectWiredObjectComposer(1, id));
            }
        }

        public function inspectFurni(id:int):void
        {
            if (!(this._inspectionPinned && this._inspectionReady)
                && id != 0 && this._window != null &&
                this._window.parent != null && this._activeTab == INSPECTION
                && this._inspectedType == 0)
            {
                var inspection:IWindowContainer =
                    this._window.findChildByName("inspection_container")
                    as IWindowContainer;
                this.setTypePickerState(inspection, 0);
                this._inspectedId = id;
                this._inspectionReady = false;
                this.updateInspectionPreview();
                this._roomEvents.send(new InspectWiredObjectComposer(0, id));
            }
        }

        public function get activeTab():String
        {
            return this._activeTab;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this.hide();
            if (this._holderHighlighter != null)
            {
                this._holderHighlighter.dispose();
                this._holderHighlighter = null;
            }
            if (this._monitorTimer != null)
            {
                this._monitorTimer.stop();
                this._monitorTimer.removeEventListener(
                    TimerEvent.TIMER, this.onMonitorPoll);
                this._monitorTimer = null;
            }
            if (this._overviewTimer != null)
            {
                this._overviewTimer.stop();
                this._overviewTimer.removeEventListener(
                    TimerEvent.TIMER, this.onOverviewPoll);
                this._overviewTimer = null;
            }
            if (this._inspectionTimer != null)
            {
                this._inspectionTimer.stop();
                this._inspectionTimer.removeEventListener(
                    TimerEvent.TIMER, this.onInspectionPoll);
                this._inspectionTimer = null;
            }
            if (this._chestTimer != null)
            {
                this._chestTimer.stop();
                this._chestTimer.removeEventListener(
                    TimerEvent.TIMER, this.onChestPoll);
                this._chestTimer = null;
            }
            if (this._chestLockTimer != null)
            {
                this._chestLockTimer.stop();
                this._chestLockTimer.removeEventListener(
                    TimerEvent.TIMER_COMPLETE, this.onChestLockTimeout);
                this._chestLockTimer = null;
            }
            if (this._logsWindow != null)
            {
                this._logsWindow.dispose();
                this._logsWindow = null;
            }
            if (this._errorInfoWindow != null)
            {
                this._errorInfoWindow.dispose();
                this._errorInfoWindow = null;
            }
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.dispose();
                this._variableManagementWindow = null;
            }
            if (this._inspectionPreviewer != null)
            {
                this._inspectionPreviewer.dispose();
                this._inspectionPreviewer = null;
            }
            this.disposeTable(this._errorTable);
            this.disposeTable(this._variableListTable);
            this.disposeTable(this._propertyTable);
            this.disposeTable(this._textTable);
            this.disposeTable(this._inspectionTable);
            this.disposeTable(this._chestTransactionsTable);
            this._errorTable = null;
            this._variableListTable = null;
            this._propertyTable = null;
            this._textTable = null;
            this._inspectionTable = null;
            this._chestTransactionsTable = null;
            this._chestTransactions = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._roomEvents != null && this._roomEvents.communication != null)
            {
                for each (var event:IMessageEvent in this._messageEvents)
                {
                    this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
                }
            }
            this._messageEvents = null;
            this._roomEvents = null;
            this._disposed = true;
        }

        private function disposeTable(table:TableView):void
        {
            if (table != null && !table.disposed)
            {
                table.dispose();
            }
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }
    }
}
