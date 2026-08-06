package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views.ChestItemTypeRenderableWrapper;
    import com.sulake.habbo.window.widgets.IProductIconWidget;

    public class TradeRuleNodeView implements IDisposable
    {
        private static var UNIQUE_ID_COUNTER:uint = 0;

        private var _editor:TradeRuleEditorPreset;
        private var _node:TradeRequirementNode;
        private var _window:IRegionWindow;
        private var _hovered:Boolean;
        private var _closeHovered:Boolean;
        private var _showClose:Boolean;
        private var _uniqueId:uint;
        private var _disposed:Boolean;

        public function TradeRuleNodeView(template:IRegionWindow)
        {
            this._uniqueId = UNIQUE_ID_COUNTER++;
            this._window = template.clone() as IRegionWindow;
            this._window.addEventListener(WindowMouseEvent.OVER, this.onHover);
            this._window.addEventListener(WindowMouseEvent.OUT, this.onHoverEnd);
            this.closeRegion.addEventListener(WindowMouseEvent.OVER, this.onCloseHover);
            this.closeRegion.addEventListener(WindowMouseEvent.OUT, this.onCloseHoverEnd);
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this.closeRegion.addEventListener(WindowMouseEvent.CLICK, this.onCloseClick);
        }

        public function initialize(editor:TradeRuleEditorPreset,
            node:TradeRequirementNode, showClose:Boolean = true):void
        {
            this._editor = editor;
            this._node = node;
            this._showClose = showClose;
            this._hovered = false;
            this._closeHovered = false;
            Util.disableSection(this._window, false);
            this.updateUI();
        }

        public function release():void
        {
            this._editor = null;
            this._node = null;
            this._showClose = true;
        }

        private function onCloseClick(event:WindowMouseEvent):void
        {
            if (this._node != null) this._editor.removeNode(this);
        }

        private function onClick(event:WindowMouseEvent):void
        {
            if (this._node != null) this._editor.editNode(this);
        }

        private function updateUI():void
        {
            this.closeRegion.visible = this._showClose &&
                (this._hovered || this._closeHovered);
            this.quantityAmount.text = String(this._node.amount);
            this.quantityBorder.visible = this._node.amount != 1 ||
                this._node.type == TradeRequirementNode.TYPE_COIN;
            var widget:IProductIconWidget = this.iconWidget.widget as IProductIconWidget;
            if (this._node.type == TradeRequirementNode.TYPE_FURNI)
            {
                this.iconWidget.visible = true;
                widget.productInfo = this._node.itemType == null ? null :
                    new ChestItemTypeRenderableWrapper(this._node.itemType);
                this.coinsIcon.visible = false;
            }
            else
            {
                this.iconWidget.visible = false;
                widget.productInfo = null;
                this.coinsIcon.visible = true;
            }
        }

        private function onHoverEnd(event:WindowMouseEvent):void { this._hovered = false; this.updateUI(); }
        private function onHover(event:WindowMouseEvent):void { this._hovered = true; this.updateUI(); }
        private function onCloseHoverEnd(event:WindowMouseEvent):void { this._closeHovered = false; this.updateUI(); }
        private function onCloseHover(event:WindowMouseEvent):void { this._closeHovered = true; this.updateUI(); }

        public function get window():IRegionWindow { return this._window; }
        public function get node():TradeRequirementNode { return this._node; }
        public function set node(value:TradeRequirementNode):void { this._node = value; this.updateUI(); }
        public function get uniqueID():uint { return this._uniqueId; }

        public function dispose():void
        {
            if (this._disposed) return;
            this._editor = null;
            this._node = null;
            this._window.dispose();
            this._window = null;
            this._disposed = true;
        }

        public function get disposed():Boolean { return this._disposed; }
        private function get iconWidget():IWidgetWindow { return this._window.findChildByName("element_icon_widget") as IWidgetWindow; }
        private function get coinsIcon():IStaticBitmapWrapperWindow { return this._window.findChildByName("coins_icon") as IStaticBitmapWrapperWindow; }
        private function get quantityBorder():IWindowContainer { return this._window.findChildByName("quantity_border") as IWindowContainer; }
        private function get quantityAmount():ITextWindow { return this._window.findChildByName("quantity_amount") as ITextWindow; }
        private function get closeRegion():IRegionWindow { return this._window.findChildByName("close_region") as IRegionWindow; }
    }
}
