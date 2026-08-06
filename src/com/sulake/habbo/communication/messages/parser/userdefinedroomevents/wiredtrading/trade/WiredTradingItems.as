package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.ItemDataStructure;

    /** The two-sided item block embedded in July's Wired Trade update. */
    public class WiredTradingItems
    {
        private static const MAX_ITEMS:int = 1500;

        private var _firstUserID:int;
        private var _firstUserItemArray:Array;
        private var _firstUserNumItems:int;
        private var _firstUserNumCredits:int;
        private var _secondUserID:int;
        private var _secondUserItemArray:Array;
        private var _secondUserNumItems:int;
        private var _secondUserNumCredits:int;

        public function parse(data:IMessageDataWrapper):Boolean
        {
            this._firstUserID = data.readInteger();
            this._firstUserItemArray = [];
            if (!this.parseItemData(data, this._firstUserItemArray)) { return false; }
            this._firstUserNumItems = data.readInteger();
            this._firstUserNumCredits = data.readInteger();
            this._secondUserID = data.readInteger();
            this._secondUserItemArray = [];
            if (!this.parseItemData(data, this._secondUserItemArray)) { return false; }
            this._secondUserNumItems = data.readInteger();
            this._secondUserNumCredits = data.readInteger();
            return this._firstUserNumItems >= 0 && this._firstUserNumItems <= MAX_ITEMS
                && this._secondUserNumItems >= 0 && this._secondUserNumItems <= MAX_ITEMS
                && this._firstUserNumCredits >= 0 && this._secondUserNumCredits >= 0;
        }

        public function flush():void
        {
            this._firstUserID = -1;
            this._firstUserItemArray = null;
            this._firstUserNumItems = 0;
            this._firstUserNumCredits = 0;
            this._secondUserID = -1;
            this._secondUserItemArray = null;
            this._secondUserNumItems = 0;
            this._secondUserNumCredits = 0;
        }

        private function parseItemData(data:IMessageDataWrapper, items:Array):Boolean
        {
            var count:int = data.readInteger();
            if (count < 0 || count > MAX_ITEMS) { return false; }
            try
            {
                while (count-- > 0)
                {
                    items.push(new ItemDataStructure(data));
                }
            }
            catch (error:Error)
            {
                items.length = 0;
                return false;
            }
            return true;
        }

        public function get firstUserID():int { return this._firstUserID; }
        public function get firstUserItemArray():Array { return this._firstUserItemArray; }
        public function get firstUserNumItems():int { return this._firstUserNumItems; }
        public function get firstUserNumCredits():int { return this._firstUserNumCredits; }
        public function get secondUserID():int { return this._secondUserID; }
        public function get secondUserItemArray():Array { return this._secondUserItemArray; }
        public function get secondUserNumItems():int { return this._secondUserNumItems; }
        public function get secondUserNumCredits():int { return this._secondUserNumCredits; }
    }
}
