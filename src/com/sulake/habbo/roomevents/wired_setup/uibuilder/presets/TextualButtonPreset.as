package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class TextualButtonPreset extends WiredUIPreset
    {
        private var _container:IWindowContainer;
        private var _textPreset:TextPreset;
        private var _onClick:Function;

        public function TextualButtonPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:Function)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._onClick = _arg_5;
            this._container = _arg_2.createLayout("growing_container_view") as IWindowContainer;
            this._textPreset = _arg_2.createText(_arg_4, new TextParam(0, false, 0, true));
            this._container.addChild(this._textPreset.window);
            this._container.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._container.mouseThreshold = 0;
        }

        public function set text(_arg_1:String):void
        {
            this._textPreset.text = _arg_1;
        }

        private function onClick(_arg_1:WindowMouseEvent):void
        {
            this._onClick();
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

        override protected function get childPresets():Array
        {
            return [this._textPreset];
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
            this._textPreset = null;
            this._onClick = null;
        }
    }
}
