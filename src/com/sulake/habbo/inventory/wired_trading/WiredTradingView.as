package com.sulake.habbo.inventory.wired_trading
{
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.inventory.IInventoryView;
    import com.sulake.habbo.inventory.ItemPopupCtrl;
    import com.sulake.habbo.inventory.items.CreditTradingItem;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.BitmapData;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class WiredTradingView implements IInventoryView, IGetImageListener
    {
        private var _model:WiredTradingModel;
        private var _windowManager:IHabboWindowManager;
        private var _localization:IHabboLocalizationManager;
        private var _roomEngine:IRoomEngine;
        private var _assets:IAssetLibrary;
        private var _popup:ItemPopupCtrl;
        private var _confirmTimer:Timer;
        private var _secondsTimer:Timer;
        private var _window:IWindowContainer;
        private var _disposed:Boolean;

        public function WiredTradingView(
            model:WiredTradingModel,
            windowManager:IHabboWindowManager,
            assets:IAssetLibrary,
            roomEngine:IRoomEngine,
            localization:IHabboLocalizationManager,
            soundManager:IHabboSoundManager)
        {
            this._model = model;
            this._windowManager = windowManager;
            this._assets = assets;
            this._roomEngine = roomEngine;
            this._localization = localization;

            var popupWindow:IWindowContainer = windowManager.buildFromXML(
                XmlAsset(assets.getAssetByName("item_popup_xml")).content as XML)
                as IWindowContainer;
            popupWindow.visible = false;
            this._popup = new ItemPopupCtrl(
                popupWindow, assets, windowManager, model);
            this.createWindow();
        }

        private function createWindow():void
        {
            var xml:XML = XmlAsset(
                this._assets.getAssetByName("inventory_trading_wired_xml")).content
                as XML;
            this._window = this._windowManager.buildFromXML(xml)
                as IWindowContainer;
            this.prepareGrid(this.yourItemGrid, this.ownThumbEventProc);
            this.prepareGrid(this.wiredItemGrid, this.wiredThumbEventProc);
            this.acceptButton.addEventListener(
                WindowMouseEvent.CLICK, this.onAcceptClick);
            this.cancelButton.addEventListener(
                WindowMouseEvent.CLICK, this.onCancelClick);
            this.secondsLeftText.visible = false;
        }

        private function prepareGrid(grid:IItemGridWindow, handler:Function):void
        {
            for (var i:int = 0; i < grid.numGridItems; i++)
            {
                var item:IWindow = grid.getGridItemAt(i);
                item.id = i;
                item.procedure = handler;
                item.addEventListener(WindowMouseEvent.OVER, handler);
                item.addEventListener(WindowMouseEvent.OUT, handler);
            }
        }

        private function onCancelClick(event:WindowMouseEvent):void
        {
            this._model.requestCancelTrading();
        }

        private function onAcceptClick(event:WindowMouseEvent):void
        {
            if (this._model.state == WiredTradingModel.STATE_ADDING_ITEMS)
            {
                if (this._model.requestAccept())
                {
                    this.startConfirmCountdown();
                }
            }
            else if (this._model.state == WiredTradingModel.STATE_CONFIRMING)
            {
                this._model.requestConfirm();
            }
        }

        public function updateAllUI():void
        {
            if (this._window == null)
            {
                return;
            }
            this.updateUI();
            this.updateItemsGrid(this.yourItemGrid, this._model.ownItems);
            this.updateItemsGrid(this.wiredItemGrid, this._model.wiredItems);
            this.updateStateUI();
            this.updateOfferInfoUI();
        }

        private function updateUI():void
        {
            if (this._model.canAccept)
            {
                this.acceptButton.enable();
            }
            else
            {
                this.acceptButton.disable();
            }
            var payment:Boolean = this._model.isPayment();
            this.tradeTypeSplitter.assetUri = payment
                ? "inventory_trading_trading_arrow_icon"
                : "inventory_trading_trading_split_icon";
            if (payment && this._model.paymentLayoutType != null)
            {
                this.paymentLayoutImage.assetUri = "wired_chests_images_"
                    + this._model.paymentLayoutType + "_payments";
            }
            this.wiredOfferings.visible = !payment;
            this.wiredPaymentPlaceholder.visible = payment;
        }

        public function tradeStateUpdated():void
        {
            if (this._window != null)
            {
                this.updateStateUI();
            }
        }

        private function updateStateUI():void
        {
            var type:String = this._model.tradeTypeLocalization.toLowerCase();
            this.lockIcon.assetUri =
                this._model.state == WiredTradingModel.STATE_READY
                || this._model.state == WiredTradingModel.STATE_ADDING_ITEMS
                    ? "inventory_trading_trading_unlocked_icon"
                    : "inventory_trading_trading_locked_icon";

            if (this._model.state == WiredTradingModel.STATE_READY
                || this._model.state == WiredTradingModel.STATE_ADDING_ITEMS)
            {
                this.infoText.text =
                    this._localization.getLocalizationWithParams(
                        "inventory.wired_trading.note.add_items", "",
                        "type", type);
                this.acceptButton.caption =
                    this._localization.getLocalization("inventory.trading.accept");
            }
            else if (this._model.state == WiredTradingModel.STATE_COUNTDOWN)
            {
                this.infoText.text = this._localization.getLocalization(
                    "inventory.wired_trading.note.countdown");
                this.acceptButton.caption = "${inventory.trading.countdown}";
                this.acceptButton.disable();
            }
            else
            {
                this.infoText.text =
                    this._localization.getLocalizationWithParams(
                        "inventory.wired_trading.note.verify", "",
                        "type", type);
                this.acceptButton.caption =
                    this._localization.getLocalization("inventory.trading.confirm");
                if (this._model.state == WiredTradingModel.STATE_CONFIRMED)
                {
                    this.acceptButton.disable();
                }
                else
                {
                    this.acceptButton.enable();
                }
            }
        }

        public function startConfirmCountdown():void
        {
            if (this._confirmTimer == null)
            {
                this._confirmTimer = new Timer(1000, 3);
                this._confirmTimer.addEventListener(
                    TimerEvent.TIMER, this.onConfirmTimer);
            }
            this._confirmTimer.reset();
            this._confirmTimer.repeatCount = 3;
            this._confirmTimer.start();
            this._windowManager.registerLocalizationParameter(
                "inventory.trading.countdown", "counter", "3");
        }

        private function onConfirmTimer(event:TimerEvent):void
        {
            this._windowManager.registerLocalizationParameter(
                "inventory.trading.countdown", "counter",
                String(3 - this._confirmTimer.currentCount));
            if (this._confirmTimer.currentCount == 3)
            {
                this._model.confirmCountdownReady();
                this._confirmTimer.reset();
                this.acceptButton.enable();
            }
        }

        public function stopConfirmCountdown():void
        {
            if (this._confirmTimer != null)
            {
                this._confirmTimer.stop();
                this._confirmTimer.reset();
            }
        }

        public function startSecondsLeftTimer():void
        {
            if (this._secondsTimer == null)
            {
                this._secondsTimer = new Timer(1000);
                this._secondsTimer.addEventListener(
                    TimerEvent.TIMER, this.onSecondsTimer);
            }
            this._secondsTimer.reset();
            this._secondsTimer.start();
            this.updateSecondsLeftUI();
        }

        public function stopSecondsLeftTimer():void
        {
            if (this._secondsTimer != null)
            {
                this._secondsTimer.stop();
            }
        }

        private function onSecondsTimer(event:TimerEvent):void
        {
            this.updateSecondsLeftUI();
            if (this._model.secondsLeft <= 0)
            {
                this.stopSecondsLeftTimer();
            }
        }

        private function updateSecondsLeftUI():void
        {
            var left:int = this._model.secondsLeft;
            if (left >= 0 && left < 120)
            {
                this.secondsLeftText.visible = true;
                var minutes:int = left / 60;
                var seconds:int = left - minutes * 60;
                this.secondsLeftText.text =
                    this._localization.getLocalizationWithParams(
                        "inventory.wired_trading.seconds_left", "",
                        "seconds", seconds < 10 ? "0" + seconds : seconds,
                        "minutes", minutes);
            }
            else
            {
                this.secondsLeftText.visible = false;
            }
        }

        private function updateItemsGrid(grid:IItemGridWindow, items:Map):void
        {
            var i:int = 0;
            if (items != null)
            {
                while (i < items.length && i < grid.numGridItems)
                {
                    var group:GroupItem = items.getWithIndex(i) as GroupItem;
                    var cell:IWindowContainer =
                        grid.getGridItemAt(i) as IWindowContainer;
                    this.clearCell(cell);
                    if (group != null)
                    {
                        cell.addChild(group.window);
                        group.window.id = i;
                        group._Str_24322();
                    }
                    i++;
                }
            }
            while (i < grid.numGridItems)
            {
                cell = grid.getGridItemAt(i) as IWindowContainer;
                this.clearCell(cell);
                cell.invalidate();
                i++;
            }
        }

        private function clearCell(cell:IWindowContainer):void
        {
            if (cell == null)
            {
                return;
            }
            while (cell.numChildren > 0)
            {
                cell.removeChildAt(0);
            }
        }

        private function updateOfferInfoUI():void
        {
            this.yourItemCountText.text =
                this._localization.getLocalizationWithParams(
                    "inventory.trading.info.itemcount", "",
                    "value", this._model.ownNumItems);
            this.wiredItemCountText.text =
                this._localization.getLocalizationWithParams(
                    "inventory.trading.info.itemcount", "",
                    "value", this._model.wiredNumItems);
            this.yourCreditCountText.text =
                this._localization.getLocalizationWithParams(
                    "inventory.trading.info.creditvalue", "",
                    "value", this._model.ownNumCredits);
            this.wiredCreditCountText.text =
                this._localization.getLocalizationWithParams(
                    "inventory.trading.info.creditvalue", "",
                    "value", this._model.wiredNumCredits);
        }

        private function ownThumbEventProc(
            event:WindowEvent, window:IWindow):void
        {
            this.thumbEventProc(event, window, true);
        }

        private function wiredThumbEventProc(
            event:WindowEvent, window:IWindow):void
        {
            this.thumbEventProc(event, window, false);
        }

        private function thumbEventProc(
            event:WindowEvent, window:IWindow, own:Boolean):void
        {
            if (own && event.type == WindowMouseEvent.CLICK)
            {
                this._model.requestRemoveItemFromTrading(window.id);
            }
            if (event.type == WindowMouseEvent.OUT)
            {
                this._popup._Str_14093();
                return;
            }
            if (event.type != WindowMouseEvent.OVER)
            {
                return;
            }
            var items:Map = own ? this._model.ownItems : this._model.wiredItems;
            if (items == null || window.id < 0 || window.id >= items.length)
            {
                return;
            }
            var group:GroupItem = items.getWithIndex(window.id) as GroupItem;
            if (group == null)
            {
                return;
            }
            var credits:CreditTradingItem = group as CreditTradingItem;
            if (credits != null)
            {
                this._popup.updateContent(
                    window as IWindowContainer,
                    credits._Str_22574(), credits._Str_21010());
                this._popup.show();
                return;
            }
            var item:FurnitureItem = group._Str_3205();
            if (item == null)
            {
                return;
            }
            var title:String = item.isWallItem
                ? "${wallItem.name." + item.type + "}"
                : "${roomItem.name." + item.type + "}";
            if (item.category == 6)
            {
                title = "${poster_" + item.stuffData.getLegacyString() + "_name}";
            }
            this._popup.updateContent(
                window as IWindowContainer, title,
                this.resolveItemThumbnail(group), item.stuffData);
            this._popup.show();
        }

        private function resolveItemThumbnail(group:GroupItem):BitmapData
        {
            var bitmap:BitmapData = group.icon;
            if (bitmap != null)
            {
                return bitmap;
            }
            var result:ImageResult = group.isWallItem
                ? this._roomEngine.getWallItemIcon(
                    group.type, this, group.stuffData.getLegacyString())
                : this._roomEngine.getFurnitureIcon(
                    group.type, this, null, group.stuffData);
            if (result != null)
            {
                bitmap = result.data;
                group.icon = bitmap;
            }
            return bitmap;
        }

        public function imageReady(id:int, bitmap:BitmapData):void
        {
        }

        public function imageFailed(id:int):void
        {
        }

        public function alertTradeCancelled(reason:int):void
        {
            if (reason == WiredTradingModel.FAILURE_NONE)
            {
                return;
            }
            var title:String = this._localization.getLocalization(
                "wired_transactions.notification.fail.popup.title");
            var message:String =
                this._localization.getLocalizationWithParams(
                    "wired_transactions.notification.fail", "",
                    "reason", this._localization.getLocalization(
                        "wired_transactions.notification.fail." + reason));
            this._windowManager.alert(title, message, 0, null);
        }

        public function getWindowContainer():IWindowContainer
        {
            return this._window;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this.stopConfirmCountdown();
            if (this._confirmTimer != null)
            {
                this._confirmTimer.removeEventListener(
                    TimerEvent.TIMER, this.onConfirmTimer);
                this._confirmTimer = null;
            }
            this.stopSecondsLeftTimer();
            if (this._secondsTimer != null)
            {
                this._secondsTimer.removeEventListener(
                    TimerEvent.TIMER, this.onSecondsTimer);
                this._secondsTimer = null;
            }
            if (this._popup != null)
            {
                this._popup.dispose();
                this._popup = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._model = null;
            this._windowManager = null;
            this._localization = null;
            this._roomEngine = null;
            this._assets = null;
            this._disposed = true;
        }

        public function get disposed():Boolean { return this._disposed; }
        private function get infoText():ITextWindow
        { return this._window.findChildByName("info_text") as ITextWindow; }
        private function get tradeTypeSplitter():IStaticBitmapWrapperWindow
        { return this._window.findChildByName("trade_type_splitter") as IStaticBitmapWrapperWindow; }
        private function get lockIcon():IStaticBitmapWrapperWindow
        { return this._window.findChildByName("lock_0") as IStaticBitmapWrapperWindow; }
        private function get acceptButton():IButtonWindow
        { return this._window.findChildByName("button_accept") as IButtonWindow; }
        private function get cancelButton():IButtonWindow
        { return this._window.findChildByName("button_cancel") as IButtonWindow; }
        public function get requirementsButton():com.sulake.core.window.components.IRegionWindow
        { return this._window.findChildByName("requirements_button") as com.sulake.core.window.components.IRegionWindow; }
        private function get yourItemGrid():IItemGridWindow
        { return this._window.findChildByName("item_grid_0") as IItemGridWindow; }
        private function get wiredItemGrid():IItemGridWindow
        { return this._window.findChildByName("item_grid_1") as IItemGridWindow; }
        private function get yourItemCountText():ITextWindow
        { return this._window.findChildByName("content_text_1_a") as ITextWindow; }
        private function get yourCreditCountText():ITextWindow
        { return this._window.findChildByName("content_text_1_b") as ITextWindow; }
        private function get wiredItemCountText():ITextWindow
        { return this._window.findChildByName("content_text_2_a") as ITextWindow; }
        private function get wiredCreditCountText():ITextWindow
        { return this._window.findChildByName("content_text_2_b") as ITextWindow; }
        private function get wiredOfferings():IWindowContainer
        { return this._window.findChildByName("offers_1") as IWindowContainer; }
        private function get wiredPaymentPlaceholder():IWindowContainer
        { return this._window.findChildByName("offers_1_payment_placeholder") as IWindowContainer; }
        private function get paymentLayoutImage():IStaticBitmapWrapperWindow
        { return this._window.findChildByName("payment_layout_image") as IStaticBitmapWrapperWindow; }
        private function get secondsLeftText():ITextWindow
        { return this._window.findChildByName("seconds_left_text") as ITextWindow; }
    }
}
