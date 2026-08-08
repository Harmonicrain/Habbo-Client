package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    /**
     * Source-type selector descriptor. The listener remains untyped because the
     * clean-client picker implementations expose different callback interfaces.
     */
    public class SourceTypeSelectorParam
    {
        private var _ids:Array;
        private var _currentSelection:int;
        private var _listener:Object;

        public function SourceTypeSelectorParam(_arg_1:Array, _arg_2:Object, _arg_3:int = 0)
        {
            super();
            this._ids = _arg_1;
            this._currentSelection = _arg_3;
            this._listener = _arg_2;
        }

        public function get ids():Array { return this._ids; }
        public function get currentSelection():int { return this._currentSelection; }
        public function get listener():Object { return this._listener; }
    }
}
