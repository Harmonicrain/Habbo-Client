package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePicker;

    public class VariableNodeListView implements IDisposable
    {
        private static const MAX_HEIGHT:int = 300;
        private static const SCROLLBAR_WIDTH:int = 9;

        private var _window:IWindowContainer;
        private var _picker:NewVariablePicker;
        private var _childNodes:Vector.<VariableNodeView> = new Vector.<VariableNodeView>();
        private var _currentHoveredNode:VariableNodeView;
        private var _disposed:Boolean;

        public function VariableNodeListView(picker:NewVariablePicker, nodes:Vector.<VariableNode>, width:int,
                                             root:Boolean = false)
        {
            this._picker = picker;
            this._window = picker.expandedView.overviewTemplate.clone() as IWindowContainer;
            if (!root) { this._window.style = 12; }
            this._window.width = width;
            if (nodes != null && nodes.length > 0)
            {
                for (var index:int = 0; index < nodes.length; index++)
                {
                    var view:VariableNodeView = new VariableNodeView(nodes[index], picker, this, index);
                    this.nodesList.addListItem(view.window);
                    this._childNodes.push(view);
                }
                this.nodesList.height = Math.min(this._childNodes[0].window.height * nodes.length, MAX_HEIGHT);
                var childWidth:int = width - this.scrollbarWidth - (root ? 0 : 3);
                for each (view in this._childNodes)
                {
                    view.window.width = childWidth;
                    if (!root) { view.window.x = 1; }
                }
            }
            else
            {
                this.nodesList.height = 10;
            }
        }

        public function get scrollbarWidth():int { return this.nodesList.isScrollBarVisible ? SCROLLBAR_WIDTH : 0; }
        public function get childNodes():Vector.<VariableNodeView> { return this._childNodes; }
        public function get window():IWindowContainer { return this._window; }

        public function setHover(value:VariableNodeView):void
        {
            if (value == this._currentHoveredNode) { return; }
            if (this._currentHoveredNode != null) { this._currentHoveredNode.hover = false; }
            this._currentHoveredNode = value;
            if (value != null) { value.hover = true; }
        }

        private function get nodesList():IScrollableListWindow
        {
            return this._window.findChildByName("nodes_list") as IScrollableListWindow;
        }

        public function dispose():void
        {
            if (this._disposed) { return; }
            for each (var view:VariableNodeView in this._childNodes) { view.dispose(); }
            this.nodesList.removeListItems();
            this._childNodes = null;
            this._picker = null;
            this._currentHoveredNode = null;
            this._window.dispose();
            this._window = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
