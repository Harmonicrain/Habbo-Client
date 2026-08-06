package com.sulake.habbo.roomevents.wired_setup.selectors
{
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;

    /** July AIR selector 17: choose furni whose selected variable matches a value. */
    public class FurniWithVariableSelectorElement extends VariableSelectorElement
    {
        override public function get code():int { return SelectorCodes.FURNI_WITH_VARIABLE; }
        override protected function get variableSource():int { return WiredInputSourcePicker.FURNI_SOURCE; }
    }
}
