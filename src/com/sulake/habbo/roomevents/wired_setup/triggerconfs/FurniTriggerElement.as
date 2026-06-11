package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    public class FurniTriggerElement extends SimpleTriggerElement
    {
        public function FurniTriggerElement(_arg_1:int)
        {
            super(_arg_1);
        }

        override public function get requiresFurniSelection():Boolean
        {
            return true;
        }
    }
}
