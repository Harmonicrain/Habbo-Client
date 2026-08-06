package com.sulake.habbo.roomevents.wired_setup.selectors
{
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;

    /** July AIR selector 18: choose users whose selected variable matches a value. */
    public class UsersWithVariableSelectorElement extends VariableSelectorElement
    {
        override public function get code():int { return SelectorCodes.USERS_WITH_VARIABLE; }
        override protected function get variableSource():int { return WiredInputSourcePicker.USER_SOURCE; }
    }
}
