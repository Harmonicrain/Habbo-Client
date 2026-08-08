package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class ConditionDefinition extends Triggerable
    {
        private var _quantifierCode:int;
        private var _quantifierType:int;
        private var _isInvert:Boolean;

        public function ConditionDefinition(k:IMessageDataWrapper)
        {
            super(k);
        }

        override protected function readDefinitionSpecifics(k:IMessageDataWrapper):void
        {
            this._quantifierCode = k.readInteger();
        }

        override protected function readTypeSpecifics(k:IMessageDataWrapper):void
        {
            this._quantifierType = k.readByte();
            this._isInvert = k.readBoolean();
        }

        public function get type():int
        {
            return this.code;
        }

        public function get quantifierCode():int
        {
            return this._quantifierCode;
        }

        public function set quantifierCode(k:int):void
        {
            this._quantifierCode = k;
        }

        public function get quantifierType():int
        {
            return this._quantifierType;
        }

        public function get isInvert():Boolean
        {
            return this._isInvert;
        }
    }
}
