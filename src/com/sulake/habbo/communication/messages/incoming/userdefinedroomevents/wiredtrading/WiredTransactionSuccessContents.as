package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /** July transaction-success contents. Type 2 carries the reward notification rule. */
    public class WiredTransactionSuccessContents
    {
        public static const TYPE_REWARD_CONTENTS:int = 2;

        private var _internalId:int;
        private var _type:int;
        private var _rewardContents:TradeRequirementRule;
        private var _rewardText:String = "";
        private var _openByDefault:Boolean;

        public function WiredTransactionSuccessContents(
            internalId:int, data:IMessageDataWrapper)
        {
            this._internalId = internalId;
            this._type = data.readInteger();
            if (this._type == TYPE_REWARD_CONTENTS && data.bytesAvailable > 0)
            {
                this._rewardContents = TradeRequirementRule.readFromMessage(data);
                this._rewardText = data.readString();
                this._openByDefault = data.readBoolean();
            }
        }

        public function get internalId():int { return this._internalId; }
        public function get transactionSuccessTypeId():int { return this._type; }
        public function get rewardContents():TradeRequirementRule
        {
            return this._rewardContents;
        }
        public function get rewardText():String { return this._rewardText; }
        public function get openByDefault():Boolean { return this._openByDefault; }
    }
}
