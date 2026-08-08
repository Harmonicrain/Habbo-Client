package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class ActionDefinition extends Triggerable
    {
        private var _delayInPulses:int;

        public function ActionDefinition(k:IMessageDataWrapper)
        {
            super(k);
        }

        override protected function readDefinitionSpecifics(k:IMessageDataWrapper):void
        {
            this._delayInPulses = k.readInteger();
        }

        public function get type():int
        {
            return this.code;
        }

        public function get delayInPulses():int
        {
            return this._delayInPulses;
        }

        public function set delayInPulses(k:int):void
        {
            this._delayInPulses = k;
        }

        // Wired 2.0 dropped conflicting-trigger warnings; kept empty for the
        // controller's length checks.
        public function get conflictingTriggers():Array
        {
            return [];
        }
    }
}
