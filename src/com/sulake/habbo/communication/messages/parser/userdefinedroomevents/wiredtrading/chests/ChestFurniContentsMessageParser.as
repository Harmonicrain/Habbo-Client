package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestStorage;
    import __AS3__.vec.Vector;

    public class ChestFurniContentsMessageParser implements IMessageParser
    {
        private static const MAX_ITEMS_PER_FRAGMENT:int = 1000;
        private var _chestId:int;
        private var _totalFragments:int;
        private var _fragmentNo:int;
        private var _storageChunk:Vector.<ChestStorage>;

        public function flush():Boolean
        {
            this._chestId = 0; this._totalFragments = 0; this._fragmentNo = 0;
            this._storageChunk = null; return true;
        }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable < 16) { return false; }
            this._chestId = data.readInteger();
            this._totalFragments = data.readInteger();
            this._fragmentNo = data.readInteger();
            var count:int = data.readInteger();
            if (this._totalFragments < 1 || this._totalFragments > 10000
                || this._fragmentNo < 0 || this._fragmentNo >= this._totalFragments
                || count < 0 || count > MAX_ITEMS_PER_FRAGMENT)
            {
                return false;
            }
            this._storageChunk = new Vector.<ChestStorage>();
            var i:int;
            try
            {
                for (i = 0; i < count; i++)
                {
                    this._storageChunk.push(new ChestStorage(data));
                }
            }
            catch (error:Error)
            {
                this._storageChunk = null;
                return false;
            }
            return data.bytesAvailable == 0;
        }
        public function get chestId():int { return this._chestId; }
        public function get totalFragments():int { return this._totalFragments; }
        public function get fragmentNo():int { return this._fragmentNo; }
        public function get storageChunk():Vector.<ChestStorage> { return this._storageChunk; }
    }
}
