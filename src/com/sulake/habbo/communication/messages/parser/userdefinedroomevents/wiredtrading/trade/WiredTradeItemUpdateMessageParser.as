package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class WiredTradeItemUpdateMessageParser implements IMessageParser
    {
        private var _tradingItems:WiredTradingItems = new WiredTradingItems();
        private var _canAccept:Boolean;
        private var _extra:int;

        public function flush():Boolean
        {
            this._tradingItems.flush();
            this._canAccept = false;
            this._extra = 0;
            return true;
        }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (!this._tradingItems.parse(data)) { return false; }
            if (data.bytesAvailable < 5) { return false; }
            this._canAccept = data.readBoolean();
            this._extra = data.readInteger();
            return data.bytesAvailable == 0;
        }
        public function get tradingItems():WiredTradingItems { return this._tradingItems; }
        public function get canAccept():Boolean { return this._canAccept; }
        public function get extra():int { return this._extra; }
    }
}
