package com.sulake.habbo.inventory.wired_trading.requirements.offerings
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.inventory.wired_trading.requirements.WiredTradeRequirementsModel;

    public class OfferingRequirementsView implements IDisposable
    {
        public static const TYPE_GIVE:int = 0;
        public static const TYPE_RECEIVE:int = 1;

        private var _model:WiredTradeRequirementsModel;
        private var _window:IWindowContainer;
        private var _ruleTemplate:IWindowContainer;
        private var _rules:Vector.<OfferingRuleView>;
        private var _active:IWindow;
        private var _canMinimalizeWidth:Boolean;
        private var _disposed:Boolean;

        public function OfferingRequirementsView(template:IWindowContainer)
        {
            this._window = template.clone() as IWindowContainer;
            this._ruleTemplate =
                this.rulesList.removeListItemAt(0) as IWindowContainer;
        }

        public function initialize(
            model:WiredTradeRequirementsModel,
            type:int,
            rules:Vector.<TradeRequirementRule>,
            customTextValue:String,
            side:int):void
        {
            this.clearRules();
            this._model = model;
            this._rules = new Vector.<OfferingRuleView>();
            this.rulesList.visible = false;
            this.customText.visible = false;
            this.anyAllText.visible = false;
            this.anyCoinsText.visible = false;
            this.anyFurniText.visible = false;
            this._active = null;
            this._canMinimalizeWidth = false;

            if (type != TradeRequirement.TYPE_RULES && side == TYPE_GIVE)
            {
                if (type == TradeRequirement.TYPE_CREDIT_FURNI)
                {
                    this.anyCoinsText.visible = true;
                    this._active = this.anyCoinsText;
                }
                else if (type == TradeRequirement.TYPE_NORMAL_FURNI)
                {
                    this.anyFurniText.visible = true;
                    this._active = this.anyFurniText;
                }
                else if (type == TradeRequirement.TYPE_ANY_FURNI)
                {
                    this.anyAllText.visible = true;
                    this._active = this.anyAllText;
                }
            }
            else
            {
                if (rules != null && rules.length > 0)
                {
                    this.rulesList.visible = true;
                    this._active = this.rulesList;
                    this._canMinimalizeWidth = true;
                    var index:int = 0;
                    for each (var rule:TradeRequirementRule in rules)
                    {
                        var ruleView:OfferingRuleView =
                            new OfferingRuleView(this._ruleTemplate);
                        ruleView.initialize(rule, index++);
                        this._rules.push(ruleView);
                        this.rulesList.addListItem(ruleView.window);
                        if (rule.nodes.length != 1)
                        {
                            this._canMinimalizeWidth = false;
                        }
                    }
                }
                if (!this.rulesList.visible && customTextValue != null
                    && customTextValue.length > 0)
                {
                    this.customText.visible = true;
                    this.customText.text = customTextValue;
                    this._active = this.customText;
                    this._canMinimalizeWidth =
                        this.customText.textWidth <= 100;
                }
            }
            this.title.text = model.tradingModel.localization.getLocalization(
                side == TYPE_GIVE
                    ? "inventory.wired_trading.requirements.offering"
                    : "inventory.wired_trading.requirements.receiving");
            this.centerActiveElement();
        }

        public function centerActiveElement():void
        {
            if (this._active == null)
            {
                return;
            }
            this._active.y = this.requirementsBorder.height / 2
                - this._active.height / 2;
            if (this._rules != null && this._rules.length == 1)
            {
                this._rules[0].center(
                    this.requirementsBorder.width - this.rulesList.x * 2);
            }
        }

        private function clearRules():void
        {
            this.rulesList.removeListItems();
            if (this._rules != null)
            {
                for each (var rule:OfferingRuleView in this._rules)
                {
                    rule.dispose();
                }
            }
            this._rules = null;
        }

        public function get canMinimalizeWidth():Boolean
        { return this._canMinimalizeWidth; }
        public function get minBorderHeight():int
        { return this._active == null ? 0 : this._active.height; }
        public function get window():IWindowContainer { return this._window; }

        public function dispose():void
        {
            if (this._disposed) { return; }
            this.clearRules();
            this._ruleTemplate.dispose();
            this._ruleTemplate = null;
            this._window.dispose();
            this._window = null;
            this._model = null;
            this._active = null;
            this._disposed = true;
        }

        public function get disposed():Boolean { return this._disposed; }
        private function get title():ITextWindow
        { return this._window.findChildByName("offerings_title") as ITextWindow; }
        private function get requirementsBorder():IBorderWindow
        { return this._window.findChildByName("requirements_definition") as IBorderWindow; }
        private function get rulesList():IItemListWindow
        { return this._window.findChildByName("rules_list") as IItemListWindow; }
        private function get customText():ITextWindow
        { return this._window.findChildByName("custom_text") as ITextWindow; }
        private function get anyFurniText():ITextWindow
        { return this._window.findChildByName("any_furni_text") as ITextWindow; }
        private function get anyCoinsText():ITextWindow
        { return this._window.findChildByName("any_coins_text") as ITextWindow; }
        private function get anyAllText():ITextWindow
        { return this._window.findChildByName("any_all_text") as ITextWindow; }
    }
}
