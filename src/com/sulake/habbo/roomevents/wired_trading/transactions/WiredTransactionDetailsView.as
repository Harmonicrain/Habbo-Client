package com.sulake.habbo.roomevents.wired_trading.transactions
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionDetails;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /** Exact July transaction-details presentation adapted to clean windows. */
    public final class WiredTransactionDetailsView implements IDisposable
    {
        private var _controller:WiredTransactionDetailsController;
        private var _window:IFrameWindow;
        private var _extraBubble:IWindowContainer;
        private var _withdrawals:TransactionOverviewView;
        private var _deposits:TransactionOverviewView;
        private var _disposed:Boolean;

        public function WiredTransactionDetailsView(
            controller:WiredTransactionDetailsController)
        {
            this._controller = controller;
            this._window = controller.roomEvents.windowManager.buildFromXML(XML(
                controller.roomEvents.assets.getAssetByName(
                    "transaction_details_xml").content), 1) as IFrameWindow;
            this.closeButton.addEventListener("WME_CLICK", this.onClose);
            this.extraButton.addEventListener("WME_CLICK", this.onExtra);
            this._withdrawals = new TransactionOverviewView(
                this._window.findChildByName("withdrawals_container")
                    as IWindowContainer);
            this._deposits = new TransactionOverviewView(
                this._window.findChildByName("deposits_container")
                    as IWindowContainer);
            this._extraBubble = this._window.findChildByName("extra_info_bubble")
                as IWindowContainer;
            this._window.desktop.addChild(this._extraBubble);
            this._extraBubble.visible = false;
            this._extraBubble.addEventListener("WE_DEACTIVATED",
                this.onBubbleDeactivated);
            this.hide();
        }

        public function updateUI():void
        {
            var details:WiredTransactionDetails = this._controller.details;
            if (details == null) { return; }
            this.value("transaction_type").text = this.loc(
                "wired_transactions.type." + details.info.transactionType);
            this.value("timestamp").text = details.info.readableTimestamp;
            this.value("room_id").text = String(details.info.roomId);
            this.value("chest_ids").text = details.chestIds.join(", ");
            this.value("username").text = details.info.username;
            this.value("extra").text = details.info.transactionDefinitionInfo == ""
                ? "-" : details.info.transactionDefinitionInfo;
            this._withdrawals.initialize(details.info.withdrawCoinsCount,
                details.withdrawnFurnis, details.info.withdrawFurniCount,
                details.incompleteData);
            this._deposits.initialize(details.info.depositCoinsCount,
                details.depositedFurnis, details.info.depositFurniCount,
                details.incompleteData);
            this._extraBubble.visible = false;
            this._window.activate();
        }
        public function show():void
        {
            if (this._window.parent == null)
            {
                this._controller.roomEvents.windowManager.getDesktop(1)
                    .addChild(this._window);
                this._window.center();
            }
        }
        public function hide():void
        {
            if (this._window.parent != null)
            {
                this._controller.roomEvents.windowManager.getDesktop(1)
                    .removeChild(this._window);
            }
            this._extraBubble.visible = false;
            this._withdrawals.clear();
            this._deposits.clear();
        }
        private function onClose(event:WindowMouseEvent):void { this.hide(); }
        private function onBubbleDeactivated(event:WindowEvent):void
        {
            this._extraBubble.visible = false;
        }
        private function onExtra(event:WindowMouseEvent):void
        {
            var rectangle:Rectangle = new Rectangle();
            this.extraButton.getGlobalRectangle(rectangle);
            this._extraBubble.position = new Point(
                rectangle.x + rectangle.width + 3,
                rectangle.y + rectangle.height / 2 - this._extraBubble.height / 2);
            this._extraBubble.visible = true;
            this._extraBubble.activate();
        }
        private function value(name:String):ITextWindow
        {
            var pair:IItemListWindow = this._window.findChildByName(name + "_pair")
                as IItemListWindow;
            return pair.getListItemAt(1) as ITextWindow;
        }
        private function loc(key:String):String
        {
            return this._controller.roomEvents.localization.getLocalization(key, key);
        }
        private function get closeButton():IWindow
        {
            return this._window.findChildByName("header_button_close");
        }
        private function get extraButton():IRegionWindow
        {
            return this._window.findChildByName("extra_info_button")
                as IRegionWindow;
        }
        public function dispose():void
        {
            if (this._disposed) { return; }
            this._extraBubble.dispose();
            this._extraBubble = null;
            this._withdrawals.dispose();
            this._deposits.dispose();
            this._withdrawals = null;
            this._deposits = null;
            this._window.dispose();
            this._window = null;
            this._controller = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
