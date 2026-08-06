package com.sulake.habbo.roomevents.wired_trading.transactions
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views.ChestItemTypeRenderableWrapper;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views.FurniChestItemView;
    import com.sulake.habbo.window.widgets.IProductIconWidget;

    /** One pooled icon in July's deposit/withdrawal details grids. */
    public final class TransactionItemView implements IDisposable
    {
        public static const TYPE_FURNI:int = 0;
        public static const TYPE_COINS:int = 1;
        public static const TYPE_INCOMPLETE:int = 2;

        private var _window:IRegionWindow;
        private var _amount:int;
        private var _kind:int;
        private var _hovered:Boolean;
        private var _disposed:Boolean;

        public function TransactionItemView(template:IRegionWindow)
        {
            this._window = template.clone() as IRegionWindow;
            this._window.addEventListener("WME_OVER", this.onOver);
            this._window.addEventListener("WME_OUT", this.onOut);
        }

        public function initialize(amount:int, kind:int, type:ChestItemType=null):void
        {
            this._amount = Math.max(0, amount);
            this._kind = kind;
            this._window.toolTipCaption = kind == TYPE_COINS
                ? "${wiredcontracts.element.type.0}"
                : kind == TYPE_INCOMPLETE
                    ? "${wiredchests.log_details.incomplete_data}" : "";
            this.furniIcon.visible = kind == TYPE_FURNI && type != null;
            if (this.furniIcon.visible)
            {
                (this.furniIcon.widget as IProductIconWidget).productInfo =
                    new ChestItemTypeRenderableWrapper(type);
            }
            this.coinsIcon.visible = kind == TYPE_COINS;
            this.incompleteText.visible = kind == TYPE_INCOMPLETE;
            this.limitedBackground.visible = false;
            this.limitedOverlay.visible = false;
            this.rarityOverlay.visible = false;
            this.updateUI();
            this.updateColoring();
        }

        private function updateUI():void
        {
            if (this._kind == TYPE_INCOMPLETE)
            {
                this.numberContainer.visible = false;
                this.incompleteText.fontSize = this._amount >= 1000 ? 12 : 16;
                this.incompleteText.text = "+" + this._amount;
            }
            else
            {
                this.numberContainer.visible = this._amount > 1;
                if (this._amount > 1)
                {
                    this.quantity.text = String(this._amount);
                }
            }
        }
        private function onOver(event:WindowMouseEvent):void
        {
            this._hovered = true; this.updateColoring();
        }
        private function onOut(event:WindowMouseEvent):void
        {
            this._hovered = false; this.updateColoring();
        }
        private function updateColoring():void
        {
            this.focus.visible = false;
            this.border.color = this._hovered
                ? FurniChestItemView.HOVERED_COLOR
                : FurniChestItemView.NOT_HOVERED_COLOR;
        }
        public function recycle():void
        {
            this._hovered = false;
            this._amount = 0;
            this._kind = TYPE_FURNI;
        }
        public function get window():IRegionWindow { return this._window; }
        private function get border():IBorderWindow
        {
            return this._window.findChildByName("border") as IBorderWindow;
        }
        private function get focus():IStaticBitmapWrapperWindow
        {
            return this._window.findChildByName("outline_focus")
                as IStaticBitmapWrapperWindow;
        }
        private function get coinsIcon():IStaticBitmapWrapperWindow
        {
            return this._window.findChildByName("coins_icon")
                as IStaticBitmapWrapperWindow;
        }
        private function get incompleteText():ITextWindow
        {
            return this._window.findChildByName("incomplete_text") as ITextWindow;
        }
        private function get furniIcon():IWidgetWindow
        {
            return this._window.findChildByName("furni_icon") as IWidgetWindow;
        }
        private function get numberContainer():IWindowContainer
        {
            return this._window.findChildByName("number_container")
                as IWindowContainer;
        }
        private function get quantity():ITextWindow
        {
            return this._window.findChildByName("furni_quantity") as ITextWindow;
        }
        private function get limitedBackground():IStaticBitmapWrapperWindow
        {
            return this._window.findChildByName("unique_item_background_bitmap")
                as IStaticBitmapWrapperWindow;
        }
        private function get limitedOverlay():IWidgetWindow
        {
            return this._window.findChildByName("unique_item_overlay_container")
                as IWidgetWindow;
        }
        private function get rarityOverlay():IWidgetWindow
        {
            return this._window.findChildByName("rarity_item_overlay_container")
                as IWidgetWindow;
        }
        public function dispose():void
        {
            if (this._disposed) { return; }
            this._window.dispose();
            this._window = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
