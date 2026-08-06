package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

    /**
     * Parameterless editor for the Execute In Order addon.
     *
     * July represents this addon with only its type code. The clean client's
     * dual-mode controller uses UI-builder mode to display the shared header and
     * save footer, so no addon-specific controls or values are added here.
     */
    public class ExecuteInOrderAddonElement extends DefaultElement
    {
        override public function get code():int
        {
            return AddonCodes.EXECUTE_IN_ORDER;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.ADDONS;
        }
    }
}
