package com.sulake.habbo.roomevents.wired_setup.selectors
{
    import com.sulake.habbo.roomevents.wired_setup.conditions.ActorHasHandItemConditionElement;

    public class UsersWithHanditemSelectorElement extends ActorHasHandItemConditionElement
    {
        override public function get code():int { return SelectorCodes.USERS_WITH_HANDITEM; }
    }
}
