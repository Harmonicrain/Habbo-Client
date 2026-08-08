package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

    public class SimpleActionElement extends DefaultElement
    {
        private var _code:int;
        private var _negativeCode:int;

        public function SimpleActionElement(_arg_1:int, _arg_2:int = -1)
        {
            super();
            this._code = _arg_1;
            this._negativeCode = _arg_2;
        }

        override public function get negativeCode():int
        {
            return this._negativeCode;
        }

        override public function get code():int
        {
            return this._code;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }
    }
}
