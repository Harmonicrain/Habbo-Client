package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

    public class ToggleFurniElement extends SimpleTriggerElement
    {
        public function ToggleFurniElement()
        {
            super(WiredTriggerType.TOGGLE_FURNI);
        }

        override public function get requiresFurniSelection():Boolean
        {
            return true;
        }
    }
}
