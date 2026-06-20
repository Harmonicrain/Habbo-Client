package com.sulake.habbo.roomevents.wired_setup.common.utils
{
    public class WiredUserAction
    {
        public static const SIGN_ACTION_CODE:int = 10;
        public static const DANCE_ACTION_CODE:int = 11;

        public static const allWiredUserActions:Vector.<WiredUserAction> = new <WiredUserAction>[
            new WiredUserAction("wave", 0),
            new WiredUserAction("blow", 1),
            new WiredUserAction("laugh", 2),
            new WiredUserAction("respect", 3),
            new WiredUserAction("awake", 4),
            new WiredUserAction("sleep", 5),
            new WiredUserAction("sit", 6),
            new WiredUserAction("stand", 7),
            new WiredUserAction("lay", 8),
            new WiredUserAction("sign", SIGN_ACTION_CODE, true, signCodeToString, signStringToCode),
            new WiredUserAction("dance", DANCE_ACTION_CODE, true, danceCodeToString, danceStringToCode),
            new WiredUserAction("67", 67)
        ];

        private var _name:String;
        private var _code:int;
        private var _hasExtra:Boolean;
        private var _extraIdToString:Function;
        private var _extraStringToId:Function;

        public function WiredUserAction(name:String, code:int, hasExtra:Boolean = false, extraIdToString:Function = null, extraStringToId:Function = null)
        {
            super();
            this._name = name;
            this._code = code;
            this._hasExtra = hasExtra;
            this._extraIdToString = extraIdToString;
            this._extraStringToId = extraStringToId;
        }

        public static function getByCode(code:int):WiredUserAction
        {
            for each (var action:WiredUserAction in allWiredUserActions)
            {
                if (action.code == code)
                {
                    return action;
                }
            }
            return null;
        }

        private static function signCodeToString(code:int):String
        {
            return code.toString();
        }

        private static function signStringToCode(value:String):int
        {
            return int(value);
        }

        private static function danceCodeToString(code:int):String
        {
            return "dance " + code;
        }

        private static function danceStringToCode(value:String):int
        {
            var parts:Array = value.split(" ");
            return parts.length > 1 ? int(parts[1]) : -1;
        }

        public function get name():String { return this._name; }
        public function get code():int { return this._code; }
        public function get hasExtra():Boolean { return this._hasExtra; }

        public function convertCodeToExtraString(code:int):String
        {
            return this._extraIdToString != null ? this._extraIdToString(code) : "";
        }

        public function convertExtraStringToCode(value:String):int
        {
            return this._extraStringToId != null ? this._extraStringToId(value) : -1;
        }
    }
}
