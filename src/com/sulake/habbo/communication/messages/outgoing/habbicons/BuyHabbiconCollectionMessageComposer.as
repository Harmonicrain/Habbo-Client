package com.sulake.habbo.communication.messages.outgoing.habbicons
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class BuyHabbiconCollectionMessageComposer implements IMessageComposer
    {
        private var _collectionId:int;

        public function BuyHabbiconCollectionMessageComposer(collectionId:int)
        {
            this._collectionId = collectionId;
        }

        public function getMessageArray():Array
        {
            return [this._collectionId];
        }

        public function dispose():void
        {
        }
    }
}
