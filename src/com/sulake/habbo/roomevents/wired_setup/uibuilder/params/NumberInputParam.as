package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    public class NumberInputParam
    {
        public static var DEFAULT:TextInputParam = new TextInputParam();

        private var _initialValue:int;
        private var _min:int;
        private var _max:int;
        private var _width:int;
        private var _precision:int;
        private var _endsWithFive:Boolean;
        private var _nonDecimalNotations:Boolean;
        private var _tooltip:String;

        public function NumberInputParam(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int = 45, _arg_5:int = 0, _arg_6:Boolean = false, _arg_7:Boolean = false, _arg_8:String = null)
        {
            super();
            this._initialValue = _arg_1;
            this._min = _arg_2;
            this._max = _arg_3;
            this._precision = _arg_5;
            this._endsWithFive = _arg_6;
            this._width = _arg_4;
            this._nonDecimalNotations = _arg_7;
            this._tooltip = _arg_8;
        }

        public function get initialValue():int { return this._initialValue; }
        public function get min():int { return this._min; }
        public function get max():int { return this._max; }
        public function get precision():int { return this._precision; }
        public function get endsWithFive():Boolean { return this._endsWithFive; }
        public function get width():int { return this._width; }
        public function get nonDecimalNotations():Boolean { return this._nonDecimalNotations; }
        public function get tooltip():String { return this._tooltip; }
    }
}
