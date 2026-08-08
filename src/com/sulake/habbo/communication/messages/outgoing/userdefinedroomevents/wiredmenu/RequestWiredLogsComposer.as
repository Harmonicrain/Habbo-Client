package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
{
    public final class RequestWiredLogsComposer extends WiredMenuComposer
    {
        public function RequestWiredLogsComposer(page:int, amount:int,
            level:int = -1, source:int = -1, query:String = "")
        {
            super([page, amount, level, source, query]);
        }
    }
}
