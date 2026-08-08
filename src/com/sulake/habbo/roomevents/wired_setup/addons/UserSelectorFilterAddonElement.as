package com.sulake.habbo.roomevents.wired_setup.addons
{
    /** July addon 11: filter the current user selector result. */
    public class UserSelectorFilterAddonElement extends SelectorFilterAddonElement
    {
        override public function get code():int { return AddonCodes.USER_SELECTOR_FILTER; }
    }
}
