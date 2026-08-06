package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
{
    public class SaveChestSafetyMessageComposer extends AbstractChestMessageComposer
    {
        public function SaveChestSafetyMessageComposer(chestId:int, locked:Boolean,
            autoLock:Boolean, capacity:int)
        {
            super([chestId, locked, autoLock, capacity]);
        }
    }
}
