package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class TextPreset extends WiredUIPreset
    {
        private var _param:TextParam;
        protected var _window:ITextWindow;

        public function TextPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:TextParam)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._param = _arg_5;
            this._window = this.createView();
            if (this._param.fontSize != -1)
            {
                this._window.fontSize = this._param.fontSize;
            }
            if (this._param.textColor != 0)
            {
                this._window.textColor = this._param.textColor;
            }
            this._window.text = _arg_4;
            this.initializeMode(_arg_5);
        }

        protected function initializeMode(_arg_1:TextParam):void
        {
            if (_arg_1.mode == TextParam.MODE_MULTILINE)
            {
                this._window.multiline = true;
                this._window.wordWrap = true;
                this._window.maxLines = _arg_1.maxLines;
                if (_arg_1.alignment != null)
                {
                    this._window.autoSize = _arg_1.alignment;
                }
            }
            if (_arg_1.mode == TextParam.MODE_OVERFLOW)
            {
                this._window.overflowReplace = "...";
                this._window.autoSize = "none";
            }
        }

        protected function createView():ITextWindow
        {
            var _local_1:ITextWindow = _style.createTextView(this._param.bold);
            _local_1.underline = this._param.underline;
            return _local_1;
        }

        public function get text():String
        {
            return this._window.text;
        }

        public function set text(_arg_1:String):void
        {
            this._window.text = _arg_1;
        }

        override public function hasStaticWidth():Boolean
        {
            return this.canStretch;
        }

        override public function get staticWidth():int
        {
            if (this.canStretch)
            {
                return this._window.width;
            }
            throw new Exception("Non stretching text has no static width");
        }

        override public function get window():IWindow
        {
            return this._window;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            if (!this.canStretch)
            {
                this._window.width = _arg_1;
            }
        }

        public function get canStretch():Boolean
        {
            return this._param.mode == TextParam.MODE_STRETCH;
        }

        public function get width():int
        {
            return this._window.width;
        }

        public function get fontSize():int
        {
            return (this._window as ITextWindow).fontSize;
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
            this._param = null;
        }
    }
}
