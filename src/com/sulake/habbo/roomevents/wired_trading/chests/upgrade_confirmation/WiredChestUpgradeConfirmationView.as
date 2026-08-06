package com.sulake.habbo.roomevents.wired_trading.chests.upgrade_confirmation
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog.purse.IPurse;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestUpgradeResultMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.UpgradeChestMessageComposer;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_trading.chests.ChestType;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;

    public class WiredChestUpgradeConfirmationView implements IDisposable, IGetImageListener
    {
        private var _disposed:Boolean;
        private var _window:IWindowContainer;
        private var _controller:WiredChestController;
        private var _windowManager:IHabboWindowManager;
        private var _resultEvent:ChestUpgradeResultMessageEvent;
        private var _chestId:int;
        private var _chestType:int;
        private var _chestItemType:int;
        private var _capacityLevel:int;

        public function WiredChestUpgradeConfirmationView(controller:WiredChestController)
        {
            this._controller = controller;
            this._windowManager = controller.windowManager;
            this._window = this._windowManager.buildFromXML(XML(
                controller.assets.getAssetByName("chest_upgrade_xml").content), 1)
                as IWindowContainer;
            this.closeButton.addEventListener("WME_CLICK", this.onWindowClose);
            this.cancelButton.addEventListener("WME_CLICK", this.onWindowClose);
            this.buyButton.addEventListener("WME_CLICK", this.onBuyClicked);
            this.amountSelection.addEventListener("WE_SELECTED", this.onAmountSelected);
            this._resultEvent = new ChestUpgradeResultMessageEvent(this.onUpgradeResult);
            controller.addMessageEvent(this._resultEvent);
        }
        private function onUpgradeResult(event:ChestUpgradeResultMessageEvent):void
        {
            if (event.getParser().chestId != this._chestId) { return; }
            var code:int = event.getParser().resultCode;
            if (code == 0)
            {
                this._controller.roomEvents.notifications.addItem(
                    "${wiredchests.upgrade.result.success}", "info");
            }
            else
            {
                var reason:String = this._controller.localization.getLocalization(
                    "wiredchests.upgrade.result.error." + code);
                this._controller.roomEvents.notifications.addItem(
                    this._controller.localization.getLocalizationWithParams(
                        "wiredchests.upgrade.result.error", "", "reason", reason), "info");
            }
            this.hide();
        }
        private function onBuyClicked(event:WindowMouseEvent):void
        {
            this.buyButton.disable();
            this._controller.send(new UpgradeChestMessageComposer(
                this._chestId, this.amountSelection.selection + 1));
        }
        public function initialize(chestId:int, chestType:int, chestItemType:int,
            capacityLevel:int):void
        {
            this._chestId = chestId;
            this._chestType = chestType;
            this._chestItemType = chestItemType;
            this._capacityLevel = capacityLevel;
            this.initializeDropMenu();
            this.updateUI();
        }
        private function initializeDropMenu():void
        {
            var kind:String = this._chestType == ChestType.COINS ? "coins" : "furni";
            var maxUpgrades:int = this._controller.getInteger(
                "wired." + kind + "_chest.max_upgrades", 0);
            var values:Array = ["1"];
            var levels:int = 2;
            var nextLevel:int = this._capacityLevel + 2;
            while (nextLevel <= maxUpgrades)
            {
                values.push(String(levels++));
                nextLevel++;
            }
            this.amountSelection.populate(values);
            this.amountSelection.selection = 0;
            Util.disableSection(this.amountSelection, this._capacityLevel >= maxUpgrades);
        }
        private function onAmountSelected(event:WindowEvent):void { this.updateUI(); }
        private function updateUI():void
        {
            var levels:int = this.amountSelection.selection + 1;
            this.buyButton.enable();
            this.cancelButton.enable();
            var image:ImageResult = this._controller.roomEngine.getFurnitureImage(
                this._chestItemType, new Vector3d(90, 0, 0), 64, this);
            if (image.data != null) { this.showChestPreview(image.data); }
            var kind:String = this._chestType == ChestType.COINS ? "coins" : "furni";
            var initial:int = this._controller.getInteger(
                "wired." + kind + "_chest.initial_capacity", 0);
            var increment:int = this._controller.getInteger(
                "wired." + kind + "_chest.upgrade_capacity", 0);
            var maxUpgrades:int = this._controller.getInteger(
                "wired." + kind + "_chest.max_upgrades", 0);
            var creditCost:int = this._controller.getInteger(
                "wired.chests.upgrade_cost_credits", 999);
            var diamondCost:int = this._controller.getInteger(
                "wired.chests.upgrade_cost_diamonds", 999);
            var errorKey:String;
            var purse:IPurse = this._controller.catalog == null
                ? null : this._controller.catalog.getPurse();
            if (this._capacityLevel >= maxUpgrades)
            {
                errorKey = "wiredchests.upgrade.error.reason.at_capacity";
            }
            else if (purse != null && (purse.credits < creditCost * levels
                || purse.getActivityPointsForType(5) < diamondCost * levels))
            {
                errorKey = "wiredchests.upgrade.error.reason.not_enough_currency";
            }
            var current:int = initial + this._capacityLevel * increment;
            var extra:int = increment * levels;
            this.productNameText.text = this._controller.localization.getLocalizationWithParams(
                "wiredchests.upgrade.capacity.extra", "", "purchase_capacity", extra);
            this.currentCapacityText.text =
                this._controller.localization.getLocalizationWithParams(
                    "wiredchests.upgrade.capacity.current", "", "current_capacity", current);
            this.newCapacityText.text = this._controller.localization.getLocalizationWithParams(
                "wiredchests.upgrade.capacity.new", "", "new_capacity", current + extra);
            this.priceCreditsText.text = String(creditCost * levels);
            this.priceDiamondsText.text = String(diamondCost * levels);
            this.priceCreditsText.visible = creditCost != 0;
            this.priceDiamondsText.visible = diamondCost != 0;
            this.pricePlusText.visible = creditCost != 0 && diamondCost != 0;
            this.errorText.visible = errorKey != null;
            if (errorKey != null)
            {
                this.buyButton.disable();
                this.errorText.text = this._controller.localization.getLocalizationWithParams(
                    "wiredchests.upgrade.error", "", "reason",
                    this._controller.localization.getLocalization(errorKey));
            }
        }
        private function showChestPreview(bitmap:BitmapData):void
        {
            this.productImage.bitmap = bitmap;
        }
        public function show():void
        {
            if (this._window.parent == null)
            {
                var desktop:IDesktopWindow = this._windowManager.getDesktop(1);
                if (desktop != null) { desktop.addChild(this._window); }
            }
            this._window.center();
            this._window.activate();
        }
        private function hide():void
        {
            if (this._window != null && this._window.parent != null)
            {
                var desktop:IDesktopWindow = this._windowManager.getDesktop(1);
                if (desktop != null) { desktop.removeChild(this._window); }
            }
        }
        private function onWindowClose(event:WindowEvent):void
        {
            if (event.type == "WME_CLICK") { this.hide(); }
        }
        public function imageReady(id:int, bitmap:BitmapData):void { this.showChestPreview(bitmap); }
        public function imageFailed(id:int):void { this.showChestPreview(null); }
        public function dispose():void
        {
            if (this._disposed) { return; }
            if (!this._controller.disposed)
            {
                this._controller.removeMessageEvent(this._resultEvent);
            }
            this._resultEvent.dispose();
            this.hide();
            this._window.dispose();
            this._window = null;
            this._windowManager = null;
            this._controller = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
        private function get closeButton():IWindow
        { return this._window.findChildByName("header_button_close"); }
        private function get productImage():IBitmapWrapperWindow
        { return this._window.findChildByName("product_image") as IBitmapWrapperWindow; }
        private function get productNameText():ITextWindow
        { return this._window.findChildByName("product_name") as ITextWindow; }
        private function get currentCapacityText():ITextWindow
        { return this._window.findChildByName("current_capacity") as ITextWindow; }
        private function get newCapacityText():ITextWindow
        { return this._window.findChildByName("new_capacity") as ITextWindow; }
        private function get amountSelection():IDropMenuWindow
        { return this._window.findChildByName("amount_selection_dropmenu") as IDropMenuWindow; }
        private function get priceCreditsText():ITextWindow
        { return this._window.findChildByName("price_credits") as ITextWindow; }
        private function get pricePlusText():ITextWindow
        { return this._window.findChildByName("plus") as ITextWindow; }
        private function get priceDiamondsText():ITextWindow
        { return this._window.findChildByName("price_diamonds") as ITextWindow; }
        private function get errorText():ITextWindow
        { return this._window.findChildByName("error_text") as ITextWindow; }
        private function get cancelButton():IButtonWindow
        { return this._window.findChildByName("cancel_button") as IButtonWindow; }
        private function get buyButton():IButtonWindow
        { return this._window.findChildByName("buy_button") as IButtonWindow; }
    }
}
