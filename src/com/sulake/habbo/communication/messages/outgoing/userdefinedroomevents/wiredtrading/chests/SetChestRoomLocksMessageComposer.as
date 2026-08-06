package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
{
    public class SetChestRoomLocksMessageComposer extends AbstractChestMessageComposer
    {
        public function SetChestRoomLocksMessageComposer(locked:Boolean, allChests:Boolean)
        {
            super([locked, allChests]);
        }
    }
}
