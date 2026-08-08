package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    public class FurniPickingActionElement extends SimpleActionElement
    {
        public function FurniPickingActionElement(_arg_1:int)
        {
            super(_arg_1);
        }

        override public function get requiresFurniSelection():Boolean
        {
            return true;
        }
    }
}
