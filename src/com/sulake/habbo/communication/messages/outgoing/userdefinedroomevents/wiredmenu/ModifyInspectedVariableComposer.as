package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
{
    public final class ModifyInspectedVariableComposer extends WiredMenuComposer
    {
        public function ModifyInspectedVariableComposer(type:int, id:int,
            variableId:String, value:int, operation:int)
        {
            super([type, id, variableId, value, operation]);
        }
    }
}
