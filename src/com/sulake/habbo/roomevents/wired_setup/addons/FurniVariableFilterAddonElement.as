package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;

    /** July addon 12: sort/filter a furniture-variable selector result. */
    public class FurniVariableFilterAddonElement extends VariableFilterAddonElement
    {
        override public function get code():int { return AddonCodes.FURNI_VARIABLE_FILTER; }
        override protected function get variableTarget():int { return WiredInputSourcePicker.FURNI_SOURCE; }
    }
}
