package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class TriggerDefinition extends Triggerable
    {
        public function TriggerDefinition(k:IMessageDataWrapper)
        {
            super(k);
        }

        public function get type():int
        {
            return this.code;
        }

        // Wired 2.0 dropped conflicting-trigger/action warnings; kept empty for the
        // controller's length checks.
        public function get conflictingActions():Array
        {
            return [];
        }
    }
}
