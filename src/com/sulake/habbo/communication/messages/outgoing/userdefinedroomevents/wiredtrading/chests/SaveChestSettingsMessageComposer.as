package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
{
    public class SaveChestSettingsMessageComposer extends AbstractChestMessageComposer
    {
        public function SaveChestSettingsMessageComposer(chestId:int, name:String,
            description:String, everyoneCanOpen:Boolean, everyoneCanDonate:Boolean,
            stateControlMode:int, previewMode:int, previewAmount:int, wiredEnabled:Boolean)
        {
            super([chestId, name, description, everyoneCanOpen, everyoneCanDonate,
                stateControlMode, previewMode, previewAmount, wiredEnabled]);
        }
    }
}
