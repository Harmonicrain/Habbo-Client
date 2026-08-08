package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    public class TextInputParam
    {
        public static var DEFAULT:TextInputParam = new TextInputParam();

        private var _initialText:String;
        private var _maxCharacters:int;
        private var _placeholder:String;
        private var _width:int;
        private var _restrict:String;
        private var _editable:Boolean;
        private var _tooltip:String;

        public function TextInputParam(_arg_1:String = "", _arg_2:int = 1000, _arg_3:String = null, _arg_4:int = -1, _arg_5:String = null, _arg_6:Boolean = true, _arg_7:String = null)
        {
            super();
            this._initialText = _arg_1;
            this._maxCharacters = _arg_2;
            this._placeholder = _arg_3;
            this._width = _arg_4;
            this._restrict = _arg_5;
            this._editable = _arg_6;
            this._tooltip = _arg_7;
        }

        public function get initialText():String { return this._initialText; }
        public function get maxCharacters():int { return this._maxCharacters; }
        public function get placeholder():String { return this._placeholder; }
        public function get width():int { return this._width; }
        public function get restrict():String { return this._restrict; }
        public function get editable():Boolean { return this._editable; }
        public function get tooltip():String { return this._tooltip; }
    }
}
