package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview
{
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePicker;

    public class VariableNode
    {
        private var _variable:WiredVariable;
        private var _children:Map = new Map();
        private var _name:String;

        public function VariableNode(variable:WiredVariable, name:String)
        {
            this._variable = variable;
            this._name = name;
        }

        public function get name():String { return this._name; }
        public function get variable():WiredVariable { return this._variable; }
        public function get children():Vector.<VariableNode> { return Vector.<VariableNode>(this._children.getValues()); }
        public function get childrenCount():int { return this._children.length; }
        public function getChildNodeByName(value:String):VariableNode { return this._children.getValue(value) as VariableNode; }
        public function addChildNode(value:VariableNode):void { this._children.add(value.name, value); }

        public function flatten(renameLeaf:Boolean = false):Boolean
        {
            if (this._children.length == 1 && this._variable == null)
            {
                var child:VariableNode = this._children.getValues()[0] as VariableNode;
                if (child.flatten())
                {
                    this._variable = child.variable;
                    this._children.dispose();
                    this._children = new Map();
                }
            }
            var leaf:Boolean = this._variable != null && this._children.length == 0;
            if (renameLeaf && leaf) { this._name = this._variable.variableName; }
            return leaf;
        }

        public function canBeSelected(picker:NewVariablePicker):Boolean
        {
            return this._variable != null && (picker.variableFilter == null || picker.variableFilter(this._variable));
        }

        public function isDisabled(picker:NewVariablePicker):Boolean
        {
            if (this.canBeSelected(picker)) { return false; }
            for each (var child:VariableNode in this._children.getValues())
            {
                if (!child.isDisabled(picker)) { return false; }
            }
            return true;
        }
    }
}
