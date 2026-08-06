package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
{
    public class UpgradeChestMessageComposer extends AbstractChestMessageComposer
    {
        public function UpgradeChestMessageComposer(chestId:int, levels:int)
        {
            super([chestId, levels]);
        }
    }
}
