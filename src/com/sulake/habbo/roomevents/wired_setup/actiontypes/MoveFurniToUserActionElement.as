package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class MoveFurniToUserActionElement extends FurniPickingActionElement
    {
        public function MoveFurniToUserActionElement()
        {
            super(ActionTypeCodes.MOVE_FURNI_TO_USER);
        }

        override public function furniSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.furni.title.mv.0";
        }

        override public function userSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.furni.title.mv_user";
        }

        override public function advancedAlwaysVisible():Boolean { return true; }
    }
}
