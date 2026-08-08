package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;

    /** July addon 13: sort/filter a user-variable selector result. */
    public class UserVariableFilterAddonElement extends VariableFilterAddonElement
    {
        override public function get code():int { return AddonCodes.USER_VARIABLE_FILTER; }
        override protected function get variableTarget():int { return WiredInputSourcePicker.USER_SOURCE; }
    }
}
