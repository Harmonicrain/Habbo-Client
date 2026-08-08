package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class SpacingPreset extends WiredUIPreset
    {
        private var _container:IWindowContainer;

        public function SpacingPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Boolean, _arg_5:int)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("container_view") as IWindowContainer;
            if (_arg_4)
            {
                this._container.height = _arg_5;
            }
            else
            {
                this._container.width = _arg_5;
            }
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
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
        }
    }
}
