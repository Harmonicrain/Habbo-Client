package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class RemoveFurniActionElement extends DefaultElement
    {
        override public function get code():int { return ActionTypeCodes.REMOVE_FURNI; }

        override public function advancedAlwaysVisible():Boolean { return true; }
    }
}
