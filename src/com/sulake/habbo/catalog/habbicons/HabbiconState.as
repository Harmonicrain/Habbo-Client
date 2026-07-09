package com.sulake.habbo.catalog.habbicons
{
    public class HabbiconState
    {
        public static const NONE:int = 0;
        public static const CLAIMABLE:int = 1;
        public static const OWNED:int = 2;
        public static const FAVOURITE:int = 3;
        public static const LOCKED:int = 4;
        public static const REWARD_MARKER:int = 5;

        public static function isOwnedState(state:int):Boolean
        {
            return state == CLAIMABLE || state == OWNED || state == FAVOURITE;
        }

        public static function isUsableState(state:int):Boolean
        {
            return state == OWNED || state == FAVOURITE;
        }
    }
}
