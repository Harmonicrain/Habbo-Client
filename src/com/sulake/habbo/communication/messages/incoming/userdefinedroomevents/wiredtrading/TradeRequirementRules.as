package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /** July wrapped contract rule definition plus its optional multiplier field. */
    public class TradeRequirementRules
    {
        private var _definition:TradeRequirementRulesDefinition;
        private var _type:int;
        private var _multiplier:int = 1;
        private var _autoMultiplierMax:int = 1;

        public function TradeRequirementRules(data:IMessageDataWrapper)
        {
            this._definition = TradeRequirementRulesDefinition.readFromMessage(data);
            this._type = data.readInteger();
            if (this._type == TradeRequirementTypes.FIXED_MULTIPLIER)
            {
                this._multiplier = data.readInteger();
            }
            else if (this._type == TradeRequirementTypes.AUTO_MULTIPLIER)
            {
                this._autoMultiplierMax = data.readInteger();
            }
        }

        public function get youGiveRule():Vector.<TradeRequirementRule> { return this._definition.youGiveRule; }
        public function get youGetRule():TradeRequirementRule { return this._definition.youGetRule; }
        public function get type():int { return this._type; }
        public function get multiplier():int { return this._multiplier; }
        public function get autoMultiplierMax():int { return this._autoMultiplierMax; }
    }
}
