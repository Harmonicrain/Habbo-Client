package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class WindowWrapperPreset extends WiredUIPreset
    {
        private var _window:IWindow;
        private var _staticWidth:Boolean;

        public function WindowWrapperPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:IWindow, _arg_5:Boolean)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._window = _arg_4;
            this._staticWidth = _arg_5;
        }

        override public function get window():IWindow
        {
            return this._window;
        }

        override public function hasStaticWidth():Boolean
        {
            return this._staticWidth;
        }

        override public function get staticWidth():int
        {
            if (!this._staticWidth)
            {
                return -1;
            }
            return this._window.width;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._window.width = _arg_1;
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._window.dispose();
            this._window = null;
        }
    }
}
