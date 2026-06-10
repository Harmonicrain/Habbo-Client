package com.sulake.habbo.roomevents.wired_setup
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;

    /**
     * Wired 2.0 type-holder contract (May §_-gT§). A holder owns the set of element
     * implementations for one category (trigger/action/condition/...) and resolves
     * an element by its wired code.
     */
    public interface IWiredTypeHolder
    {
        function getElementByCode(_arg_1:int):IWiredElement;
        function getKey():String;
        function acceptTriggerable(_arg_1:Triggerable):Boolean;
    }
}
