package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

    /** July addon 6: parameterless movement-animation modifier. */
    public class NoMoveAnimationAddonElement extends DefaultElement
    {
        override public function get code():int { return AddonCodes.NO_MOVE_ANIMATION; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.ADDONS; }
    }
}
