package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

    public class AvatarWalksOnFurniElement extends SimpleTriggerElement
    {
        public function AvatarWalksOnFurniElement()
        {
            super(WiredTriggerType.AVATAR_WALKS_ON_FURNI);
        }

        override public function get requiresFurniSelection():Boolean
        {
            return true;
        }
    }
}
