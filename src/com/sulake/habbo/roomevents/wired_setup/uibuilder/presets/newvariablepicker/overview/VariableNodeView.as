package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.overview
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class VariableNodeView implements IDisposable
    {
        private static const HOVER_BG:uint = 0xFFE0E0E0;
        private static const EVEN_BG:uint = 0xFFEFEFEF;
        private static const ODD_BG:uint = 0xFFFAFAFA;

        private var _variableNode:VariableNode;
        private var _picker:NewVariablePicker;
        private var _window:IRegionWindow;
        private var _style:WiredStyle;
        private var _index:int;
        private var _hover:Boolean;
        private var _selectable:Boolean;
        private var _disabled:Boolean;
        private var _parent:VariableNodeListView;
        private var _sublist:VariableNodeListView;
        private var _disposed:Boolean;

        public function VariableNodeView(node:VariableNode, picker:NewVariablePicker,
                                         parent:VariableNodeListView, index:int)
        {
            this._variableNode = node;
            this._picker = picker;
            this._parent = parent;
            this._index = index;
            this._style = picker.roomEvents.wiredCtrl.wiredStyle;
            this._window = picker.roomEvents.variablePickerHelper.acquireNodeView(this._style);
            this._selectable = node.canBeSelected(picker);
            this._disabled = node.isDisabled(picker);
            this.icon.visible = node.childrenCount > 0;
            this.nodeName.text = node.name;
            this.nodeName.blend = this._disabled ? 0.55 : 1;
            this.icon.blend = this._disabled ? 0.55 : 1;
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._window.addEventListener(WindowMouseEvent.OVER, this.onOver);
            if (this._disabled)
            {
                this._window.toolTipCaption = picker.roomEvents.localization.getLocalization(
                    "wiredfurni.variable_picker.tooltip_disabled", "wiredfurni.variable_picker.tooltip_disabled");
            }
            else if (!this._selectable)
            {
                this._window.toolTipCaption = picker.roomEvents.localization.getLocalization(
                    "wiredfurni.variable_picker.tooltip_not_selectable", "wiredfurni.variable_picker.tooltip_not_selectable");
            }
            else
            {
                this._window.toolTipCaption = "";
            }
            this.updateColoring();
        }

        private function onClick(event:WindowMouseEvent):void
        {
            if (this._selectable) { this._picker.select(this._variableNode.variable); }
        }
        private function onOver(event:WindowMouseEvent):void { this._parent.setHover(this); }

        internal function set hover(value:Boolean):void
        {
            if (this._hover == value) { return; }
            this._hover = value;
            this.updateColoring();
            if (this._variableNode.childrenCount > 0)
            {
                if (value) { this.initSublist(); } else { this.removeSublist(); }
            }
        }

        private function updateColoring():void
        {
            this._window.color = this._hover ? HOVER_BG : (this._index % 2 == 0 ? EVEN_BG : ODD_BG);
        }

        private function initSublist():void
        {
            if (this._sublist != null) { return; }
            this._sublist = new VariableNodeListView(this._picker, this._variableNode.children, this._window.width);
            var child:IWindowContainer = this._sublist.window;
            var host:IWindowContainer = this._picker.expandedView.window;
            host.addChild(child);
            var nodeGlobal:Point = new Point();
            var hostGlobal:Point = new Point();
            this._window.getGlobalPosition(nodeGlobal);
            host.getGlobalPosition(hostGlobal);
            child.x = nodeGlobal.x - hostGlobal.x + this._window.width + this._parent.scrollbarWidth;
            child.y = nodeGlobal.y - hostGlobal.y;
            var bounds:Rectangle = new Rectangle();
            child.getGlobalRectangle(bounds);
            if (bounds.bottom > child.desktop.bottom)
            {
                child.offset(0, child.desktop.bottom - bounds.bottom);
                if (child.y < 0) { child.y = 0; }
            }
        }

        private function removeSublist():void
        {
            if (this._sublist == null) { return; }
            if (this._sublist.window.parent != null)
            {
                IWindowContainer(this._sublist.window.parent).removeChild(this._sublist.window);
            }
            this._sublist.dispose();
            this._sublist = null;
        }

        public function get variableNode():VariableNode { return this._variableNode; }
        public function get window():IRegionWindow { return this._window; }

        private function get icon():IIconWindow { return this._window.findChildByName("right_triangle_icon") as IIconWindow; }
        private function get nodeName():ITextWindow { return this._window.findChildByName("node_name") as ITextWindow; }

        public function dispose():void
        {
            if (this._disposed) { return; }
            this.removeSublist();
            this._window.removeEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._window.removeEventListener(WindowMouseEvent.OVER, this.onOver);
            this._picker.roomEvents.variablePickerHelper.releaseNodeView(this._style, this._window);
            this._picker = null;
            this._window = null;
            this._style = null;
            this._variableNode = null;
            this._parent = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
