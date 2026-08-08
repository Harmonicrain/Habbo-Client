package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
{
    public class SaveChestNotificationsMessageComposer extends AbstractChestMessageComposer
    {
        public function SaveChestNotificationsMessageComposer(chestId:int, notifyMode:int,
            notifyFull:Boolean, notifyDonation:Boolean, notifyWithdraw:Boolean,
            notifyEmpty:Boolean, notifyWiredTransaction:Boolean)
        {
            super([chestId, notifyMode, notifyFull, notifyDonation, notifyWithdraw,
                notifyEmpty, notifyWiredTransaction]);
        }
    }
}
