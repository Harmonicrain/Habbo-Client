package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class MoveFurniToFurniActionElement extends DefaultElement
    {
        override public function get code():int
        {
            return ActionTypeCodes.MOVE_FURNI_TO_FURNI;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function get requiresFurniSelection():Boolean
        {
            return true;
        }

        override public function get forceHidePickFurniInstructions():Boolean
        {
            return true;
        }

        override public function inputSourcesAlwaysVisible():Boolean
        {
            return true;
        }

        override public function furniSelectionTitle(_arg_1:int):String
        {
            return "wiredfurni.params.sources.furni.title.mv." + _arg_1;
        }

        override public function advancedAlwaysVisible():Boolean
        {
            return true;
        }

        override public function readFurniIds2FromForm():Array
        {
            return this.roomEvents.wiredCtrl.getStuffIds2();
        }
    }
}
