package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

    /** July addon 2: parameterless effect-history modifier. */
    public class UnseenEffectAddonElement extends DefaultElement
    {
        override public function get code():int { return AddonCodes.UNSEEN_EFFECT; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.ADDONS; }
    }
}
