package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class PaddedContainerPreset extends WiredUIPreset
    {
        protected var _window:IWindowContainer;
        private var _subPreset:WiredUIPreset;
        private var _left:int;
        private var _top:int;
        private var _right:int;
        private var _bottom:int;
        private var _stretchMode:Boolean;
        private var _cachedWidth:int;
        private var _ignoreListeners:Boolean = false;

        public function PaddedContainerPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:WiredUIPreset, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:int, _arg_9:IWindowContainer = null, _arg_10:Boolean = false)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._left = _arg_5;
            this._top = _arg_6;
            this._right = _arg_7;
            this._bottom = _arg_8;
            this._stretchMode = _arg_10;
            this._window = _arg_9;
            if (this._window == null)
            {
                this._window = _arg_2.createLayout("growing_container_view") as IWindowContainer;
            }
            this._window.addChild(_arg_4.window);
            this._subPreset = _arg_4;
            this._subPreset.window.x = this._left;
            this._subPreset.window.y = this._top;
            this._subPreset.window.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onResizeListener);
        }

        private function onResizeListener(_arg_1:WindowEvent):void
        {
            if (this._ignoreListeners)
            {
                return;
            }
            this.resizeToWidth(this._cachedWidth);
        }

        override public function get window():IWindow
        {
            return this._window;
        }

        override protected function get childPresets():Array
        {
            return [this._subPreset];
        }

        override public function hasStaticWidth():Boolean
        {
            return this._stretchMode;
        }

        override public function get staticWidth():int
        {
            if (this._stretchMode)
            {
                return (this._subPreset.window.width + this._left + this._right);
            }
            return -1;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            this._cachedWidth = _arg_1;
            this._ignoreListeners = true;
            if (this._stretchMode)
            {
                _arg_1 = this.staticWidth;
            }
            super.resizeToWidth(_arg_1);
            this._window.width = _arg_1;
            this._subPreset.resizeToWidth((_arg_1 - this._left) - this._right);
            this._window.height = ((this._subPreset.window.height + this._top) + this._bottom);
            this._ignoreListeners = false;
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            this._subPreset.window.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onResizeListener);
            super.dispose();
            this._window.dispose();
            this._window = null;
            this._subPreset = null;
        }
    }
}
