package com.sulake.habbo.catalog.habbicons
{
    import com.sulake.core.runtime.IUnknown;

    public interface IHabbiconController extends IUnknown
    {
        function get hasLoadedShopData():Boolean;
        function get ownedHabbicons():Array;
        function get recentHabbiconIds():Array;
        function get shopCollections():Vector.<HabbiconCollectionData>;
        function get unseenHabbiconCount():int;
        function addEventListener(type:String, listener:Function):void;
        function removeEventListener(type:String, listener:Function):void;
        function openHabbiconHub():void;
        function getShopData(force:Boolean = false):void;
        function getHabbiconInfo(habbiconId:int):void;
        function noteHabbiconUsed(habbiconId:int):void;
        function isUnseenHabbicon(habbiconId:int):Boolean;
        function removeUnseenHabbicon(habbiconId:int):void;
        function resetUnseenHabbicons():void;
        function buyHabbicon(habbiconId:int):void;
        function buyHabbiconCollection(collectionId:int):void;
        function claimHabbicon(habbiconId:int):void;
        function favoriteHabbicon(habbiconId:int):void;
        function unfavoriteHabbicon(habbiconId:int):void;
        function useHabbiconInRoom(habbiconId:int):void;
        function sendHabbiconInstantMessage(chatId:int, habbiconId:int, confirmationId:int):void;
        function tryGetOwnedHabbicon(habbiconId:int):HabbiconOwnedItem;
        function tryGetShopItem(habbiconId:int):HabbiconShopItem;
    }
}
