package com.sulake.habbo.roomevents.wired_trading
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRulesDefinition;

    /** Mutable July contract-rule editing state shared by the controller and rule presets. */
    public class ContractRuleEditorState
    {
        public static const MAX_GIVE_RULES:int = 3;
        private var _giveRules:Vector.<TradeRequirementRule>;
        private var _getRule:TradeRequirementRule;

        public function ContractRuleEditorState(definition:TradeRequirementRulesDefinition = null)
        {
            this.load(definition);
        }

        public function load(definition:TradeRequirementRulesDefinition):void
        {
            this._giveRules = new Vector.<TradeRequirementRule>();
            if (definition != null && definition.youGiveRule != null)
            {
                for each (var rule:TradeRequirementRule in definition.youGiveRule)
                {
                    if (this._giveRules.length >= MAX_GIVE_RULES) { break; }
                    this._giveRules.push(rule.deepCopy());
                }
            }
            this._getRule = definition != null && definition.youGetRule != null
                ? definition.youGetRule.deepCopy() : null;
        }

        public function addGiveRule(rule:TradeRequirementRule):Boolean
        {
            if (rule == null || this._giveRules.length >= MAX_GIVE_RULES) { return false; }
            this._giveRules.push(rule.deepCopy());
            return true;
        }

        public function removeGiveRule(index:int):Boolean
        {
            if (index < 0 || index >= this._giveRules.length) { return false; }
            this._giveRules.removeAt(index);
            return true;
        }

        public function setGiveRule(index:int, rule:TradeRequirementRule):Boolean
        {
            if (rule == null || index < 0 || index >= this._giveRules.length) { return false; }
            this._giveRules[index] = rule.deepCopy();
            return true;
        }

        public function setGetRule(rule:TradeRequirementRule):void
        {
            this._getRule = rule == null ? null : rule.deepCopy();
        }

        public function get giveRules():Vector.<TradeRequirementRule> { return this._giveRules.concat(); }
        public function get getRule():TradeRequirementRule { return this._getRule == null ? null : this._getRule.deepCopy(); }
        public function get valid():Boolean { return this._getRule != null && this._getRule.nodes.length > 0; }

        public function finalizeDefinition():TradeRequirementRulesDefinition
        {
            var give:Vector.<TradeRequirementRule> = new Vector.<TradeRequirementRule>();
            for each (var rule:TradeRequirementRule in this._giveRules)
            {
                if (rule.nodes.length > 0) { give.push(rule.deepCopy()); }
            }
            return new TradeRequirementRulesDefinition(give.length > 0 ? give : null,
                this._getRule == null ? null : this._getRule.deepCopy());
        }
    }
}
