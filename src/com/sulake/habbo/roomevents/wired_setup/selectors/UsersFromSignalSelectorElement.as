package com.sulake.habbo.roomevents.wired_setup.selectors
{
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

    /** July AIR selector 10. Filter and invert remain selector-level advanced options. */
    public class UsersFromSignalSelectorElement extends DefaultElement
    {
        override public function get code():int
        {
            return SelectorCodes.USERS_FROM_SIGNAL;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.SIGNALS;
        }
    }
}
