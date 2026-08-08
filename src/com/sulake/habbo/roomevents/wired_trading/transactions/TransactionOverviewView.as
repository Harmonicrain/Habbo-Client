package com.sulake.habbo.roomevents.wired_trading.transactions
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IScrollableGridWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionItemTypeCount;
    import __AS3__.vec.Vector;

    /** July's pooled furniture/credit summary grid. */
    public final class TransactionOverviewView implements IDisposable
    {
        private static const MAX_POOL_SIZE:int = 15;
        private var _window:IWindowContainer;
        private var _template:IRegionWindow;
        private var _active:Vector.<TransactionItemView>;
        private var _pool:Vector.<TransactionItemView>;
        private var _disposed:Boolean;

        public function TransactionOverviewView(window:IWindowContainer)
        {
            this._window = window;
            this._template = this.grid.removeGridItemAt(0) as IRegionWindow;
            this._active = new Vector.<TransactionItemView>();
            this._pool = new Vector.<TransactionItemView>();
        }

        public function initialize(
            coins:int,
            itemTypes:Vector.<WiredTransactionItemTypeCount>,
            totalFurni:int,
            incomplete:Boolean):void
        {
            this.clear();
            if (coins > 0)
            {
                this._active.push(this.claim(coins, TransactionItemView.TYPE_COINS));
            }
            var retained:int;
            for each (var item:WiredTransactionItemTypeCount in itemTypes)
            {
                retained += item.amount;
                this._active.push(this.claim(
                    item.amount, TransactionItemView.TYPE_FURNI, item));
            }
            if (incomplete && retained < totalFurni)
            {
                this._active.push(this.claim(totalFurni - retained,
                    TransactionItemView.TYPE_INCOMPLETE));
            }
            for each (var view:TransactionItemView in this._active)
            {
                this.grid.addGridItem(view.window);
            }
            this.emptyText.visible = this.grid.numGridItems == 0;
        }

        private function claim(amount:int, kind:int,
                               item:WiredTransactionItemTypeCount=null):TransactionItemView
        {
            var result:TransactionItemView = this._pool.length > 0
                ? this._pool.pop() : new TransactionItemView(this._template);
            result.initialize(amount, kind, item == null ? null : item.type);
            return result;
        }
        public function clear():void
        {
            this.grid.removeGridItems();
            for each (var view:TransactionItemView in this._active)
            {
                if (this._pool.length < MAX_POOL_SIZE)
                {
                    view.recycle();
                    this._pool.push(view);
                }
                else
                {
                    view.dispose();
                }
            }
            this._active.length = 0;
        }
        private function get grid():IScrollableGridWindow
        {
            return this._window.findChildByName("item_grid")
                as IScrollableGridWindow;
        }
        private function get emptyText():ITextWindow
        {
            return this._window.findChildByName("empty_text") as ITextWindow;
        }
        public function dispose():void
        {
            if (this._disposed) { return; }
            this.clear();
            for each (var view:TransactionItemView in this._pool)
            {
                view.dispose();
            }
            this._pool = null;
            this._active = null;
            this._template.dispose();
            this._template = null;
            this._window = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
