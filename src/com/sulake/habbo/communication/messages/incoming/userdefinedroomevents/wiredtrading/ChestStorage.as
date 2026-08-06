package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectDataParser;
    import com.sulake.habbo.room.IStuffData;

    /** One furniture record in the July Wired chest inventory protocol. */
    public class ChestStorage
    {
        public static const UNLOCKED:int = 0;
        public static const LOCKED:int = 1;
        public static const OFFERED:int = 2;
        public static const RESERVED:int = 3;

        private var _inventoryId:int;
        private var _lockState:int;
        private var _transactionId:Number;
        private var _type:ChestItemType;
        private var _groupable:Boolean;
        private var _specialType:int;
        private var _stuffData:IStuffData;
        private var _extra:int;

        public function ChestStorage(data:IMessageDataWrapper)
        {
            this._inventoryId = data.readInteger();
            this._lockState = data.readInteger();
            this._transactionId = data.readLong();
            this._type = ChestItemType.readFromMessage(data);
            this._groupable = data.readBoolean();
            this._specialType = data.readInteger();
            this._stuffData = ObjectDataParser.parseStuffData(data);
            if (!this._type.isWallItem)
            {
                this._extra = data.readInteger();
            }
        }

        public function get inventoryId():int { return this._inventoryId; }
        public function get lockState():int { return this._lockState; }
        public function get transactionId():Number { return this._transactionId; }
        public function get type():ChestItemType { return this._type; }
        public function get groupable():Boolean { return this._groupable; }
        public function get specialType():int { return this._specialType; }
        public function get stuffData():IStuffData { return this._stuffData; }
        public function get extra():int { return this._extra; }
    }
}
