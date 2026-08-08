package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class AlignRightWrapperPreset extends WiredUIPreset
    {
        private var _window:IWindowContainer;
        private var _subPreset:WiredUIPreset;

        public function AlignRightWrapperPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:WiredUIPreset)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._window = _arg_2.createLayout("growing_container_view") as IWindowContainer;
            this._subPreset = _arg_4;
            this._window.addChild(this._subPreset.window);
        }

        override public function get window():IWindow
        {
            return this._window;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:int;
            super.resizeToWidth(_arg_1);
            if (this._subPreset.hasStaticWidth())
            {
                _local_2 = this._subPreset.staticWidth;
                _local_3 = Math.max(0, _arg_1 - _local_2);
                this._subPreset.window.x = _local_3;
                this._subPreset.resizeToWidth(this._subPreset.staticWidth);
                return;
            }
            throw new Error("Attempting to align UI preset to the right is only possible if a static width is given");
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
