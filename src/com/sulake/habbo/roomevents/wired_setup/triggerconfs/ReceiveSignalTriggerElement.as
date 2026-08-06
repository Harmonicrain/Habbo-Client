package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

    /** July AIR trigger 17. Signal payload is carried by Wired context, not editor params. */
    public class ReceiveSignalTriggerElement extends DefaultElement
    {
        override public function get code():int
        {
            return WiredTriggerType.RECEIVE_SIGNAL;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.SIGNALS;
        }
    }
}
