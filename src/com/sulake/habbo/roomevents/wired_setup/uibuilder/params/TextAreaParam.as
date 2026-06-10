package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    public class TextAreaParam
    {
        private var _height:int;
        private var _width:int;
        private var _maxLines:int;
        private var _maxCharactersPerLine:int;
        private var _maxCharacters:int;
        private var _initialText:String;
        private var _placeholder:String;
        private var _restrict:String;
        private var _editable:Boolean;
        private var _wordwrap:Boolean;
        private var _tooltip:String;

        public function TextAreaParam(_arg_1:int, _arg_2:int = -1, _arg_3:int = -1, _arg_4:int = -1, _arg_5:int = 1000, _arg_6:String = "", _arg_7:String = null, _arg_8:String = null, _arg_9:Boolean = true, _arg_10:Boolean = false, _arg_11:String = null)
        {
            super();
            this._height = _arg_1;
            this._width = _arg_2;
            this._maxLines = _arg_3;
            this._maxCharactersPerLine = _arg_4;
            this._maxCharacters = _arg_5;
            this._initialText = _arg_6;
            this._placeholder = _arg_7;
            this._restrict = _arg_8;
            this._editable = _arg_9;
            this._wordwrap = _arg_10;
            this._tooltip = _arg_11;
        }

        public function get height():int { return this._height; }
        public function get width():int { return this._width; }
        public function get maxLines():int { return this._maxLines; }
        public function get maxCharactersPerLine():int { return this._maxCharactersPerLine; }
        public function get maxCharacters():int { return this._maxCharacters; }
        public function get initialText():String { return this._initialText; }
        public function get placeholder():String { return this._placeholder; }
        public function get editable():Boolean { return this._editable; }
        public function get restrict():String { return this._restrict; }
        public function get wordwrap():Boolean { return this._wordwrap; }
        public function get tooltip():String { return this._tooltip; }
    }
}
