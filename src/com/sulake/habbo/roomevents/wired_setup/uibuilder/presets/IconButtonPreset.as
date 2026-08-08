package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class IconButtonPreset extends WiredUIPreset
    {
        private var _container:IWindow;
        private var _onClick:Function;

        public function IconButtonPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:Function)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_3.createIconButton(_arg_4);
            this._onClick = _arg_5;
            this._container.addEventListener(WindowMouseEvent.CLICK, this.iconClicked);
        }

        private function iconClicked(_arg_1:WindowMouseEvent):void
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
            this._container.width = _arg_1;
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
            this._onClick = null;
        }
    }
}
