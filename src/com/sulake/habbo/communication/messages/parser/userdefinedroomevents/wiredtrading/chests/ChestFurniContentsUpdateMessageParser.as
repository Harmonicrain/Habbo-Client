package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestStorage;
    import __AS3__.vec.Vector;

    public class ChestFurniContentsUpdateMessageParser implements IMessageParser
    {
        private static const MAX_DELTA_ITEMS:int = 1000;
        private var _chestId:int;
        private var _removedIds:Vector.<int>;
        private var _addedStorage:Vector.<ChestStorage>;

        public function flush():Boolean
        {
            this._chestId = 0; this._removedIds = null; this._addedStorage = null; return true;
        }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable < 12) { return false; }
            this._chestId = data.readInteger();
            var removedCount:int = data.readInteger();
            if (removedCount < 0 || removedCount > MAX_DELTA_ITEMS
                || data.bytesAvailable < removedCount * 4 + 4)
            {
                return false;
            }
            this._removedIds = new Vector.<int>();
            var i:int;
            for (i = 0; i < removedCount; i++)
            {
                this._removedIds.push(data.readInteger());
            }
            var addedCount:int = data.readInteger();
            if (addedCount < 0 || addedCount > MAX_DELTA_ITEMS) { return false; }
            this._addedStorage = new Vector.<ChestStorage>();
            try
            {
                for (i = 0; i < addedCount; i++)
                {
                    this._addedStorage.push(new ChestStorage(data));
                }
            }
            catch (error:Error)
            {
                this._addedStorage = null;
                return false;
            }
            return data.bytesAvailable == 0;
        }
        public function get chestId():int { return this._chestId; }
        public function get removedIds():Vector.<int> { return this._removedIds; }
        public function get addedStorage():Vector.<ChestStorage> { return this._addedStorage; }
    }
}
