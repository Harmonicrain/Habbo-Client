package com.sulake.habbo.roomevents.wired_setup.selectors
{
    import com.sulake.habbo.roomevents.wired_setup.common.UserActionElement;

    public class UsersByActionSelectorElement extends UserActionElement
    {
        public function UsersByActionSelectorElement()
        {
            super(SelectorCodes.USERS_PERFORMING_ACTION);
        }
    }
}
