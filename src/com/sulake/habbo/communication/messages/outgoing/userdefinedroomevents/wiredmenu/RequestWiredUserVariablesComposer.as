package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
{
    public final class RequestWiredUserVariablesComposer extends WiredMenuComposer
    {
        public function RequestWiredUserVariablesComposer(variableId:String, page:int,
            amount:int, sortFilter:int, userFilter:int)
        {
            super([variableId, page, amount, sortFilter, userFilter]);
        }
    }
}
