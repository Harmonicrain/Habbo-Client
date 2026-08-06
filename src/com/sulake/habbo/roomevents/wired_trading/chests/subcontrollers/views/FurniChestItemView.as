package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestStorage;
    import com.sulake.habbo.window.widgets.ILimitedItemGridOverlayWidget;
    import com.sulake.habbo.window.widgets.IProductIconWidget;
    import com.sulake.habbo.window.widgets._Str_11987;
    import __AS3__.vec.Vector;

    public class FurniChestItemView implements IDisposable
    {
        public static const NOT_HOVERED_COLOR:uint = 13355979;
        public static const HOVERED_COLOR:uint = 14079702;
        private var _disposed:Boolean;
        private var _storages:Vector.<ChestStorage>;
        private var _owner:FurniChestView;
        private var _active:Boolean;
        private var _hovered:Boolean;
        private var _window:IRegionWindow;

        public function FurniChestItemView(template:IRegionWindow)
        {
            this._window = template.clone() as IRegionWindow;
            this._window.addEventListener("WME_CLICK", this.onClick);
            this._window.addEventListener("WME_OVER", this.onOver);
            this._window.addEventListener("WME_OUT", this.onOut);
        }
        public function initialize(owner:FurniChestView,
            storages:Vector.<ChestStorage>):void
        {
            this._owner = owner;
            this._storages = storages;
            this.initializeUI();
        }
        private function initializeUI():void
        {
            var storage:ChestStorage = this.peek();
            if (storage == null) { return; }
            var limited:Boolean = storage.stuffData.uniqueSerialNumber > 0;
            this.ltdBackgroundBitmap.visible = limited;
            this.ltdOverlayWidget.visible = limited;
            if (limited)
            {
                var limitedWidget:ILimitedItemGridOverlayWidget =
                    this.ltdOverlayWidget.widget as ILimitedItemGridOverlayWidget;
                limitedWidget.serialNumber = storage.stuffData.uniqueSerialNumber;
                limitedWidget.seriesSize = storage.stuffData.uniqueSeriesSize;
            }
            var rare:Boolean = storage.specialType == 19;
            this.rarityOverlayWidget.visible = rare;
            if (rare)
            {
                (this.rarityOverlayWidget.widget as _Str_11987)
                    .rarityLevel = storage.stuffData.rarityLevel;
            }
            this.furniIcon.visible = true;
            (this.furniIcon.widget as IProductIconWidget).productInfo =
                new ChestItemTypeRenderableWrapper(storage.type);
            this.updateUI();
            this.updateColoring();
        }
        public function get window():IRegionWindow { return this._window; }
        public function get numItems():int { return this._storages == null ? 0 : this._storages.length; }
        public function peek():ChestStorage
        {
            return this.numItems == 0 ? null : this._storages[0];
        }
        public function remove(storage:ChestStorage):void
        {
            var index:int = this._storages.indexOf(storage);
            if (index >= 0) { this._storages.removeAt(index); }
            this.updateUI();
        }
        public function add(storage:ChestStorage):void
        {
            this._storages.push(storage);
            this.updateUI();
        }
        private function updateUI():void
        {
            this.numberContainer.visible = this.numItems > 1;
            if (this.numItems > 1) { this.furniQuantity.text = String(this.numItems); }
        }
        private function updateColoring():void
        {
            this.focusOutline.visible = this._active;
            this.border.color = this._hovered ? HOVERED_COLOR : NOT_HOVERED_COLOR;
        }
        private function onOut(event:WindowMouseEvent):void
        {
            this._hovered = false; this.updateColoring();
        }
        private function onOver(event:WindowMouseEvent):void
        {
            this._hovered = true; this.updateColoring();
        }
        private function onClick(event:WindowMouseEvent):void
        {
            if (this._owner != null) { this._owner.selectItemView(this); }
        }
        public function activate():void { this._active = true; this.updateColoring(); }
        public function deactivate():void { this._active = false; this.updateColoring(); }
        public function recycle():void
        {
            this._storages = null; this._active = false; this._hovered = false;
            this._owner = null;
        }
        public function dispose():void
        {
            if (this._disposed) { return; }
            this._storages = null;
            if (this._window != null) { this._window.dispose(); }
            this._window = null;
            this._owner = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
        private function get border():IBorderWindow
        {
            return this._window.findChildByName("border") as IBorderWindow;
        }
        private function get focusOutline():IStaticBitmapWrapperWindow
        {
            return this._window.findChildByName("outline_focus") as IStaticBitmapWrapperWindow;
        }
        private function get ltdBackgroundBitmap():IStaticBitmapWrapperWindow
        {
            return this._window.findChildByName("unique_item_background_bitmap")
                as IStaticBitmapWrapperWindow;
        }
        private function get furniIcon():IWidgetWindow
        {
            return this._window.findChildByName("furni_icon") as IWidgetWindow;
        }
        private function get numberContainer():IWindowContainer
        {
            return this._window.findChildByName("number_container") as IWindowContainer;
        }
        private function get furniQuantity():ITextWindow
        {
            return this._window.findChildByName("furni_quantity") as ITextWindow;
        }
        private function get ltdOverlayWidget():IWidgetWindow
        {
            return this._window.findChildByName("unique_item_overlay_container") as IWidgetWindow;
        }
        private function get rarityOverlayWidget():IWidgetWindow
        {
            return this._window.findChildByName("rarity_item_overlay_container") as IWidgetWindow;
        }
    }
}
