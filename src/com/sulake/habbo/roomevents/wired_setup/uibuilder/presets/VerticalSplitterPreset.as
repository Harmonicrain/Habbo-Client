package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class VerticalSplitterPreset extends WiredUIPreset
    {
        private static const SPLITTER_WIDTH:int = 1;

        private var _window:IWindowContainer;
        private var _height:int;

        public function VerticalSplitterPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:int)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._height = _arg_4;
            this._window = _arg_2.createLayout("container_view") as IWindowContainer;
            this._window.width = SPLITTER_WIDTH;
            this._window.height = this._height;
            this._window.background = true;
            this._window.color = _arg_3.verticalSplitterColor;
        }

        override public function get window():IWindow
        {
            return this._window;
        }

        override public function hasStaticWidth():Boolean
        {
            return true;
        }

        override public function get staticWidth():int
        {
            return SPLITTER_WIDTH;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._window.width = SPLITTER_WIDTH;
            this._window.height = this._height;
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
