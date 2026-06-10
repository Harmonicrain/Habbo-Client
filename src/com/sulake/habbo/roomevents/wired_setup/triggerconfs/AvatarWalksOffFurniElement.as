package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

    public class AvatarWalksOffFurniElement extends SimpleTriggerElement
    {
        public function AvatarWalksOffFurniElement()
        {
            super(WiredTriggerType.AVATAR_WALKS_OFF_FURNI);
        }

        override public function get requiresFurniSelection():Boolean
        {
            return true;
        }
    }
}
