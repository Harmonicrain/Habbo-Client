package com.sulake.habbo.roomevents.wired_trading.chests.settings
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;

    /** July's dedicated confirmation window for enabling Wired on a chest. */
    public final class WiredChestWiredUpdateConfirmationView
        implements IDisposable, IGetImageListener
    {
        private var _disposed:Boolean;
        private var _window:IWindowContainer;
        private var _settings:ChestSettingsUI;
        private var _windowManager:IHabboWindowManager;
        private var _chestId:int;
        private var _chestType:int;
        private var _chestItemType:int;
        private var _starterChest:Boolean;

        public function WiredChestWiredUpdateConfirmationView(
            settings:ChestSettingsUI)
        {
            this._settings = settings;
            this._windowManager = settings.chestController.windowManager;
            var controller:WiredChestController = settings.chestController;
            this._window = this._windowManager.buildFromXML(XML(
                controller.assets.getAssetByName(
                    "chest_wired_upgrade_xml").content), 1)
                as IWindowContainer;
            this.closeButton.addEventListener("WME_CLICK", this.onWindowClose);
            this.cancelButton.addEventListener("WME_CLICK", this.onWindowClose);
            this.buyButton.addEventListener("WME_CLICK", this.onBuyClicked);
            this.hide();
        }

        public function initialize(chestId:int, chestType:int,
            chestItemType:int, starterChest:Boolean):void
        {
            this._chestId = chestId;
            this._chestType = chestType;
            this._chestItemType = chestItemType;
            this._starterChest = starterChest;
            this.updateUI();
        }

        private function updateUI():void
        {
            this.buyButton.enable();
            this.cancelButton.enable();
            var controller:WiredChestController = this._settings.chestController;
            var image:ImageResult = controller.roomEngine.getFurnitureImage(
                this._chestItemType, new Vector3d(90, 0, 0), 64, this);
            if (image.data != null)
            {
                this.showChestPreview(image.data);
            }
            var reason:String = this._starterChest
                ? "wiredchests.upgrade.wired.error.reason.rookie_chest"
                : null;
            this.errorText.visible = reason != null;
            if (reason != null)
            {
                this.buyButton.disable();
                this.errorText.text =
                    controller.localization.getLocalizationWithParams(
                        "wiredchests.upgrade.wired.error", "", "reason",
                        controller.localization.getLocalization(reason));
            }
        }

        private function onBuyClicked(event:WindowMouseEvent):void
        {
            this.buyButton.disable();
            this._settings.confirmUpgrade();
        }

        public function show():void
        {
            if (this._windowManager != null && this._window != null
                && this._window.parent == null)
            {
                var desktop:IDesktopWindow = this._windowManager.getDesktop(1);
                if (desktop != null)
                {
                    desktop.addChild(this._window);
                }
            }
            this._window.center();
            this._window.activate();
        }

        public function hide():void
        {
            if (this._windowManager != null && this._window != null
                && this._window.parent != null)
            {
                var desktop:IDesktopWindow = this._windowManager.getDesktop(1);
                if (desktop != null)
                {
                    desktop.removeChild(this._window);
                }
            }
        }

        private function onWindowClose(event:WindowEvent):void
        {
            if (event.type == "WME_CLICK")
            {
                this.hide();
            }
        }

        private function showChestPreview(bitmap:BitmapData):void
        {
            this.productImage.bitmap = bitmap;
        }

        public function imageReady(id:int, bitmap:BitmapData):void
        {
            this.showChestPreview(bitmap);
        }

        public function imageFailed(id:int):void
        {
            this.showChestPreview(null);
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this.hide();
            this._window.dispose();
            this._window = null;
            this._windowManager = null;
            this._settings = null;
            this._disposed = true;
        }

        public function get disposed():Boolean { return this._disposed; }

        private function get closeButton():IWindow
        { return this._window.findChildByName("header_button_close"); }
        private function get productImage():IBitmapWrapperWindow
        { return this._window.findChildByName("product_image") as IBitmapWrapperWindow; }
        private function get errorText():ITextWindow
        { return this._window.findChildByName("error_text") as ITextWindow; }
        private function get cancelButton():IButtonWindow
        { return this._window.findChildByName("cancel_button") as IButtonWindow; }
        private function get buyButton():IButtonWindow
        { return this._window.findChildByName("buy_button") as IButtonWindow; }
    }
}
