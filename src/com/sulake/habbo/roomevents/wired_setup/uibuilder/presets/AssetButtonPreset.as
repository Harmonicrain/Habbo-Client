package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.InteractiveController;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class AssetButtonPreset extends WiredUIPreset
    {
        private var _container:IContainerButtonWindow;
        private var _onClick:Function;
        private var _selected:Boolean;
        private var _hovered:Boolean;
        private var _pressed:Boolean;

        public function AssetButtonPreset(roomEvents:HabboUserDefinedRoomEvents, presets:PresetManager, style:WiredStyle, assetName:String, tooltip:String, onClick:Function)
        {
            super(roomEvents, presets, style);
            this._onClick = onClick;
            this._container = style.createAssetButton();
            this.staticBitmap.assetUri = resolveAssetFullName(assetName);
            this._container.toolTipCaption = tooltip;
            this._container.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            this._container.addEventListener(WindowMouseEvent.OVER, this.onOver);
            this._container.addEventListener(WindowMouseEvent.OUT, this.onOut);
            this._container.addEventListener(WindowMouseEvent.OUT, this.maybeCancelEvent);
            this._container.addEventListener(WindowMouseEvent.UP, this.maybeCancelEvent);
            this._container.addEventListener(WindowMouseEvent.DOWN, this.onDown);
        }

        public function set assetName(value:String):void { this.staticBitmap.assetUri = resolveAssetFullName(value); }
        override public function get window():IWindow { return this._container; }

        private function onOut(event:WindowMouseEvent):void
        {
            if (!this._container.isEnabled()) return;
            this._hovered = false;
            this.updateVisuals();
        }

        private function onOver(event:WindowMouseEvent):void
        {
            if (!this._container.isEnabled()) return;
            this._hovered = true;
            this.updateVisuals();
        }

        private function onButtonClicked(event:WindowMouseEvent):void
        {
            if (this._onClick != null) this._onClick();
        }

        private function maybeCancelEvent(event:WindowMouseEvent):void
        {
            if (event.type == WindowMouseEvent.OUT && this._selected) event.preventWindowOperation();
            if (event.type == WindowMouseEvent.UP)
            {
                this._pressed = false;
                if (this._selected)
                {
                    this.onButtonClicked(null);
                    event.preventWindowOperation();
                }
            }
        }

        private function onDown(event:WindowMouseEvent):void { this._pressed = false; }

        private function updateVisuals():void
        {
            var controller:InteractiveController = InteractiveController(this._container);
            if (_style.isVolter)
            {
                controller.setStateFlag(16, this._pressed);
                controller.setStateFlag(4, this._hovered || this._selected);
            }
            else
            {
                controller.setStateFlag(16, this._selected);
                controller.setStateFlag(4, this._hovered);
            }
        }

        public function get selected():Boolean { return this._selected; }
        public function set selected(value:Boolean):void { this._selected = value; this.updateVisuals(); }
        override public function hasStaticWidth():Boolean { return true; }
        override public function get staticWidth():int { return this._container.width; }

        override public function dispose():void
        {
            if (disposed) return;
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._onClick = null;
        }

        private function get staticBitmap():IStaticBitmapWrapperWindow
        {
            return this._container.findChildByName("asset") as IStaticBitmapWrapperWindow;
        }
    }
}
