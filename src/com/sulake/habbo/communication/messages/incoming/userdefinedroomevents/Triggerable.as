package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /**
     * Wired 2.0 base definition (kept the legacy class name `Triggerable` so the
     * ~60 wired type classes and the controller that reference this type compile
     * unchanged). Reads the expanded packet in the exact order Arcturus
     * InteractionWired.serializeWiredDataNew writes it.
     *
     * Two virtual hooks let subclasses read type-specific fields:
     *   readDefinitionSpecifics - between `code` and advancedMode
     *   readTypeSpecifics       - between allowWallFurni and WiredContext
     */
    public class Triggerable
    {
        private var _furniLimit:int;
        private var _stuffIds:Array;
        private var _stuffIds2:Array;
        private var _stuffTypeId:int;
        private var _id:int;
        private var _stringParam:String;
        private var _intParams:Array;
        private var _variableIds:Array;        // strings
        private var _furniSourceTypes:Array;
        private var _userSourceTypes:Array;
        private var _code:int;
        private var _advancedMode:Boolean;
        private var _inputSourcesConf:InputSourcesConf;
        private var _allowWallFurni:Boolean;
        private var _wiredContext:WiredContext;
        private var _defaultIntParams:Array;

        public function Triggerable(k:IMessageDataWrapper)
        {
            this._stuffIds = new Array();
            this._stuffIds2 = new Array();
            this._intParams = new Array();
            this._variableIds = new Array();
            this._furniSourceTypes = new Array();
            this._userSourceTypes = new Array();
            this._defaultIntParams = new Array();
            super();

            var count:int;
            var index:int;

            this._furniLimit = k.readInteger();

            count = k.readInteger();
            for (index = 0; index < count; index++) { this._stuffIds.push(k.readInteger()); }

            count = k.readInteger();
            for (index = 0; index < count; index++) { this._stuffIds2.push(k.readInteger()); }

            this._stuffTypeId = k.readInteger();
            this._id = k.readInteger();
            this._stringParam = k.readString();

            count = k.readInteger();
            for (index = 0; index < count; index++) { this._intParams.push(k.readInteger()); }

            count = k.readInteger();
            for (index = 0; index < count; index++) { this._variableIds.push(k.readString()); }

            count = k.readInteger();
            for (index = 0; index < count; index++) { this._furniSourceTypes.push(k.readInteger()); }

            count = k.readInteger();
            for (index = 0; index < count; index++) { this._userSourceTypes.push(k.readInteger()); }

            this._code = k.readInteger();

            this.readDefinitionSpecifics(k);

            this._advancedMode = k.readBoolean();
            this._inputSourcesConf = new InputSourcesConf(k);
            this.normalizeSourceTypes();
            this._allowWallFurni = k.readBoolean();

            this.readTypeSpecifics(k);

            this._wiredContext = new WiredContext(k);

            count = k.readInteger();
            for (index = 0; index < count; index++) { this._defaultIntParams.push(k.readInteger()); }
        }

        protected function readDefinitionSpecifics(k:IMessageDataWrapper):void { }
        protected function readTypeSpecifics(k:IMessageDataWrapper):void { }

        private function normalizeSourceTypes():void
        {
            normalizeArray(this._furniSourceTypes, this._inputSourcesConf.defaultFurniSources, this._inputSourcesConf.allowedFurniSources);
            normalizeArray(this._userSourceTypes, this._inputSourcesConf.defaultUserSources, this._inputSourcesConf.allowedUserSources);
        }

        private static function normalizeArray(target:Array, defaults:Array, allowed:Array):void
        {
            var index:int;
            var slot:Array;
            var value:int;
            var desired:int = Math.max(defaults.length, allowed.length);
            for (index = 0; index < desired; index++)
            {
                if (index < target.length)
                {
                    continue;
                }
                if (index < defaults.length)
                {
                    value = defaults[index];
                }
                else
                {
                    slot = allowed[index] as Array;
                    value = (slot != null && slot.length > 0) ? int(slot[0]) : 0;
                }
                target.push(value);
            }
        }

        // ---- legacy getter names (kept for the existing type classes / controller) ----
        public function get stuffTypeSelectionEnabled():Boolean { return false; }
        public function get _Str_6040():int { return 0; }
        public function set _Str_6040(k:int):void { }
        public function get maximumItemSelectionCount():int { return this._furniLimit; }
        public function get selectedItems():Array { return this._stuffIds; }
        public function get id():int { return this._id; }
        public function get stringData():String { return this._stringParam; }
        public function get intData():Array { return this._intParams; }
        public function get code():int { return this._code; }
        public function get spriteId():int { return this._stuffTypeId; }
        public function getBoolean(k:int):Boolean { return this._intParams[k] == 1; }

        // ---- Wired 2.0 additions ----
        public function get selectedItems2():Array { return this._stuffIds2; }
        public function get variableIds():Array { return this._variableIds; }
        public function get furniSourceTypes():Array { return this._furniSourceTypes; }
        public function set furniSourceTypes(k:Array):void { this._furniSourceTypes = k != null ? k : []; }
        public function get userSourceTypes():Array { return this._userSourceTypes; }
        public function set userSourceTypes(k:Array):void { this._userSourceTypes = k != null ? k : []; }
        public function get advancedMode():Boolean { return this._advancedMode; }
        public function get usingCustomInputSources():Boolean { return this._inputSourcesConf.isUsingAdvancedSettings(this._furniSourceTypes, this._userSourceTypes); }
        public function get inputSourcesConf():InputSourcesConf { return this._inputSourcesConf; }
        public function get allowWallFurni():Boolean { return this._allowWallFurni; }
        public function get wiredContext():WiredContext { return this._wiredContext; }
        public function get defaultIntParams():Array { return this._defaultIntParams; }
    }
}
