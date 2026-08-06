package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;

    public class WiredTradeInitiateMessageParser implements IMessageParser
    {
        private var _requirement:TradeRequirement;
        private var _showRequirementsImmediate:Boolean;
        private var _overridePreviousTrade:Boolean;
        private var _timeoutSeconds:int;

        public function flush():Boolean
        {
            this._requirement = null;
            this._showRequirementsImmediate = false;
            this._overridePreviousTrade = false;
            this._timeoutSeconds = 0;
            return true;
        }

        public function parse(data:IMessageDataWrapper):Boolean
        {
            try
            {
                this._requirement = new TradeRequirement(data);
                this._showRequirementsImmediate = data.readBoolean();
                this._overridePreviousTrade = data.readBoolean();
                this._timeoutSeconds = data.readInteger();
            }
            catch (error:Error)
            {
                return false;
            }
            return this._timeoutSeconds >= 0 && this._timeoutSeconds <= 86400
                && data.bytesAvailable == 0;
        }

        public function get requirement():TradeRequirement { return this._requirement; }
        public function get showRequirementsImmediate():Boolean
        { return this._showRequirementsImmediate; }
        public function get overridePreviousTrade():Boolean
        { return this._overridePreviousTrade; }
        public function get timeoutSeconds():int { return this._timeoutSeconds; }
    }
}
