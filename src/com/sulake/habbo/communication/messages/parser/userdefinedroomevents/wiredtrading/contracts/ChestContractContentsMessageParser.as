package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRulesDefinition;

    /** Exact July contract-contents parser. */
    public class ChestContractContentsMessageParser implements IMessageParser
    {
        private var _contractId:int;
        private var _contractType:int;
        private var _definition:TradeRequirementRulesDefinition;
        private var _paymentMode:int;
        private var _receiveText:String;
        private var _layoutType:String;
        private var _rewardCategory:int;
        private var _showDialog:Boolean;
        private var _rewardText:String;

        public function flush():Boolean
        {
            this._contractId = 0;
            this._contractType = 0;
            this._definition = null;
            this._paymentMode = 0;
            this._receiveText = null;
            this._layoutType = null;
            this._rewardCategory = 0;
            this._showDialog = false;
            this._rewardText = null;
            return true;
        }

        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable < 8) return false;
            this._contractId = data.readInteger();
            this._contractType = data.readShort();
            if (this._contractType < 0 || this._contractType > 2) return false;
            this._definition = TradeRequirementRulesDefinition.readFromMessage(data);
            if (this._contractType == 0)
            {
                this._paymentMode = data.readShort();
                this._receiveText = data.readString();
                this._layoutType = data.readString();
            }
            else if (this._contractType == 2)
            {
                this._rewardCategory = data.readShort();
                this._showDialog = data.readBoolean();
                this._rewardText = data.readString();
            }
            return data.bytesAvailable == 0;
        }

        public function get contractId():int { return this._contractId; }
        public function get contractType():int { return this._contractType; }
        public function get definition():TradeRequirementRulesDefinition { return this._definition; }
        public function get paymentMode():int { return this._paymentMode; }
        public function get receiveText():String { return this._receiveText; }
        public function get layoutType():String { return this._layoutType; }
        public function get rewardCategory():int { return this._rewardCategory; }
        public function get showDialog():Boolean { return this._showDialog; }
        public function get rewardText():String { return this._rewardText; }
    }
}
