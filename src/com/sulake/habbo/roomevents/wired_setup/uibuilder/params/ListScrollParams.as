package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    public class ListScrollParams
    {
        private var _alwaysShowScrollbar:Boolean;
        private var _minHeight:int;
        private var _maxHeight:int;
        private var _stickyFooter:Boolean;
        private var _stickyHeader:Boolean;

        public function ListScrollParams(_arg_1:Boolean, _arg_2:int, _arg_3:int, _arg_4:Boolean = false, _arg_5:Boolean = false)
        {
            super();
            this._alwaysShowScrollbar = _arg_1;
            this._minHeight = _arg_2;
            this._maxHeight = _arg_3;
            this._stickyFooter = _arg_4;
            this._stickyHeader = _arg_5;
        }

        public function get alwaysShowScrollbar():Boolean { return this._alwaysShowScrollbar; }
        public function get minHeight():int { return this._minHeight; }
        public function get maxHeight():int { return this._maxHeight; }
        public function get stickyFooter():Boolean { return this._stickyFooter; }
        public function get stickyHeader():Boolean { return this._stickyHeader; }
    }
}
