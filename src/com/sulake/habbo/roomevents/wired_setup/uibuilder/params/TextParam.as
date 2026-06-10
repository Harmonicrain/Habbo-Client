package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    public class TextParam
    {
        public static const NO_COLOR_OVERRIDE:uint = 0;
        public static const MODE_STRETCH:int = 0;
        public static const MODE_MULTILINE:int = 1;
        public static const MODE_OVERFLOW:int = 2;
        public static const DEFAULT:TextParam = new TextParam(1, false);

        private var _mode:int;
        private var _bold:Boolean;
        private var _maxLines:int;
        private var _underline:Boolean;
        private var _alignment:String;
        private var _fontSize:int = -1;
        private var _textColor:uint = 0;

        public function TextParam(_arg_1:int, _arg_2:Boolean = false, _arg_3:int = 0, _arg_4:Boolean = false, _arg_5:String = null)
        {
            super();
            this._mode = _arg_1;
            this._bold = _arg_2;
            this._maxLines = _arg_3;
            this._underline = _arg_4;
            this._alignment = _arg_5;
        }

        public function get mode():int { return this._mode; }
        public function get bold():Boolean { return this._bold; }
        public function get maxLines():int { return this._maxLines; }
        public function get underline():Boolean { return this._underline; }
        public function get alignment():String { return this._alignment; }
        public function get fontSize():int { return this._fontSize; }
        public function set fontSize(_arg_1:int):void { this._fontSize = _arg_1; }
        public function get textColor():uint { return this._textColor; }
        public function set textColor(_arg_1:uint):void { this._textColor = _arg_1; }
    }
}
