package com.sulake.habbo.roomevents.wired_setup.conditions.chests
{
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    /** July condition 46: count selected item types in selected furni chests. */
    public class ChestHasItemTypesConditionElement extends ChestHasAmountConditionElement
    {
        override public function get code():int { return ConditionCodes.CHEST_HAS_ITEM_TYPES; }
        override public function furniSelectionTitle(index:int):String
        {
            return index == 0 ? "wiredfurni.params.sources.furni.title.item_types" :
                "wiredfurni.params.sources.furni.title.chests";
        }
        override public function mergedSelections():Array { return [[2, 0]]; }
    }
}
