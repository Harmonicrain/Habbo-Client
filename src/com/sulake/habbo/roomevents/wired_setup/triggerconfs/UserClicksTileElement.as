package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

    /** July trigger 21 (wf_trg_click_tile) has no configurable inputs. */
    public class UserClicksTileElement extends SimpleTriggerElement
    {
        public function UserClicksTileElement()
        {
            super(WiredTriggerType.AVATAR_CLICKS_TILE);
        }
    }
}
