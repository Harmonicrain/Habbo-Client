package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class ButtonPreset extends WiredUIPreset
    {
        public static const MODE_SCALE:int = 0;
        public static const MODE_STRETCH:int = 1;

        private var _container:IButtonWindow;
        private var _mode:int;
        private var _onClick:Function;

        public function ButtonPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:Function, _arg_6:int = 0)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._onClick = _arg_5;
            this._container = _arg_3.createButton();
            this._container.caption = _arg_4;
            this._mode = _arg_6;
            this._container.addEventListener(WindowMouseEvent.CLICK, this.buttonClicked);
        }

        private function buttonClicked(_arg_1:WindowMouseEvent):void
        {
            if (this._onClick != null)
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
            if (this._mode == MODE_SCALE)
            {
                this._container.limits.minWidth = _arg_1;
                this._container.limits.maxWidth = _arg_1;
                this._container.width = _arg_1;
            }
        }

        override public function hasStaticWidth():Boolean
        {
            return this._mode == MODE_STRETCH;
        }

        override public function get staticWidth():int
        {
            if (this._mode == MODE_STRETCH)
            {
                return this._container.width;
            }
            return -1;
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
            this._onClick = null;
        }
    }
}
