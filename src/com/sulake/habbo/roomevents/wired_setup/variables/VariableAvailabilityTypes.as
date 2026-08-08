package com.sulake.habbo.roomevents.wired_setup.variables
{
    /** Availability values used by the July Furni/User/Global variable editors. */
    public class VariableAvailabilityTypes
    {
        public static const WHILE_USER_IN_ROOM:int = 0;
        public static const WHILE_ROOM_ACTIVE:int = 1;
        public static const PERMANENT:int = 10;
        public static const PERMANENT_SHARED:int = 11;
        public static const SHARED:int = 20;
        public static const SHARED_DYNAMIC:int = 21;
        public static const INTERNAL:int = 999;

        public static function isStored(k:int):Boolean
        {
            return k == PERMANENT || k == PERMANENT_SHARED;
        }
    }
}
