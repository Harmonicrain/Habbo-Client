package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
{
    public class WithdrawChestCoinsMessageComposer extends AbstractChestMessageComposer
    {
        public function WithdrawChestCoinsMessageComposer(chestId:int, amount:int)
        {
            super([chestId, amount]);
        }
    }
}
