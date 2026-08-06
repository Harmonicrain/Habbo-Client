package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.utils.Map;

    /** July Wired 2.0 variable metadata record. */
    public class WiredVariable
    {
        public static const NONE_ID:String = "n";
        private static const MINIMUM_BYTES:uint = 25;
        private static const MAX_TEXT_CONNECTORS:int = 4096;

        private var _variableId:String;
        private var _variableType:int;
        private var _variableName:String;
        private var _availabilityType:int;
        private var _variableTarget:int;
        private var _alwaysAvailable:Boolean;
        private var _canCreateAndDelete:Boolean;
        private var _hasValue:Boolean;
        private var _canWriteValue:Boolean;
        private var _canInterceptChanges:Boolean;
        private var _isInvisible:Boolean;
        private var _canReadCreationTime:Boolean;
        private var _canReadLastUpdateTime:Boolean;
        private var _textConnector:Map;

        public function WiredVariable(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, MINIMUM_BYTES, "WiredVariable");
            this._variableId = k.readString();
            this._variableType = k.readInteger();
            this._variableName = k.readString();
            this._availabilityType = k.readInteger();
            this._variableTarget = k.readInteger();
            this._alwaysAvailable = k.readBoolean();
            this._canCreateAndDelete = k.readBoolean();
            this._hasValue = k.readBoolean();
            this._canWriteValue = k.readBoolean();
            this._canInterceptChanges = k.readBoolean();
            this._isInvisible = k.readBoolean();
            this._canReadCreationTime = k.readBoolean();
            this._canReadLastUpdateTime = k.readBoolean();

            var hasTextConnector:Boolean = k.readBoolean();
            if (hasTextConnector)
            {
                this._textConnector = new Map();
                var count:int = WiredMessageDataValidator.readCount(k, 6, MAX_TEXT_CONNECTORS,
                    "WiredVariable text connectors");
                for (var index:int = 0; index < count; index++)
                {
                    this._textConnector.add(k.readInteger(), k.readString());
                }
            }
        }

        public function get variableId():String { return this._variableId; }
        public function get variableType():int { return this._variableType; }
        public function get variableName():String { return this._variableName; }
        public function get availabilityType():int { return this._availabilityType; }
        public function get variableTarget():int { return this._variableTarget; }
        public function get alwaysAvailable():Boolean { return this._alwaysAvailable; }
        public function get canCreateAndDelete():Boolean { return this._canCreateAndDelete; }
        public function get hasValue():Boolean { return this._hasValue; }
        public function get canWriteValue():Boolean { return this._canWriteValue; }
        public function get canInterceptChanges():Boolean { return this._canInterceptChanges; }
        public function get isInvisible():Boolean { return this._isInvisible; }
        public function get canReadCreationTime():Boolean { return this._canReadCreationTime; }
        public function get canReadLastUpdateTime():Boolean { return this._canReadLastUpdateTime; }
        public function get hasTextConnector():Boolean { return this._textConnector != null; }
        public function get textConnector():Map { return this._textConnector; }
        public function get isStored():Boolean { return this._availabilityType < 100; }
        public function get isPersisted():Boolean
        {
            return this._availabilityType == 10 || this._availabilityType == 11 || this._availabilityType == 20;
        }
    }
}
