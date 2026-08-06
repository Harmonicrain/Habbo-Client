package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
{
    public final class MutatePermanentVariableComposer extends WiredMenuComposer
    {
        public function MutatePermanentVariableComposer(type:int, id:int,
            variableId:String, value:int, operation:int)
        {
            super([type, id, variableId, value, operation]);
        }
    }
}
