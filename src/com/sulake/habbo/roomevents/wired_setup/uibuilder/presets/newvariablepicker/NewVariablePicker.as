package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableTypes;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview.VariableNode;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview.VariableNodeListView;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons.TabButtonConfigs;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons.TabButtonView;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    public class NewVariablePicker implements IDisposable
    {
        public static const UNSPECIFIED_TYPE:int = int.MAX_VALUE;

        private var _disposed:Boolean;
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _container:IWindowContainer;
        private var _expandedWindowWrapper:IWindowContainer;
        private var _inputFieldRegion:IRegionWindow;
        private var _isExpanded:Boolean;
        private var _variableFilter:Function;
        private var _onSelected:Function;
        private var _showFilteredVariables:Boolean = true;
        private var _allVariables:AllVariablesInRoom;
        private var _filteredVariables:Vector.<WiredVariable> = new Vector.<WiredVariable>();
        private var _selected:WiredVariable;
        private var _variableTarget:int;
        private var _selectionCache:Dictionary = new Dictionary();
        private var _originalSelectedId:String;
        private var _queryDirty:Boolean;
        private var _expandedView:ExpandedVariablePickerView;

        public function NewVariablePicker(roomEvents:HabboUserDefinedRoomEvents, container:IWindowContainer,
                                          filter:Function = null, onSelected:Function = null,
                                          style:WiredStyle = null)
        {
            this._roomEvents = roomEvents;
            this._container = container;
            this._variableFilter = filter;
            this._onSelected = onSelected;
            this._selectionCache = new Dictionary();
            this._inputFieldRegion = container.findChildByName("input_field_region") as IRegionWindow;
            this._expandedWindowWrapper = container.findChildByName("expanded_view_wrapper") as IWindowContainer;
            this._expandedWindowWrapper.desktop.addChild(this._expandedWindowWrapper);
            this._expandedWindowWrapper.visible = false;
            if (style != null && style.name == "illumina")
            {
                this.collapsedView.style = 105;
                this._expandedWindowWrapper.findChildByName("expanded_view").style = 105;
            }
            this._inputFieldRegion.addEventListener(WindowMouseEvent.CLICK, this.onTextRegionClick);
            this.inputField.addEventListener(WindowMouseEvent.CLICK, this.onTextRegionClick);
            this.cancelSearchButton.addEventListener(WindowMouseEvent.CLICK, this.onCancelSearch);
            this.inputField.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.onChangeQuery);
            this.inputField.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this.onKeyUp);
            this.inputPlaceholderText.visible = true;
            this._expandedWindowWrapper.setParamFlag(16, false);
            this._expandedWindowWrapper.addEventListener(WindowEvent.WINDOW_EVENT_DEACTIVATED, this.onDeactivate);
            this.collapseView(true);
        }

        public function init(variables:AllVariablesInRoom, selectedId:String, target:int):void
        {
            this._allVariables = variables;
            this._variableTarget = target;
            this._originalSelectedId = selectedId;
            this._queryDirty = false;
            this._selectionCache = new Dictionary();
            this._filteredVariables = this.filterAllVariables();
            this.select(this.findVariableById(selectedId), true);
            if (this._expandedView != null)
            {
                this._expandedView.selectTab(this._expandedView.tabById(this.determineInitialTab()));
            }
        }

        public function set variableTarget(value:int):void
        {
            if (value == this._variableTarget) { return; }
            this.collapseView();
            this.updateSelected();
            this._variableTarget = value;
            this._filteredVariables = this.filterAllVariables();
            this.select(value in this._selectionCache ? this._selectionCache[value] as WiredVariable : null);
        }
        public function get variableTarget():int { return this._variableTarget; }
        public function get filteredVariables():Vector.<WiredVariable> { return this._filteredVariables; }
        public function get variableFilter():Function { return this._variableFilter; }
        public function get roomEvents():HabboUserDefinedRoomEvents { return this._roomEvents; }
        public function get expandedView():ExpandedVariablePickerView { return this._expandedView; }
        public function get window():IWindowContainer { return this._container; }

        public function filteredVariableById(id:String):WiredVariable { return this.findVariableById(id); }

        private function findVariableById(id:String):WiredVariable
        {
            for each (var variable:WiredVariable in this._filteredVariables)
            {
                if (variable.variableId == id) { return variable; }
            }
            return null;
        }

        private function filterAllVariables():Vector.<WiredVariable>
        {
            var output:Vector.<WiredVariable> = new Vector.<WiredVariable>();
            if (this._allVariables == null || this._allVariables.variables == null) { return output; }
            for each (var variable:WiredVariable in this._allVariables.variables)
            {
                var filterVisible:Boolean = this._variableFilter == null || this._showFilteredVariables || this._variableFilter(variable);
                var targetVisible:Boolean = variable.variableTarget == this._variableTarget || this._variableTarget == UNSPECIFIED_TYPE;
                var privateVisible:Boolean = !variable.isInvisible || this._originalSelectedId == variable.variableId;
                if (filterVisible && targetVisible && privateVisible && variable.variableName.length > 0) { output.push(variable); }
            }
            return output;
        }

        public function select(value:WiredVariable, initializing:Boolean = false):void
        {
            this.collapseView();
            this._selectionCache[this._variableTarget] = value;
            this._selected = value;
            this.inputField.text = value == null ? "" : value.variableName;
            this.updatePlaceholder();
            if (!initializing && this._onSelected != null) { this._onSelected(value); }
            this._queryDirty = false;
        }

        private function updateSelected():void
        {
            var value:WiredVariable = this.filteredVariableByDisplayName(this.inputField.text);
            if (value != null && value != this._selected) { this.select(value); }
            if (this.inputField.text.length == 0 && this._selected != null) { this.select(null); }
        }

        public function get selected():WiredVariable { this.updateSelected(); return this._selected; }
        public function finalize():void
        {
            this.updateSelected();
            if (this._selected != null) { this._roomEvents.variablePickerHelper.addToHistory(this._selected); }
        }

        private function collapseView(force:Boolean = false):void
        {
            if (!this._isExpanded && !force) { return; }
            this._isExpanded = false;
            this.collapsedView.visible = true;
            this._expandedWindowWrapper.visible = false;
            this._expandedWindowWrapper.deactivate();
            this.moveInputField(this.searchWrapperCollapsed);
            if (this._expandedView != null) { this._expandedView.onHide(); }
        }

        private function expandView():void
        {
            if (this._isExpanded) { return; }
            this._isExpanded = true;
            this.collapsedView.visible = false;
            var position:Point = new Point();
            this._container.getGlobalPosition(position);
            position.y -= this.searchWrapperExpanded.y;
            this._expandedWindowWrapper.setGlobalPosition(position);
            this._expandedWindowWrapper.visible = true;
            this._expandedWindowWrapper.activate();
            this.moveInputField(this.searchWrapperExpanded);
            this.inputField.focus();
            if (this._expandedView == null)
            {
                this._expandedView = new ExpandedVariablePickerView(this, this._expandedWindowWrapper);
                this._expandedView.selectTab(this._expandedView.tabById(this.determineInitialTab()));
            }
            else { this._expandedView.onVisible(); }
            this._queryDirty = false;
        }

        private function determineInitialTab():int
        {
            if (this._selected == null) { return TabButtonConfigs.USER_CREATED_TAB_ID; }
            if (this._selected.variableType == WiredVariableTypes.DYNAMIC) { return TabButtonConfigs.DYNAMIC_TAB_ID; }
            if (this._selected.variableType == WiredVariableTypes.INTERNAL) { return TabButtonConfigs.INTERNAL_TAB_ID; }
            return TabButtonConfigs.USER_CREATED_TAB_ID;
        }

        private function moveInputField(parent:IWindowContainer):void
        {
            IWindowContainer(this._inputFieldRegion.parent).removeChild(this._inputFieldRegion);
            parent.addChild(this._inputFieldRegion);
            this._inputFieldRegion.width = parent.width;
            this._inputFieldRegion.height = parent.height;
        }

        private function onDeactivate(event:WindowEvent):void
        {
            if (this._queryDirty)
            {
                var value:WiredVariable = this.filteredVariableByDisplayName(this.inputField.text);
                this.select(value != null ? value : this._selected);
            }
            this._queryDirty = false;
            this.collapseView();
        }

        private function filteredVariableByDisplayName(name:String):WiredVariable
        {
            for each (var variable:WiredVariable in this._filteredVariables)
            {
                if (this._variableFilter != null && !this._variableFilter(variable)) { continue; }
                if (variable.variableName.toLowerCase() == name.toLowerCase()) { return variable; }
            }
            return null;
        }

        private function onKeyUp(event:WindowKeyboardEvent):void
        {
            if (event.keyCode == 27) { this.collapseView(); return; }
            if (event.keyCode != 13) { return; }
            var value:WiredVariable = this.filteredVariableByDisplayName(this.inputField.text);
            if (value != null) { this.select(value); return; }
            if (this.inputField.text.length == 0) { this.select(null); return; }
            if (this._expandedView != null && this._isExpanded)
            {
                var tab:TabButtonView = this._expandedView.selectedTab;
                var list:VariableNodeListView = this._expandedView.activeItemsView;
                if (tab != null && tab.tabConfig.tabId == TabButtonConfigs.SEARCH_TAB_ID
                    && list != null && list.childNodes.length > 0)
                {
                    var node:VariableNode = list.childNodes[0].variableNode;
                    if (node.variable != null && node.canBeSelected(this)) { this.select(node.variable); }
                }
            }
        }

        private function onChangeQuery(event:WindowEvent):void
        {
            if (this._isExpanded && this._expandedView != null)
            {
                this._expandedView.selectTab(this._expandedView.tabById(TabButtonConfigs.SEARCH_TAB_ID), true);
            }
            this.updatePlaceholder();
            this._queryDirty = true;
        }
        private function updatePlaceholder():void
        {
            this.cancelSearchButton.visible = this.inputField.text.length > 0;
            this.inputPlaceholderText.visible = this.inputField.text.length == 0;
        }
        private function onTextRegionClick(event:WindowMouseEvent):void { this.inputField.focus(); this.expandView(); }
        private function onCancelSearch(event:WindowMouseEvent):void
        {
            this.inputField.text = "";
            this.select(null);
            this.inputField.focus();
            this.expandView();
        }

        public function set width(value:int):void { this._container.width = value; }
        public function get inputField():ITextFieldWindow { return this._inputFieldRegion.findChildByName("input_field") as ITextFieldWindow; }
        private function get collapsedView():IBorderWindow { return this._container.findChildByName("collapsed_view") as IBorderWindow; }
        private function get inputPlaceholderText():ITextWindow { return this._inputFieldRegion.findChildByName("input_placeholder_text") as ITextWindow; }
        private function get searchWrapperCollapsed():IWindowContainer { return this._container.findChildByName("search_wrapper_collapsed") as IWindowContainer; }
        private function get searchWrapperExpanded():IWindowContainer { return this._expandedWindowWrapper.findChildByName("search_wrapper_expanded") as IWindowContainer; }
        private function get cancelSearchButton():IRegionWindow { return this._expandedWindowWrapper.findChildByName("cancel_search") as IRegionWindow; }

        public function dispose():void
        {
            if (this._disposed) { return; }
            if (this._expandedView != null)
            {
                this._expandedView.dispose();
                this._expandedView = null;
            }
            if (this._expandedWindowWrapper != null)
            {
                this._expandedWindowWrapper.removeEventListener(WindowEvent.WINDOW_EVENT_DEACTIVATED, this.onDeactivate);
                if (this._expandedWindowWrapper.parent != null)
                {
                    IWindowContainer(this._expandedWindowWrapper.parent).removeChild(this._expandedWindowWrapper);
                }
                this._expandedWindowWrapper.dispose();
            }
            this._container = null;
            this._expandedWindowWrapper = null;
            this._inputFieldRegion = null;
            this._roomEvents = null;
            this._allVariables = null;
            this._filteredVariables = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
