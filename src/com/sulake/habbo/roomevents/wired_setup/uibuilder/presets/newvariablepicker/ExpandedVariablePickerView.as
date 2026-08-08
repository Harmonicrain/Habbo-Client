package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview.VariableNode;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview.VariableNodeListView;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons.TabButtonConfig;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons.TabButtonConfigs;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons.TabButtonView;

    public class ExpandedVariablePickerView implements IDisposable
    {
        private var _picker:NewVariablePicker;
        private var _window:IWindowContainer;
        private var _tabButtonTemplate:IRegionWindow;
        private var _overviewTemplate:IWindowContainer;
        private var _tabButtons:Vector.<TabButtonView> = new Vector.<TabButtonView>();
        private var _configs:TabButtonConfigs;
        private var _selectedTab:TabButtonView;
        private var _activeItemsView:VariableNodeListView;
        private var _disposed:Boolean;

        public function ExpandedVariablePickerView(picker:NewVariablePicker, window:IWindowContainer)
        {
            this._picker = picker;
            this._window = window;
            this._tabButtonTemplate = this.buttonList.removeListItemAt(0) as IRegionWindow;
            this._overviewTemplate = this.contentBox.removeChild(
                this.contentBox.getChildByName("variable_overview_template")) as IWindowContainer;
            var nodeTemplate:IWindow = this.contentBox.getChildByName("node_template");
            if (nodeTemplate != null) { this.contentBox.removeChild(nodeTemplate); }
            this._configs = new TabButtonConfigs(picker);
            this.expandedWindow.width = picker.window.width;
            var baseWidth:int = int((this.expandedWindow.width - 3) / this._configs.tabButtons.length);
            var remainder:int = (this.expandedWindow.width - 3) % this._configs.tabButtons.length;
            for each (var config:TabButtonConfig in this._configs.tabButtons)
            {
                var view:TabButtonView = new TabButtonView(this, config, baseWidth + (remainder-- > 0 ? 1 : 0));
                this._tabButtons.push(view);
                this.buttonList.addListItem(view.window);
            }
        }

        internal function onHide():void { this.clearActiveItems(); }
        internal function onVisible():void
        {
            if (this._selectedTab != null) { this.loadTab(this._selectedTab.tabConfig); }
        }

        public function get roomEvents():HabboUserDefinedRoomEvents { return this._picker.roomEvents; }
        public function get selectedTab():TabButtonView { return this._selectedTab; }
        public function get activeItemsView():VariableNodeListView { return this._activeItemsView; }
        public function get tabButtonTemplate():IRegionWindow { return this._tabButtonTemplate; }
        public function get overviewTemplate():IWindowContainer { return this._overviewTemplate; }
        public function get window():IWindowContainer { return this._window; }

        public function tabById(id:int):TabButtonView
        {
            for each (var view:TabButtonView in this._tabButtons)
            {
                if (view.tabConfig.tabId == id) { return view; }
            }
            return null;
        }

        public function selectTab(value:TabButtonView, force:Boolean = false):void
        {
            if (this._selectedTab == value)
            {
                if (force && value != null) { this.loadTab(value.tabConfig); }
                return;
            }
            if (this._selectedTab != null) { this._selectedTab.active = false; }
            this._selectedTab = value;
            if (value != null)
            {
                value.active = true;
                this.loadTab(value.tabConfig);
            }
            this._picker.inputField.focus();
        }

        public function loadTab(config:TabButtonConfig):void
        {
            this.clearActiveItems();
            var root:VariableNode = config.filteredVariables();
            if (root.childrenCount == 0)
            {
                this.emptyContainer.visible = true;
                this.contentBox.height = this.emptyContainer.height;
                return;
            }
            this.emptyContainer.visible = false;
            this._activeItemsView = new VariableNodeListView(this._picker, root.children, this.contentBox.width, true);
            this.contentBox.addChild(this._activeItemsView.window);
            this.contentBox.height = this._activeItemsView.window.height;
        }

        private function clearActiveItems():void
        {
            if (this._activeItemsView == null) { return; }
            if (this._activeItemsView.window.parent == this.contentBox)
            {
                this.contentBox.removeChild(this._activeItemsView.window);
            }
            this._activeItemsView.dispose();
            this._activeItemsView = null;
        }

        private function get buttonList():IItemListWindow { return this._window.findChildByName("button_list") as IItemListWindow; }
        private function get expandedWindow():IWindowContainer { return this._window.findChildByName("expanded_view") as IWindowContainer; }
        private function get contentBox():IWindowContainer { return this._window.findChildByName("content_box") as IWindowContainer; }
        private function get emptyContainer():IWindowContainer { return this._window.findChildByName("empty_container") as IWindowContainer; }

        public function dispose():void
        {
            if (this._disposed) { return; }
            this.clearActiveItems();
            this.buttonList.removeListItems();
            for each (var view:TabButtonView in this._tabButtons) { view.dispose(); }
            this._tabButtons = null;
            this._picker = null;
            this._window = null;
            this._tabButtonTemplate = null;
            this._overviewTemplate = null;
            this._configs = null;
            this._selectedTab = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
