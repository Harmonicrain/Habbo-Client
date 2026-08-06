package com.sulake.habbo.roomevents.wired_setup.variables
{
    import com.sulake.habbo.roomevents.wired_setup.IWiredElement;

    public interface IWiredVariableElement extends IWiredElement
    {
        function get initialVariableName():String;
        function variableType():int;
    }
}
