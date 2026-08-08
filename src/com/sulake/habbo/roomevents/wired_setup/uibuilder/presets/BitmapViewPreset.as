package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class BitmapViewPreset extends WiredUIPreset
    {
        private var _window:IBitmapWrapperWindow;
        private var _width:int;
        private var _height:int;

        public function BitmapViewPreset(roomEvents:HabboUserDefinedRoomEvents, presets:PresetManager, style:WiredStyle)
        {
            super(roomEvents, presets, style);
            this._window = presets.createLayout("bitmap_wrapper_view") as IBitmapWrapperWindow;
        }

        public function get bitmapWindow():IBitmapWrapperWindow { return this._window; }
        override public function get window():IWindow { return this._window; }
        override public function hasStaticWidth():Boolean { return true; }
        override public function get staticWidth():int { return this._width; }
        public function setBitmapSize(width:int, height:int):void { this._width = width; this._height = height; }

        override public function resizeToWidth(width:int):void
        {
            super.resizeToWidth(width);
            this._window.width = this._width;
            this._window.height = this._height;
        }

        override public function dispose():void
        {
            if (disposed) return;
            super.dispose();
            this._window.dispose();
            this._window = null;
        }
    }
}
