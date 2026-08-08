package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableTypes;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview.VariableNode;

    public class TabButtonConfigs
    {
        public static const ALL_TAB_ID:int = 0;
        public static const RECENT_TAB_ID:int = 1;
        public static const USER_CREATED_TAB_ID:int = 2;
        public static const DYNAMIC_TAB_ID:int = 3;
        public static const INTERNAL_TAB_ID:int = 4;
        public static const SEARCH_TAB_ID:int = 5;

        private var _picker:NewVariablePicker;
        private var _tabButtons:Vector.<TabButtonConfig>;

        public function TabButtonConfigs(picker:NewVariablePicker)
        {
            this._picker = picker;
            this._tabButtons = Vector.<TabButtonConfig>([
                new TabButtonConfig(ALL_TAB_ID, "var_picker_all", "wiredfurni.variable_picker.tab.all", this.allFilter),
                new TabButtonConfig(RECENT_TAB_ID, "var_picker_recent", "wiredfurni.variable_picker.tab.recent", this.recentFilter),
                new TabButtonConfig(USER_CREATED_TAB_ID, "var_picker_usermade", "wiredfurni.variable_picker.tab.user_created", this.userCreatedFilter),
                new TabButtonConfig(DYNAMIC_TAB_ID, "var_picker_smart", "wiredfurni.variable_picker.tab.dynamic", this.dynamicFilter),
                new TabButtonConfig(INTERNAL_TAB_ID, "var_picker_internal", "wiredfurni.variable_picker.tab.internal", this.internalFilter),
                new TabButtonConfig(SEARCH_TAB_ID, "var_picker_search", "wiredfurni.variable_picker.tab.search", this.searchFilter)
            ]);
        }

        public function get tabButtons():Vector.<TabButtonConfig> { return this._tabButtons; }

        private function nodesFromVector(values:Vector.<WiredVariable>, flatten:Boolean = false):VariableNode
        {
            var root:VariableNode = new VariableNode(null, null);
            for each (var variable:WiredVariable in values)
            {
                var current:VariableNode = root;
                var parts:Array = Util.splitVariableName(variable);
                for (var index:int = 0; index < parts.length; index++)
                {
                    var name:String = String(parts[index]);
                    var child:VariableNode = current.getChildNodeByName(name);
                    if (child == null)
                    {
                        child = new VariableNode(index == parts.length - 1 ? variable : null, name);
                        current.addChildNode(child);
                    }
                    current = child;
                }
            }
            if (flatten)
            {
                for each (var top:VariableNode in root.children) { top.flatten(true); }
            }
            return root;
        }

        private function allFilter():VariableNode { return this.nodesFromVector(this._picker.filteredVariables); }

        private function recentFilter():VariableNode
        {
            var values:Vector.<WiredVariable> = new Vector.<WiredVariable>();
            for each (var id:String in this._picker.roomEvents.variablePickerHelper.getHistory(this._picker.variableTarget))
            {
                var variable:WiredVariable = this._picker.filteredVariableById(id);
                if (variable != null) { values.push(variable); }
            }
            return this.nodesFromVector(values, true);
        }

        private function userCreatedFilter():VariableNode
        {
            return this.nodesFromVector(this.byType(WiredVariableTypes.USER_CREATED,
                WiredVariableTypes.USER_CREATED_SPECIAL));
        }

        private function dynamicFilter():VariableNode
        {
            return this.nodesFromVector(this.byType(WiredVariableTypes.DYNAMIC));
        }

        private function internalFilter():VariableNode
        {
            return this.nodesFromVector(this.byType(WiredVariableTypes.INTERNAL));
        }

        private function byType(...types):Vector.<WiredVariable>
        {
            var output:Vector.<WiredVariable> = new Vector.<WiredVariable>();
            for each (var variable:WiredVariable in this._picker.filteredVariables)
            {
                if (types.indexOf(variable.variableType) >= 0) { output.push(variable); }
            }
            return output;
        }

        private function searchFilter():VariableNode
        {
            var query:String = this._picker.inputField.text;
            if (query.length == 0) { return this.nodesFromVector(new Vector.<WiredVariable>()); }
            var terms:Array = query.split(" ");
            var output:Vector.<WiredVariable> = new Vector.<WiredVariable>();
            for each (var variable:WiredVariable in this._picker.filteredVariables)
            {
                var matches:Boolean = true;
                for each (var term:String in terms)
                {
                    if (variable.variableName.toLowerCase().indexOf(term.toLowerCase()) < 0)
                    {
                        matches = false;
                        break;
                    }
                }
                if (matches) { output.push(variable); }
            }
            return this.nodesFromVector(output, true);
        }
    }
}
