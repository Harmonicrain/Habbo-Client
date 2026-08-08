package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class SelectorDefinition extends Triggerable
    {
        private var _isFilter:Boolean;
        private var _isInvert:Boolean;

        public function SelectorDefinition(k:IMessageDataWrapper)
        {
            super(k);
        }

        override protected function readDefinitionSpecifics(k:IMessageDataWrapper):void
        {
            this._isFilter = k.readBoolean();
            this._isInvert = k.readBoolean();
        }

        public function get type():int
        {
            return this.code;
        }

        public function get isFilter():Boolean
        {
            return this._isFilter;
        }

        public function set isFilter(k:Boolean):void
        {
            this._isFilter = k;
        }

        public function get isInvert():Boolean
        {
            return this._isInvert;
        }

        public function set isInvert(k:Boolean):void
        {
            this._isInvert = k;
        }
    }
}
