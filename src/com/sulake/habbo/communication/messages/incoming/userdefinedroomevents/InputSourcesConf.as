package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /**
     * Wired 2.0 input-source configuration. Read order matches the Arcturus
     * serializeInputSourcesConf: allowedFurniSources (2D), allowedUserSources (2D),
     * defaultFurniSources (flat), defaultUserSources (flat).
     */
    public class InputSourcesConf
    {
        public static const FURNI_SOURCE_FURNI_PICKS_1:int = 100;
        public static const FURNI_SOURCE_FURNI_PICKS_2:int = 101;
        public static const FURNI_SOURCE_DUAL_MODE:int = 110;

        private var _allowedFurniSources:Array; // Array of Array<int>
        private var _allowedUserSources:Array;  // Array of Array<int>
        private var _defaultFurniSources:Array; // Array<int>
        private var _defaultUserSources:Array;  // Array<int>

        public function InputSourcesConf(k:IMessageDataWrapper)
        {
            super();
            this._allowedFurniSources = readAllowedSources(k);
            this._allowedUserSources = readAllowedSources(k);
            this._defaultFurniSources = readFlatSources(k);
            this._defaultUserSources = readFlatSources(k);
        }

        private static function readAllowedSources(k:IMessageDataWrapper):Array
        {
            var outer:Array = new Array();
            var outerCount:int = k.readInteger();
            for (var i:int = 0; i < outerCount; i++)
            {
                var slot:Array = new Array();
                var innerCount:int = k.readInteger();
                for (var j:int = 0; j < innerCount; j++)
                {
                    slot.push(k.readInteger());
                }
                outer.push(slot);
            }
            return outer;
        }

        private static function readFlatSources(k:IMessageDataWrapper):Array
        {
            var out:Array = new Array();
            var count:int = k.readInteger();
            for (var i:int = 0; i < count; i++)
            {
                out.push(k.readInteger());
            }
            return out;
        }

        public function get allowedFurniSources():Array { return this._allowedFurniSources; }
        public function get allowedUserSources():Array { return this._allowedUserSources; }
        public function get defaultFurniSources():Array { return this._defaultFurniSources; }
        public function get defaultUserSources():Array { return this._defaultUserSources; }

        public function allowFurniSelection():Boolean
        {
            for each (var slot:Array in this._allowedFurniSources)
            {
                if (slot.indexOf(FURNI_SOURCE_FURNI_PICKS_1) != -1
                    || slot.indexOf(FURNI_SOURCE_FURNI_PICKS_2) != -1
                    || slot.indexOf(FURNI_SOURCE_DUAL_MODE) != -1)
                {
                    return true;
                }
            }
            return false;
        }
    }
}
