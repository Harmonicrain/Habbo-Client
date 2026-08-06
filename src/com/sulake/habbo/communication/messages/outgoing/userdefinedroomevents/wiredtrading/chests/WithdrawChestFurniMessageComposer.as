package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;

    public class WithdrawChestFurniMessageComposer extends AbstractChestMessageComposer
    {
        public function WithdrawChestFurniMessageComposer(chestId:int, type:ChestItemType,
            amount:int)
        {
            var values:Array = [chestId];
            type.addToComposer(values);
            values.push(amount);
            super(values);
        }
    }
}
