package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;
    import flash.ui.Keyboard;

    /**
     * Dedicated July-style management flow for persisted user variables.
     * The parent controller remains responsible for sending packet composers.
     */
    public final class WiredMenuVariableManagementWindow implements IDisposable
    {
        private static const PAGE_SIZE:int = 50;
        private static const USER_FILTERS:Array = [-1, 1, 2, 4];

        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _requestPageCallback:Function;
        private var _requestDetailsCallback:Function;
        private var _mutationCallback:Function;
        private var _overview:IFrameWindow;
        private var _detail:IFrameWindow;
        private var _overviewTable:TableView;
        private var _detailTable:TableView;
        private var _detailPreviewer:WiredMenuPermanentVariablePreviewer;
        private var _createPicker:IDropMenuWindow;
        private var _creatableVariables:Array = [];
        private var _availableCreateVariables:Array = [];
        private var _selectedDetail:WiredMenuTableObject;
        private var _variableId:String;
        private var _variableName:String;
        private var _page:int = 1;
        private var _total:int;
        private var _detailType:int;
        private var _detailId:int;
        private var _detailEntries:Array = [];
        private var _canModify:Boolean;
        private var _disposed:Boolean;

        public function WiredMenuVariableManagementWindow(
            roomEvents:HabboUserDefinedRoomEvents,
            requestPageCallback:Function,
            requestDetailsCallback:Function,
            mutationCallback:Function)
        {
            this._roomEvents = roomEvents;
            this._requestPageCallback = requestPageCallback;
            this._requestDetailsCallback = requestDetailsCallback;
            this._mutationCallback = mutationCallback;
        }

        public function setCreatableVariables(variables:Array):void
        {
            this._creatableVariables = variables == null ? [] : variables.concat();
            this.populateCreatePicker();
        }

        public function setCanModify(value:Boolean):void
        {
            this._canModify = value;
            this.updateDetailButtons();
        }

        public function show(variableId:String, variableName:String=null):void
        {
            this.ensureOverview();
            if (this._overview == null)
            {
                return;
            }
            this._variableId = variableId == null ? "" : variableId;
            this._variableName =
                variableName == null || variableName.length == 0
                    ? this._variableId : variableName;
            var label:ITextWindow =
                this._overview.findChildByName("variable_name_value") as ITextWindow;
            if (label != null)
            {
                label.text = this._variableName;
            }
            this._overview.visible = true;
            this._overview.activate();
            this.requestPage(1);
        }

        public function applyPage(parser:Object):void
        {
            if (parser == null || String(parser.variableId) != this._variableId)
            {
                return;
            }
            this.ensureOverview();
            this._total = Math.max(0, int(parser.total));
            this._page = Math.max(1, int(parser.page));
            var rows:Vector.<ITableObject> = new Vector.<ITableObject>();
            var entry:Object;
            var index:int;
            for each (entry in parser.entries)
            {
                rows.push(new WiredMenuTableObject(
                    "holder_" + entry.type + "_" + entry.id + "_" + index++, {
                        "name": entry.name,
                        "usertype": this.loc("wiredmenu.variable_management.usertype." +
                            entry.type, String(entry.type)),
                        "value": entry.value,
                        "creation_time": entry.createdText,
                        "last_update_time": entry.updatedText,
                        "manage": this.loc(
                            "wiredmenu.variable_management.manage", "Manage")
                    }, entry));
            }
            if (this._overviewTable != null)
            {
                this._overviewTable.setObjects(rows, true);
            }
            this.applyResponseFilters(parser);
            this.updatePagination();
        }

        public function applyDetails(parser:Object):void
        {
            if (parser == null)
            {
                return;
            }
            this.ensureDetail();
            this._detailType = int(parser.type);
            this._detailId = int(parser.id);
            this._detailEntries =
                parser.entries == null ? [] : parser.entries.concat();
            this._selectedDetail = null;
            this.renderDetailInfo(parser);
            this.renderDetailPreview(parser);
            var rows:Vector.<ITableObject> = new Vector.<ITableObject>();
            var entry:Object;
            for each (entry in this._detailEntries)
            {
                var editable:TableCell = new TableCell(TableCell.TYPE_TEXT,
                    String(entry.value), this._canModify, false,
                    String(entry.value));
                rows.push(new WiredMenuTableObject("value_" + entry.variableId, {
                    "variable": entry.variableId,
                    "value": editable,
                    "created": entry.createdText,
                    "updated": entry.updatedText
                }, entry));
            }
            if (this._detailTable != null)
            {
                this._detailTable.setObjects(rows, true);
            }
            this.populateCreatePicker();
            this.updateDetailButtons();
            this._detail.visible = true;
            this._detail.activate();
        }

        public function onMutationResult(success:Boolean):void
        {
            if (success && this._requestDetailsCallback != null &&
                this._detail != null && this._detail.visible)
            {
                this._requestDetailsCallback(this._detailType, this._detailId);
            }
        }

        public function close():void
        {
            if (this._overview != null) this._overview.visible = false;
            if (this._detail != null) this._detail.visible = false;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            if (this._overviewTable != null)
            {
                this._overviewTable.dispose();
                this._overviewTable = null;
            }
            if (this._detailTable != null)
            {
                this._detailTable.dispose();
                this._detailTable = null;
            }
            if (this._detailPreviewer != null)
            {
                this._detailPreviewer.dispose();
                this._detailPreviewer = null;
            }
            if (this._overview != null)
            {
                this._overview.dispose();
                this._overview = null;
            }
            if (this._detail != null)
            {
                this._detail.dispose();
                this._detail = null;
            }
            this._roomEvents = null;
            this._requestPageCallback = null;
            this._requestDetailsCallback = null;
            this._mutationCallback = null;
            this._creatableVariables = null;
            this._availableCreateVariables = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        private function ensureOverview():void
        {
            if (this._overview != null || this._disposed)
            {
                return;
            }
            this._overview = this._roomEvents.getXmlWindow(
                "wired_menu_variables_management_overview") as IFrameWindow;
            if (this._overview == null)
            {
                return;
            }
            this._roomEvents.windowManager.getDesktop(1).addChild(this._overview);
            this._overview.center();
            this.bindClose(this._overview, this.onOverviewClose);
            this.bindClick(this._overview, "refresh_btn", this.onRefresh);
            this.bindClick(this._overview, "first_page_btn", this.onFirstPage);
            this.bindClick(this._overview, "prev_page_btn", this.onPreviousPage);
            this.bindClick(this._overview, "next_page_btn", this.onNextPage);
            this.bindClick(this._overview, "last_page_btn", this.onLastPage);
            var userType:IDropMenuWindow =
                this._overview.findChildByName("user_type_menu") as IDropMenuWindow;
            var sortType:IDropMenuWindow =
                this._overview.findChildByName("sort_type_menu") as IDropMenuWindow;
            if (userType != null)
            {
                userType.selection = 0;
                userType.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onOverviewFilterChanged);
            }
            if (sortType != null)
            {
                sortType.selection = 0;
                sortType.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onOverviewFilterChanged);
            }
            var pageInput:ITextFieldWindow =
                this._overview.findChildByName("pagina_number_input") as ITextFieldWindow;
            if (pageInput != null)
            {
                pageInput.restrict = "0-9";
                pageInput.maxChars = 6;
                pageInput.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN,
                    this.onPageKey);
            }
            this._overviewTable = this.createTable(this._overview, "table_view",
                new <TableColumn>[
                    new TableColumn("usertype", this.loc(
                        "wiredmenu.variable_management.col.usertype", "User type"), 0.10, "left"),
                    new TableColumn("name", this.loc(
                        "wiredmenu.variable_management.col.name", "Name"), 0.18, "left"),
                    new TableColumn("creation_time", this.loc(
                        "wiredmenu.variable_management.col.creation_time",
                        "Creation time"), 0.21, "left"),
                    new TableColumn("last_update_time", this.loc(
                        "wiredmenu.variable_management.col.last_update_time",
                        "Last update time"), 0.21, "left"),
                    new TableColumn("value", this.loc(
                        "wiredmenu.variable_management.col.value", "Value"), 0.18, "right"),
                    new TableColumn("manage", this.loc(
                        "wiredmenu.variable_management.col.manage", "Manage"), 0.12, "left")
                ], true);
            if (this._overviewTable != null)
            {
                this._overviewTable.onRowClickedCallback = this.onOverviewRowClicked;
            }
        }

        private function ensureDetail():void
        {
            if (this._detail != null || this._disposed)
            {
                return;
            }
            this._detail = this._roomEvents.getXmlWindow(
                "wired_menu_variables_management_detail") as IFrameWindow;
            if (this._detail == null)
            {
                return;
            }
            this._roomEvents.windowManager.getDesktop(1).addChild(this._detail);
            this._detail.center();
            var preview:IWindowContainer =
                this._detail.findChildByName("preview") as IWindowContainer;
            if (preview != null)
            {
                this._detailPreviewer =
                    new WiredMenuPermanentVariablePreviewer(
                        preview, this._roomEvents);
            }
            this.bindClose(this._detail, this.onDetailClose);
            this.bindClick(this._detail, "refresh_btn", this.onDetailRefresh);
            this.bindClick(this._detail, "add_var_btn", this.onAdd);
            this.bindClick(this._detail, "delete_var_btn", this.onDelete);
            this.bindClick(this._detail, "create_var_btn", this.onCreate);
            this._detailTable = this.createTable(this._detail,
                "variable_values_table_container", new <TableColumn>[
                    new TableColumn("variable", this.loc(
                        "wiredmenu.inspection.variables.variable", "Variable"), 0.34, "left"),
                    new TableColumn("value", this.loc(
                        "wiredmenu.inspection.variables.value", "Value"), 0.16, "right"),
                    new TableColumn("created", this.loc(
                        "wiredmenu.variable_management.col.creation_time",
                        "Creation time"), 0.25, "left"),
                    new TableColumn("updated", this.loc(
                        "wiredmenu.variable_management.col.last_update_time",
                        "Last update time"), 0.25, "left")
                ], true);
            if (this._detailTable != null)
            {
                this._detailTable.onRowSelectedCallback = this.onDetailRowSelected;
                this._detailTable.onCellEditCallback = this.onDetailCellEdited;
            }
            var input:ITextFieldWindow =
                this._detail.findChildByName("value_input") as ITextFieldWindow;
            if (input != null)
            {
                input.restrict = "0-9\\-";
                input.maxChars = 11;
            }
            this.createVariablePicker();
            this.setBubbleVisible(false);
        }

        private function createTable(window:IFrameWindow, containerName:String,
                                     columns:Vector.<TableColumn>,
                                     selectable:Boolean):TableView
        {
            var parent:IWindowContainer =
                window.findChildByName(containerName) as IWindowContainer;
            var asset:XmlAsset =
                this._roomEvents.assets.getAssetByName("table_view_xml") as XmlAsset;
            if (parent == null || asset == null)
            {
                return null;
            }
            var table:TableView = new TableView(this._roomEvents.windowManager,
                parent, true, false, asset);
            table.initialize(columns, true, selectable);
            return table;
        }

        private function createVariablePicker():void
        {
            if (this._createPicker != null || this._overview == null ||
                this._detail == null)
            {
                return;
            }
            var template:IDropMenuWindow =
                this._overview.findChildByName("user_type_menu") as IDropMenuWindow;
            var parent:IWindowContainer =
                this._detail.findChildByName("var_picker_container") as IWindowContainer;
            if (template == null || parent == null)
            {
                return;
            }
            this._createPicker = template.clone() as IDropMenuWindow;
            this._createPicker.name = "create_variable_picker";
            this._createPicker.x = 0;
            this._createPicker.y = 0;
            this._createPicker.width = parent.width;
            parent.addChild(this._createPicker);
        }

        private function populateCreatePicker():void
        {
            if (this._detail == null)
            {
                return;
            }
            this.createVariablePicker();
            if (this._createPicker == null)
            {
                return;
            }
            var existing:Object = {};
            var entry:Object;
            for each (entry in this._detailEntries)
            {
                existing[String(entry.variableId)] = true;
            }
            this._availableCreateVariables = [];
            var labels:Array = [];
            var variable:Object;
            for each (variable in this._creatableVariables)
            {
                var id:String = String(variable.id);
                if (!existing[id])
                {
                    this._availableCreateVariables.push(variable);
                    labels.push(variable.name == null ? id : String(variable.name));
                }
            }
            this._createPicker.populate(labels);
            this._createPicker.selection = labels.length == 0 ? -1 : 0;
            this.updateDetailButtons();
        }

        private function renderDetailInfo(parser:Object):void
        {
            var info:ITextFieldWindow =
                this._detail.findChildByName("info_box_text") as ITextFieldWindow;
            if (info != null)
            {
                var key:String;
                if (int(parser.type) == 1)
                {
                    key = "wiredmenu.variable_management_detail.info.user";
                    info.text = this._roomEvents.localization
                        .getLocalizationWithParams(key, "",
                            "name", String(parser.name),
                            "id", String(parser.id));
                }
                else
                {
                    key = int(parser.type) == 2
                        ? "wiredmenu.variable_management_detail.info.pet"
                        : "wiredmenu.variable_management_detail.info.bot";
                    info.text = this._roomEvents.localization
                        .getLocalizationWithParams(key, "",
                            "name", String(parser.name),
                            "id", String(parser.id),
                            "owner_name", String(parser.ownerName),
                            "owner_id", String(parser.ownerId));
                }
            }
        }

        private function renderDetailPreview(parser:Object):void
        {
            if (this._detailPreviewer == null)
            {
                return;
            }
            if (int(parser.type) == 2)
            {
                this._detailPreviewer.showPet(String(parser.figure));
            }
            else
            {
                this._detailPreviewer.showUser(
                    String(parser.figure), int(parser.id));
            }
        }

        private function requestPage(page:int):void
        {
            if (this._requestPageCallback == null || this._overview == null)
            {
                return;
            }
            var userType:IDropMenuWindow =
                this._overview.findChildByName("user_type_menu") as IDropMenuWindow;
            var sortType:IDropMenuWindow =
                this._overview.findChildByName("sort_type_menu") as IDropMenuWindow;
            var userSelection:int = userType == null ? 0 :
                Math.max(0, Math.min(USER_FILTERS.length - 1, userType.selection));
            this._requestPageCallback(this._variableId, Math.max(1, page),
                PAGE_SIZE,
                sortType == null ? 0 : Math.max(0, sortType.selection),
                USER_FILTERS[userSelection]);
        }

        private function applyResponseFilters(parser:Object):void
        {
            var userType:IDropMenuWindow =
                this._overview.findChildByName("user_type_menu") as IDropMenuWindow;
            var sortType:IDropMenuWindow =
                this._overview.findChildByName("sort_type_menu") as IDropMenuWindow;
            var userIndex:int = USER_FILTERS.indexOf(int(parser.userFilter));
            if (userType != null) userType.selection = Math.max(0, userIndex);
            if (sortType != null) sortType.selection = Math.max(0, int(parser.sortFilter));
        }

        private function updatePagination():void
        {
            var pages:int = Math.max(1, Math.ceil(this._total / PAGE_SIZE));
            this._page = Math.min(Math.max(1, this._page), pages);
            var start:ITextWindow =
                this._overview.findChildByName("pagina_text_start") as ITextWindow;
            var end:ITextWindow =
                this._overview.findChildByName("pagina_text_end") as ITextWindow;
            var input:ITextFieldWindow =
                this._overview.findChildByName("pagina_number_input") as ITextFieldWindow;
            if (start != null)
                start.text = this._total + " users found. Showing page";
            if (input != null) input.text = String(this._page);
            if (end != null) end.text = "of " + pages;
            this.setEnabled(this._overview, "first_page_btn", this._page > 1);
            this.setEnabled(this._overview, "prev_page_btn", this._page > 1);
            this.setEnabled(this._overview, "next_page_btn", this._page < pages);
            this.setEnabled(this._overview, "last_page_btn", this._page < pages);
        }

        private function updateDetailButtons():void
        {
            if (this._detail == null)
            {
                return;
            }
            this.setEnabled(this._detail, "delete_var_btn",
                this._canModify && this._selectedDetail != null);
            this.setEnabled(this._detail, "add_var_btn",
                this._canModify && this._availableCreateVariables.length > 0);
            this.setEnabled(this._detail, "create_var_btn",
                this._canModify && this._availableCreateVariables.length > 0);
        }

        private function mutate(variableId:String, value:int, operation:int):void
        {
            if (this._canModify && this._mutationCallback != null &&
                variableId != null &&
                variableId.length > 0)
            {
                this._mutationCallback(this._detailType, this._detailId,
                    variableId, value, operation);
            }
        }

        private function parseInt32(value:String):Number
        {
            if (value == null || !/^-?\d+$/.test(value))
            {
                return Number.NaN;
            }
            var number:Number = Number(value);
            if (isNaN(number) || number < -2147483648
                || number > 2147483647)
            {
                return Number.NaN;
            }
            return number;
        }

        private function bindClose(window:IFrameWindow,
                                   callback:Function):void
        {
            var close:IWindow = window.findChildByTag("close");
            if (close != null)
            {
                close.addEventListener(WindowMouseEvent.CLICK, callback);
            }
        }

        private function bindClick(window:IFrameWindow, name:String,
                                   callback:Function):void
        {
            var child:IWindow = window.findChildByName(name);
            if (child != null)
            {
                child.addEventListener(WindowMouseEvent.CLICK, callback);
            }
        }

        private function setEnabled(window:IFrameWindow, name:String,
                                    enabled:Boolean):void
        {
            var child:IWindow = window.findChildByName(name);
            if (child != null)
            {
                if (enabled) child.enable(); else child.disable();
            }
        }

        private function setBubbleVisible(visible:Boolean):void
        {
            var bubble:IWindow =
                this._detail.findChildByName("create_var_bubble");
            if (bubble != null)
            {
                bubble.visible = visible;
            }
        }

        private function loc(key:String, fallback:String):String
        {
            return this._roomEvents.localization.getLocalization(key, fallback);
        }

        private function onOverviewClose(event:WindowMouseEvent):void
        {
            this._overview.visible = false;
        }
        private function onDetailClose(event:WindowMouseEvent):void
        {
            this._detail.visible = false;
        }
        private function onRefresh(event:WindowMouseEvent):void
        {
            this.requestPage(this._page);
        }
        private function onFirstPage(event:WindowMouseEvent):void { this.requestPage(1); }
        private function onPreviousPage(event:WindowMouseEvent):void
        {
            this.requestPage(Math.max(1, this._page - 1));
        }
        private function onNextPage(event:WindowMouseEvent):void
        {
            this.requestPage(this._page + 1);
        }
        private function onLastPage(event:WindowMouseEvent):void
        {
            this.requestPage(Math.max(1, Math.ceil(this._total / PAGE_SIZE)));
        }
        private function onOverviewFilterChanged(event:WindowEvent):void
        {
            this.requestPage(1);
        }
        private function onPageKey(event:WindowKeyboardEvent):void
        {
            if (event.charCode == Keyboard.ENTER)
            {
                this.requestPage(Math.max(1,
                    int(ITextFieldWindow(event.window).text)));
            }
        }
        private function onOverviewRowClicked(object:ITableObject):void
        {
            var row:WiredMenuTableObject = object as WiredMenuTableObject;
            if (row != null && row.data != null &&
                this._requestDetailsCallback != null)
            {
                this._requestDetailsCallback(int(row.data.type), int(row.data.id));
            }
        }
        private function onDetailRefresh(event:WindowMouseEvent):void
        {
            if (this._requestDetailsCallback != null)
            {
                this._requestDetailsCallback(this._detailType, this._detailId);
            }
        }
        private function onDetailRowSelected(object:ITableObject):void
        {
            this._selectedDetail = object as WiredMenuTableObject;
            this.updateDetailButtons();
        }
        private function onDetailCellEdited(object:ITableObject, columnId:String,
                                            value:String):void
        {
            var row:WiredMenuTableObject = object as WiredMenuTableObject;
            if (row == null || row.data == null || columnId != "value")
            {
                return;
            }
            var parsed:Number = this.parseInt32(value);
            if (!isNaN(parsed))
            {
                this.mutate(String(row.data.variableId), int(parsed), 0);
            }
        }
        private function onAdd(event:WindowMouseEvent):void
        {
            if (!this._canModify
                || this._availableCreateVariables.length == 0)
            {
                return;
            }
            this.populateCreatePicker();
            this.setBubbleVisible(true);
        }
        private function onDelete(event:WindowMouseEvent):void
        {
            if (this._selectedDetail != null &&
                this._selectedDetail.data != null)
            {
                this.mutate(String(this._selectedDetail.data.variableId), 0, 2);
            }
        }
        private function onCreate(event:WindowMouseEvent):void
        {
            if (this._createPicker == null ||
                this._createPicker.selection < 0 ||
                this._createPicker.selection >=
                    this._availableCreateVariables.length)
            {
                return;
            }
            var input:ITextFieldWindow =
                this._detail.findChildByName("value_input") as ITextFieldWindow;
            var variable:Object =
                this._availableCreateVariables[this._createPicker.selection];
            var parsed:Number = this.parseInt32(
                input == null ? "0" : input.text);
            if (isNaN(parsed))
            {
                return;
            }
            this.mutate(String(variable.id), int(parsed), 1);
            this.setBubbleVisible(false);
        }
    }
}
