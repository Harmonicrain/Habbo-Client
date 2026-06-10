package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class FloatVerticallyPreset extends WiredUIPreset
    {
        private var _window:IWindowContainer;
        private var _subPreset:WiredUIPreset;

        public function FloatVerticallyPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:WiredUIPreset)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._window = _arg_2.createLayout("container_view") as IWindowContainer;
            this._subPreset = _arg_4;
            this._window.addChild(this._subPreset.window);
            this._window.height = 1;
            this._window.width = this._subPreset.window.width;
            this._subPreset.window.setParamFlag(16, false);
        }

        override public function get window():IWindow
        {
            return this._window;
        }

        override public function hasStaticWidth():Boolean
        {
            return this._subPreset.hasStaticWidth();
        }

        override public function get staticWidth():int
        {
            return this._subPreset.staticWidth;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            if (!this._subPreset.hasStaticWidth())
            {
                this._window.width = _arg_1;
                this._subPreset.resizeToWidth(_arg_1);
            }
            else
            {
                this._subPreset.resizeToWidth(this._subPreset.staticWidth);
            }
        }

        override protected function get childPresets():Array
        {
            return [this._subPreset];
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
            this._subPreset = null;
        }
    }
}
