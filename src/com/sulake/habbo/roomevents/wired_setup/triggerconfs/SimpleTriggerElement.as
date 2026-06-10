package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

    public class SimpleTriggerElement extends DefaultElement
    {
        private var _code:int;

        public function SimpleTriggerElement(_arg_1:int)
        {
            super();
            this._code = _arg_1;
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
