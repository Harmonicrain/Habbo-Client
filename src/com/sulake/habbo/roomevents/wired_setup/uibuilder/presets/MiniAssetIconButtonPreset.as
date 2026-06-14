package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class MiniAssetIconButtonPreset extends WiredUIPreset
    {
        private static const COLOR_BLUE_CLICKED:uint = 4409728;
        private static const COLOR_YELLOW_CLICKED:uint = 6975025;
        private static const YELLOW_ASSETS:Array = ["furni_picks_1"];
        private static const BLUE_ASSETS:Array = ["furni_picks_2"];

        protected var _container:IWindowContainer;
        protected var _selected:Boolean;
        protected var _hovered:Boolean;
        protected var _assetName:String;
        private var _onClick:Function;

        public function MiniAssetIconButtonPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:String, _arg_6:Function)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._assetName = _arg_4;
            this._container = _arg_3.createMiniButton() as IWindowContainer;
            this._onClick = _arg_6;
            this.iconWrapper.assetUri = resolveAssetFullName(_arg_4);
            this.clickArea.addEventListener(WindowMouseEvent.OVER, this.onHoverStart);
            this.clickArea.addEventListener(WindowMouseEvent.OUT, this.onHoverEnd);
            this.clickArea.addEventListener(WindowMouseEvent.CLICK, this.iconClicked);
            this.clickArea.toolTipCaption = _arg_5;
            this.updateUI();
        }

        private function onHoverEnd(_arg_1:WindowMouseEvent):void
        {
            this._hovered = false;
            this.updateUI();
        }

        private function onHoverStart(_arg_1:WindowMouseEvent):void
        {
            this._hovered = true;
            this.updateUI();
        }

        public function get selected():Boolean
        {
            return this._selected;
        }

        public function set selected(_arg_1:Boolean):void
        {
            this._selected = _arg_1;
            this.updateUI();
        }

        protected function get selectedColor():uint
        {
            if (YELLOW_ASSETS.indexOf(this._assetName) != -1)
            {
                return COLOR_YELLOW_CLICKED;
            }
            if (BLUE_ASSETS.indexOf(this._assetName) != -1)
            {
                return COLOR_BLUE_CLICKED;
            }
            return 0xFFFFFF;
        }

        protected function updateUI():void
        {
        }

        protected function iconClicked(_arg_1:WindowMouseEvent):void
        {
            if ((this._onClick != null) && !this._selected)
            {
                this._onClick();
            }
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
        }

        override public function hasStaticWidth():Boolean
        {
            return true;
        }

        override public function get staticWidth():int
        {
            return this._container.width;
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._assetName = null;
            this._onClick = null;
        }

        protected function get clickArea():IInteractiveWindow
        {
            return this._container.findChildByName("mini_button_click") as IInteractiveWindow;
        }

        private function get iconWrapper():IStaticBitmapWrapperWindow
        {
            return this._container.findChildByName("mini_button_icon") as IStaticBitmapWrapperWindow;
        }
    }
}
