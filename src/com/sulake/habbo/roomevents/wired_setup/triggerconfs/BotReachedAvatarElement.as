package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

    public class BotReachedAvatarElement extends BotReachedStuffElement
    {
        public function BotReachedAvatarElement()
        {
            super();
        }

        override public function get code():int
        {
            return WiredTriggerType.BOT_REACHED_AVATAR;
        }
    }
}
