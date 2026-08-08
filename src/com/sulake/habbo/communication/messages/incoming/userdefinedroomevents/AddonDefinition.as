package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class AddonDefinition extends Triggerable
    {
        public function AddonDefinition(k:IMessageDataWrapper)
        {
            super(k);
        }

        public function get type():int
        {
            return this.code;
        }
    }
}
