package com.sulake.habbo.inventory.trading
{
    import __AS3__.vec.Vector;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.habbo.room.IStuffData;

    /**
     * Common inventory contract used by ordinary and July Wired Trading.
     */
    public interface ITradingModel
    {
        function requestAddItemsToTrading(
            itemIds:Vector.<int>,
            isWallItem:Boolean,
            type:int,
            category:int,
            groupable:Boolean,
            stuffData:IStuffData):void;

        function requestRemoveItemFromTrading(index:int):void;
        function getOwnItemIdsInTrade():Array;
        function getInventory():HabboInventory;
    }
}
