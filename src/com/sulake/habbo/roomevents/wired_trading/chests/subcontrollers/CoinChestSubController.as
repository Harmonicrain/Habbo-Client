package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestCoinBalanceMessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestCoinBalanceMessageParser;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.WithdrawChestCoinsMessageComposer;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_trading.chests.ChestType;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import com.sulake.habbo.session.furniture.IFurnitureData;

    public class CoinChestSubController extends AbstractChestSubController
    {
        public static const DARK_THEME_CHEST_NAMES:Array = ["wf_storage_coins1"];
        private var _view:IWindowContainer;
        private var _coins:int;
        private var _chestState:String = "zero";
        private var _theme:String = "light";
        private var _classNameCache:String;

        public function CoinChestSubController(parent:WiredChestController)
        {
            super(parent);
            this._view = roomEvents.getXmlWindow("coins_chest_contents") as IWindowContainer;
            if (this._view != null && this._view.parent != null)
            {
                this._view.parent = null;
            }
            this.addMessageEvent(new ChestCoinBalanceMessageEvent(this.onCoinsMessage));
            this.withdrawInput.restrict = "0-9";
            this.withdrawButton.addEventListener("WME_CLICK", this.onWithdrawClick);
        }
        private function onWithdrawClick(event:WindowMouseEvent):void
        {
            var amount:Number = parseInt(this.withdrawInput.text);
            if (!isNaN(amount) && amount > 0)
            {
                parentController.send(new WithdrawChestCoinsMessageComposer(
                    viewingChestId, int(amount)));
            }
        }
        private function onCoinsMessage(event:ChestCoinBalanceMessageEvent):void
        {
            var parser:ChestCoinBalanceMessageParser = event.getParser();
            if (parser.isUpdate)
            {
                if (parentController.activeChestId != parser.chestId) { return; }
            }
            else
            {
                if (parentController.requestedChestId != parser.chestId) { return; }
                this._classNameCache = null;
                parentController.setOpenStatus(parser.chestId, this);
            }
            this._coins = Math.max(0, parser.coins);
            this.coinAmountText.text = String(this._coins);
            this.balanceContainer.x = (this.balanceContainer.parent.width
                - this.balanceContainer.width) / 2;
            this._chestState = this._coins >= 100 ? "high"
                : this._coins >= 20 ? "medium" : this._coins >= 1 ? "low" : "zero";
            this.backgroundImage.assetUri = "wired_chests_images_" + this._theme
                + "_coins_chest_balance_" + this._chestState;
            wrapperView.updateUI();
        }
        override public function get type():int { return ChestType.COINS; }
        override public function get title():String { return localize("wiredchests.coin_chest"); }
        override public function get view():IWindowContainer { return this._view; }
        override public function get isEmpty():Boolean { return this._coins <= 0; }
        override public function get itemCount():int { return this._coins; }
        override public function clear():void { this._coins = 0; }
        override public function updateUI():void
        {
            Util.disableSection(this.withdrawButton, !canWithdraw || isEmpty);
            this._theme = DARK_THEME_CHEST_NAMES.indexOf(this.className) >= 0 ? "dark" : "light";
            this.backgroundImage.assetUri = "wired_chests_images_" + this._theme
                + "_coins_chest_balance_" + this._chestState;
        }
        public function get className():String
        {
            if (this._classNameCache != null) { return this._classNameCache; }
            if (wrapperView.viewingChestFurni == null) { return ""; }
            var typeId:int = wrapperView.viewingChestFurni.getModel()
                .getNumber("furniture_type_id");
            var data:IFurnitureData = parentController.sessionDataManager
                .getFloorItemData(typeId);
            this._classNameCache = data == null ? "" : data.className;
            return this._classNameCache;
        }
        override public function get allowResizing():Boolean { return false; }
        override public function dispose():void
        {
            if (disposed) { return; }
            if (this._view != null) { this._view.dispose(); }
            this._view = null;
            super.dispose();
        }
        private function get coinAmountText():ITextWindow
        {
            return this._view.findChildByName("coins_amount_txt") as ITextWindow;
        }
        private function get balanceContainer():IItemListWindow
        {
            return this._view.findChildByName("balance_container") as IItemListWindow;
        }
        private function get backgroundImage():IStaticBitmapWrapperWindow
        {
            return this._view.findChildByName("bg_img") as IStaticBitmapWrapperWindow;
        }
        private function get withdrawInput():ITextFieldWindow
        {
            return this._view.findChildByName("withdraw_input") as ITextFieldWindow;
        }
        private function get withdrawButton():IButtonWindow
        {
            return this._view.findChildByName("withdraw_btn") as IButtonWindow;
        }
    }
}
