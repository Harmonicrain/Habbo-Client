package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class CenteredContainerPreset extends WiredUIPreset
    {
        private var _window:IWindowContainer;
        private var _subPreset:WiredUIPreset;
        private var _topBottomMargin:int;
        private var _ignoreListeners:Boolean = false;

        public function CenteredContainerPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:WiredUIPreset, _arg_5:int, _arg_6:IWindowContainer = null)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._window = _arg_6;
            if (this._window == null)
            {
                this._window = _arg_2.createLayout("container_view") as IWindowContainer;
            }
            this._window.addChild(_arg_4.window);
            this._subPreset = _arg_4;
            this._subPreset.window.y = _arg_5;
            this._topBottomMargin = _arg_5;
            this._subPreset.window.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onResizeListener);
            if (!this._subPreset.hasStaticWidth())
            {
                throw new Error("CenteredContainerPreset only works with static with children");
            }
        }

        private function onResizeListener(_arg_1:WindowEvent):void
        {
            if (this._ignoreListeners)
            {
                return;
            }
            this.resizeToWidth(this._window.width);
        }

        override public function get window():IWindow
        {
            return this._window;
        }

        override protected function get childPresets():Array
        {
            return [this._subPreset];
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            this._ignoreListeners = true;
            super.resizeToWidth(_arg_1);
            this._window.width = _arg_1;
            this._subPreset.resizeToWidth(this._subPreset.staticWidth);
            this._window.height = (this._subPreset.window.height + (this._topBottomMargin * 2));
            this._subPreset.window.x = ((_arg_1 / 2) - (this._subPreset.staticWidth / 2));
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
