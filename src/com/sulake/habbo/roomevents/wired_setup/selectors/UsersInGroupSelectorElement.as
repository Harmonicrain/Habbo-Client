package com.sulake.habbo.roomevents.wired_setup.selectors
{
    import com.sulake.habbo.roomevents.wired_setup.conditions.ActorIsInGroupConditionElement;

    public class UsersInGroupSelectorElement extends ActorIsInGroupConditionElement
    {
        override public function get code():int { return SelectorCodes.USERS_IN_GROUP; }
        override public function get negativeCode():int { return -1; }
    }
}
