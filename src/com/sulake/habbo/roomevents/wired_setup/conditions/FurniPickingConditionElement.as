package com.sulake.habbo.roomevents.wired_setup.conditions
{
    public class FurniPickingConditionElement extends SimpleConditionElement
    {
        public function FurniPickingConditionElement(_arg_1:int, _arg_2:int = -1)
        {
            super(_arg_1, _arg_2);
        }

        override public function get requiresFurniSelection():Boolean
        {
            return true;
        }
    }
}
