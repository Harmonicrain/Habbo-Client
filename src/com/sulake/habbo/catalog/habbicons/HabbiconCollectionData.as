package com.sulake.habbo.catalog.habbicons
{
    public class HabbiconCollectionData
    {
        public var collectionId:int;
        public var name:String;
        public var completed:Boolean;
        public var rewardHabbiconId:int;
        public var rewardState:int;
        public var priceCredits:int;
        public var priceActivityPoints:int;
        public var activityPointType:int;
        public var habbicons:Array;

        public function HabbiconCollectionData()
        {
            this.habbicons = [];
        }
    }
}
