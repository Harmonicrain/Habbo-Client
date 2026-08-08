package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.roomevents.wired_setup.common.UserActionElement;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class PerformingActionConditionElement extends UserActionElement
    {
        public function PerformingActionConditionElement()
        {
            super(ConditionCodes.PERFORMING_ACTION, ConditionCodes.NOT_PERFORMING_ACTION);
        }
    }
}
