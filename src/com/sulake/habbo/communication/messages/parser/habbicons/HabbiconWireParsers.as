package com.sulake.habbo.communication.messages.parser.habbicons
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.catalog.habbicons.HabbiconCollectionData;
    import com.sulake.habbo.catalog.habbicons.HabbiconOwnedItem;
    import com.sulake.habbo.catalog.habbicons.HabbiconShopItem;

    public class HabbiconWireParsers
    {
        public static function readOwnedItem(wrapper:IMessageDataWrapper):HabbiconOwnedItem
        {
            var item:HabbiconOwnedItem = new HabbiconOwnedItem();
            item.habbiconId = wrapper.readInteger();
            item.habbiconState = wrapper.readInteger();
            return item;
        }

        public static function readShopItem(wrapper:IMessageDataWrapper):HabbiconShopItem
        {
            var item:HabbiconShopItem = new HabbiconShopItem();
            item.habbiconId = wrapper.readInteger();
            item.name = wrapper.readString();
            item.collectionId = wrapper.readInteger();
            item.state = wrapper.readInteger();
            item.priceCredits = wrapper.readInteger();
            item.priceActivityPoints = wrapper.readInteger();
            item.activityPointType = wrapper.readInteger();
            return item;
        }

        public static function readCollection(wrapper:IMessageDataWrapper):HabbiconCollectionData
        {
            var count:int;
            var index:int;
            var collection:HabbiconCollectionData = new HabbiconCollectionData();
            collection.collectionId = wrapper.readInteger();
            collection.name = wrapper.readString();
            collection.completed = wrapper.readBoolean();
            collection.rewardHabbiconId = wrapper.readInteger();
            collection.rewardState = wrapper.readInteger();
            collection.priceCredits = wrapper.readInteger();
            collection.priceActivityPoints = wrapper.readInteger();
            collection.activityPointType = wrapper.readInteger();
            collection.habbicons = [];
            count = wrapper.readInteger();
            for (index = 0; index < count; index++)
            {
                collection.habbicons.push(readShopItem(wrapper));
            }
            return collection;
        }
    }
}
