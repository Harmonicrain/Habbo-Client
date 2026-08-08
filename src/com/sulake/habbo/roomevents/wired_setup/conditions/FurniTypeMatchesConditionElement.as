package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class FurniTypeMatchesConditionElement extends FurniPickingConditionElement
    {
        public function FurniTypeMatchesConditionElement()
        {
            super(ConditionCodes.STUFF_TYPE_MATCHES, ConditionCodes.NOT_FURNI_IS_OF_TYPE);
        }

        override public function furniSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.furni.title.match." + index;
        }

        override public function advancedAlwaysVisible():Boolean { return true; }
    }
}
