package com.sulake.habbo.communication.messages.outgoing.habbicons
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class SendHabbiconInstantMessageComposer implements IMessageComposer
    {
        private var _chatId:int;
        private var _habbiconId:int;
        private var _confirmationId:int;

        public function SendHabbiconInstantMessageComposer(chatId:int, habbiconId:int, confirmationId:int)
        {
            this._chatId = chatId;
            this._habbiconId = habbiconId;
            this._confirmationId = confirmationId;
        }

        public function getMessageArray():Array
        {
            return [this._chatId, this._habbiconId, this._confirmationId];
        }

        public function dispose():void
        {
        }
    }
}
