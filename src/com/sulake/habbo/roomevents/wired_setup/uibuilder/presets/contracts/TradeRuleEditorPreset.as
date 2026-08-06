package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
{
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class TradeRuleEditorPreset extends WiredUIPreset
    {
        private static const NODE_VIEW_POOL_MAX_SIZE:int = 50;
        public static const MAX_NODES_IN_RULE:int = 5;
        private static const NODE_VIEW_POOL:Map = new Map();

        private var _container:IBorderWindow;
        private var _nodeTemplate:IRegionWindow;
        private var _nodeViews:Vector.<TradeRuleNodeView>;
        private var _onEdit:Function;
        private var _onAdd:Function;
        private var _onRemove:Function;
        private var _onChange:Function;
        private var _hovered:Boolean;
        private var _closeHovered:Boolean;

        public function TradeRuleEditorPreset(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle, title:String,
            onEdit:Function, onAdd:Function, onRemove:Function = null,
            onChange:Function = null)
        {
            super(roomEvents, presetManager, style);
            this._container = style.createTradeRequirementRule();
            this._nodeViews = new Vector.<TradeRuleNodeView>();
            this._onEdit = onEdit;
            this._onAdd = onAdd;
            this._onRemove = onRemove;
            this._onChange = onChange;
            this.updateTitle(title);
            this._nodeTemplate = this.itemGrid.removeGridItemAt(0) as IRegionWindow;
            this.addMoreButton.addEventListener(WindowMouseEvent.CLICK, this.onAddMoreClicked);
            this._container.addEventListener(WindowMouseEvent.OVER, this.onHover);
            this._container.addEventListener(WindowMouseEvent.OUT, this.onHoverEnd);
            this.closeRegion.addEventListener(WindowMouseEvent.OVER, this.onCloseHover);
            this.closeRegion.addEventListener(WindowMouseEvent.OUT, this.onCloseHoverEnd);
            this.closeRegion.addEventListener(WindowMouseEvent.CLICK, this.onCloseClick);
            if (this.isOneLineMode) this.itemGrid.setParamFlag(8388608, false);
            this.updateCloseButtonVisibility();
        }

        protected function get isOneLineMode():Boolean { return true; }
        protected function get showNodeCloseButton():Boolean { return true; }

        public function set rule(value:TradeRequirementRule):void
        {
            this.removeAllNodes();
            for each (var node:TradeRequirementNode in value.nodes) this.addNode(node);
        }

        private function onAddMoreClicked(event:WindowMouseEvent):void
        {
            if (this._onAdd != null) this._onAdd(this);
        }

        internal function editNode(view:TradeRuleNodeView):void
        {
            if (this.itemGrid.getGridItemIndex(view.window) == -1) return;
            if (this._onEdit != null)
                this._onEdit(this, int(view.uniqueID), view.node);
        }

        public function updateTitle(value:String):void { this.titleWindow.text = value; }
        private function fireOnChange():void { if (this._onChange != null) this._onChange(); }

        public function addNode(node:TradeRequirementNode):void
        {
            if (disposed || this._nodeViews.length >= MAX_NODES_IN_RULE) return;
            var view:TradeRuleNodeView = this.createNodeView(node.deepCopy(),
                this.showNodeCloseButton);
            this.itemGrid.addGridItemAt(view.window, this.itemGrid.numGridItems - 1);
            this._nodeViews.push(view);
            this.onNodeCountChange();
        }

        private function createNodeView(node:TradeRequirementNode,
            showClose:Boolean = true):TradeRuleNodeView
        {
            var pool:Vector.<TradeRuleNodeView>;
            if (!NODE_VIEW_POOL.hasKey(this._style.name))
                NODE_VIEW_POOL.add(this._style.name, new Vector.<TradeRuleNodeView>());
            pool = NODE_VIEW_POOL.getValue(this._style.name) as Vector.<TradeRuleNodeView>;
            var view:TradeRuleNodeView = pool.length > 0
                ? pool.pop() : new TradeRuleNodeView(this._nodeTemplate);
            view.initialize(this, node, showClose);
            return view;
        }

        private function releaseNodeView(view:TradeRuleNodeView):void
        {
            if (!NODE_VIEW_POOL.hasKey(this._style.name))
                NODE_VIEW_POOL.add(this._style.name, new Vector.<TradeRuleNodeView>());
            var pool:Vector.<TradeRuleNodeView> =
                NODE_VIEW_POOL.getValue(this._style.name) as Vector.<TradeRuleNodeView>;
            if (pool.length >= NODE_VIEW_POOL_MAX_SIZE) view.dispose();
            else { view.release(); pool.push(view); }
        }

        public function updateNode(uniqueId:uint, node:TradeRequirementNode):void
        {
            if (disposed) return;
            var view:TradeRuleNodeView = this.getNodeViewByUniqueId(uniqueId);
            if (view == null) return;
            view.node = node;
            this.fireOnChange();
        }

        public function finalizeRule():TradeRequirementRule
        {
            var nodes:Vector.<TradeRequirementNode> = new Vector.<TradeRequirementNode>();
            for each (var view:TradeRuleNodeView in this._nodeViews)
                nodes.push(view.node);
            return new TradeRequirementRule(nodes);
        }

        private function getNodeViewByUniqueId(uniqueId:uint):TradeRuleNodeView
        {
            for each (var view:TradeRuleNodeView in this._nodeViews)
                if (view.uniqueID == uniqueId) return view;
            return null;
        }

        internal function removeNode(view:TradeRuleNodeView):void
        {
            var index:int = this._nodeViews.indexOf(view);
            if (index == -1) return;
            this._nodeViews.removeAt(index);
            this.itemGrid.removeGridItem(view.window);
            this.releaseNodeView(view);
            this.onNodeCountChange();
        }

        private function removeAllNodes():void
        {
            if (this._container == null) return;
            while (this.itemGrid.numGridItems > 1) this.itemGrid.removeGridItemAt(0);
            for each (var view:TradeRuleNodeView in this._nodeViews)
                this.releaseNodeView(view);
            this._nodeViews = new Vector.<TradeRuleNodeView>();
            this.onNodeCountChange();
        }

        protected function onNodeCountChange():void
        {
            this.itemGrid.rebuildGridStructure();
            if (this.addMoreButton != null)
            {
                if (this.isOneLineMode)
                    this.addMoreButton.visible = this._nodeViews.length < MAX_NODES_IN_RULE;
                else
                    Util.disableSection(this.addMoreButton,
                        this._nodeViews.length >= MAX_NODES_IN_RULE);
            }
            this.fireOnChange();
        }

        private function onCloseClick(event:WindowMouseEvent):void
        {
            if (this._onRemove != null) this._onRemove(this);
        }
        private function onHoverEnd(event:WindowMouseEvent):void { this._hovered = false; this.updateCloseButtonVisibility(); }
        private function onHover(event:WindowMouseEvent):void { this._hovered = true; this.updateCloseButtonVisibility(); }
        private function onCloseHoverEnd(event:WindowMouseEvent):void { this._closeHovered = false; this.updateCloseButtonVisibility(); }
        private function onCloseHover(event:WindowMouseEvent):void { this._closeHovered = true; this.updateCloseButtonVisibility(); }

        protected function updateCloseButtonVisibility():void
        {
            this.closeRegion.visible =
                (this._hovered || this._closeHovered) && this._onRemove != null;
        }

        override public function get window():IWindow { return this._container; }
        override public function resizeToWidth(width:int):void
        {
            super.resizeToWidth(width);
            this._container.width = width;
        }
        override protected function get childPresets():Array { return []; }

        override public function dispose():void
        {
            if (disposed) return;
            this.removeAllNodes();
            super.dispose();
            this._nodeViews = null;
            this._onEdit = null;
            this._onAdd = null;
            this._onRemove = null;
            this._onChange = null;
            this._nodeTemplate.dispose();
            this._nodeTemplate = null;
            this._container.dispose();
            this._container = null;
        }

        protected function get itemGrid():IItemGridWindow { return this._container.findChildByName("grid") as IItemGridWindow; }
        protected function get titleWindow():ITextWindow { return this._container.findChildByName("title") as ITextWindow; }
        protected function get addMoreButton():IWindow { return this._container.findChildByName("add_more"); }
        protected function get closeRegion():IRegionWindow { return this._container.findChildByName("close_rule_region") as IRegionWindow; }
    }
}
