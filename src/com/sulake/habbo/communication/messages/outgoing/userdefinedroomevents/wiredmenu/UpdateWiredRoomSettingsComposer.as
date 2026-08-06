package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
{
    public final class UpdateWiredRoomSettingsComposer extends WiredMenuComposer
    {
        public function UpdateWiredRoomSettingsComposer(modify:int, read:int, timezone:String)
        {
            super([modify, read, timezone]);
        }
    }
}
