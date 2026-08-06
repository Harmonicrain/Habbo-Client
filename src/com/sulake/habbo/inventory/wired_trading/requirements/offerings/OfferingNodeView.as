package com.sulake.habbo.inventory.wired_trading.requirements.offerings
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.window.widgets.IProductIconWidget;

    public class OfferingNodeView implements IDisposable
    {
        private var _window:IItemListWindow;
        private var _node:TradeRequirementNode;
        private var _index:int;
        private var _disposed:Boolean;

        public function OfferingNodeView(template:IItemListWindow)
        {
            this._window = template.clone() as IItemListWindow;
        }

        public function initialize(node:TradeRequirementNode, index:int):void
        {
            this._node = node;
            this._index = index;
            this.furniIcon.visible =
                node.type == TradeRequirementNode.TYPE_FURNI;
            this.coinIcon.visible =
                node.type == TradeRequirementNode.TYPE_COIN;
            this.andText.visible = index > 0;
            this.amountText.visible = node.amount > 1;
            if (node.amount > 1)
            {
                this.amountText.text = node.amount + "x";
            }
            if (node.type == TradeRequirementNode.TYPE_FURNI
                && node.itemType != null)
            {
                (this.furniIcon.widget as IProductIconWidget).productInfo =
                    new ChestItemTypeRenderableWrapper(node.itemType);
            }
        }

        public function get window():IItemListWindow { return this._window; }

        public function dispose():void
        {
            if (this._disposed) { return; }
            this._window.dispose();
            this._window = null;
            this._node = null;
            this._disposed = true;
        }

        public function get disposed():Boolean { return this._disposed; }
        private function get andText():ITextWindow
        { return this._window.getListItemByName("and_text") as ITextWindow; }
        private function get amountText():ITextWindow
        { return this._window.getListItemByName("amount_text") as ITextWindow; }
        private function get ruleIcon():IWindowContainer
        { return this._window.getListItemByName("rule_icon") as IWindowContainer; }
        private function get furniIcon():IWidgetWindow
        { return this.ruleIcon.findChildByName("furni_icon") as IWidgetWindow; }
        private function get coinIcon():IStaticBitmapWrapperWindow
        { return this.ruleIcon.findChildByName("coin_icon") as IStaticBitmapWrapperWindow; }
    }
}
