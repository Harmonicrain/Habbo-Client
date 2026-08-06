package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /**
     * July AIR's contract shown when a Wired Trading session starts.
     * The rule payload exists only for TYPE_RULES.
     */
    public class TradeRequirement
    {
        public static const TYPE_CREDIT_FURNI:int = 0;
        public static const TYPE_NORMAL_FURNI:int = 1;
        public static const TYPE_ANY_FURNI:int = 2;
        public static const TYPE_RULES:int = 4;

        // Kept as source aliases for code written before the July discriminator
        // meanings were recovered.
        public static const TYPE_NONE:int = TYPE_CREDIT_FURNI;
        public static const TYPE_TEXT:int = TYPE_NORMAL_FURNI;
        public static const TYPE_PAYMENT:int = TYPE_ANY_FURNI;

        private var _type:int;
        private var _youGetText:String;
        private var _layoutType:String;
        private var _rules:TradeRequirementRules;

        public function TradeRequirement(data:IMessageDataWrapper)
        {
            this._type = data.readInteger();
            this._youGetText = data.readString();
            this._layoutType = data.readString();
            if (this._type == TYPE_RULES)
            {
                this._rules = new TradeRequirementRules(data);
            }
        }

        public function get type():int { return this._type; }
        public function get youGetText():String { return this._youGetText; }
        public function get layoutType():String { return this._layoutType; }
        public function get rules():TradeRequirementRules { return this._rules; }

        public function isPaymentOnly():Boolean
        {
            return this._type != TYPE_RULES || this._rules.youGetRule == null
                || this._rules.youGetRule.nodes.length == 0;
        }
    }
}
