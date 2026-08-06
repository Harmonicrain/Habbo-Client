package com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers
{
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;

    public interface IContractView
    {
        function show(contents:ChestContractContentsMessageParser):void;
        function hide():void;
        function addContentsToComposer(data:Array):void;
        function contractType():int;
        function validate():String;
        function get window():IWindow;
    }
}
