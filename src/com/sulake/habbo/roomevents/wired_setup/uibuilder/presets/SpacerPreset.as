package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class SpacerPreset extends WiredUIPreset
    {
        private var _container:IWindow;

        public function SpacerPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:int)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("container_view");
            this._container.height = _arg_4;
        }

        public function set backgroundEnabled(_arg_1:Boolean):void
        {
            this._container.background = _arg_1;
        }

        public function set backgroundColor(_arg_1:int):void
        {
            this._container.color = (0xFF000000 | _arg_1);
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

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
        }
    }
}
