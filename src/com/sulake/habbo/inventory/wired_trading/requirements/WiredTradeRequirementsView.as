package com.sulake.habbo.inventory.wired_trading.requirements
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IBubbleWindow;
    import com.sulake.core.window.components.IHTMLTextWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementTypes;
    import com.sulake.habbo.inventory.wired_trading.WiredTradingModel;
    import com.sulake.habbo.inventory.wired_trading.requirements.offerings.OfferingRequirementsView;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class WiredTradeRequirementsView implements IDisposable
    {
        private static const MIN_BORDER_HEIGHT:int = 80;
        private static const BORDER_TOP_BOTTOM_OFFSET:int = 18;
        private static const MINIMAL_WIDTH:int = 122;
        private static const NORMAL_WIDTH:int = 180;

        private var _model:WiredTradeRequirementsModel;
        private var _bubble:IBubbleWindow;
        private var _offeringTemplate:IWindowContainer;
        private var _requirement:TradeRequirement;
        private var _give:OfferingRequirementsView;
        private var _receive:OfferingRequirementsView;
        private var _offeringBorderMargins:int;
        private var _highlightTimer:Timer;
        private var _disposed:Boolean;

        public function WiredTradeRequirementsView(
            model:WiredTradeRequirementsModel)
        {
            this._model = model;
            this._bubble = model.tradingModel.getWindowContainer()
                .findChildByName("trade_requirements_bubble") as IBubbleWindow;
            this._bubble.visible = false;
            this.requirementsButton.addEventListener(
                WindowMouseEvent.CLICK, this.onRequirementsClicked);
            this._offeringTemplate = this.youGiveContainer.getChildByName(
                "offering_requirements_template") as IWindowContainer;
            this._offeringBorderMargins = this._offeringTemplate.height
                - this._offeringTemplate.findChildByName(
                    "requirements_definition").height;
            this.youGiveContainer.removeChild(this._offeringTemplate);
            this.recenter();
        }

        private function onRequirementsClicked(event:WindowMouseEvent):void
        {
            this._bubble.visible = !this._bubble.visible;
        }

        public function requirementsUpdated(
            requirement:TradeRequirement, showImmediate:Boolean):void
        {
            this.clear();
            this._requirement = requirement;
            var paymentOnly:Boolean = requirement.isPaymentOnly();
            this.bubbleTitle.text =
                this.tradingModel.localization.getLocalizationWithParams(
                    "inventory.wired_trading.requirements.title", "",
                    "type", this.tradingModel.tradeTypeLocalization);

            var showReceive:Boolean = !paymentOnly
                || (requirement.youGetText != null
                    && requirement.youGetText.length > 0);
            this.offeringContainersSeparator.visible = showReceive;
            this.youGetContainer.visible = showReceive;

            this._give = new OfferingRequirementsView(
                this._offeringTemplate);
            this._give.initialize(
                this._model,
                requirement.type,
                requirement.rules == null
                    ? null : requirement.rules.youGiveRule,
                null,
                OfferingRequirementsView.TYPE_GIVE);
            this.youGiveContainer.addChild(this._give.window);
            this.stretchToParent(this._give.window);

            if (showReceive)
            {
                var receiveRules:Vector.<TradeRequirementRule> =
                    new Vector.<TradeRequirementRule>();
                if (requirement.rules != null
                    && requirement.rules.youGetRule != null)
                {
                    receiveRules.push(requirement.rules.youGetRule);
                }
                this._receive = new OfferingRequirementsView(
                    this._offeringTemplate);
                this._receive.initialize(
                    this._model,
                    requirement.type,
                    receiveRules,
                    requirement.youGetText,
                    OfferingRequirementsView.TYPE_RECEIVE);
                this.youGetContainer.addChild(this._receive.window);
                this.stretchToParent(this._receive.window);
            }

            this.requirementsStateUpdated();
            this.disclaimerText.visible = paymentOnly && showReceive;
            if (this.disclaimerText.visible)
            {
                this.disclaimerText.text =
                    this.tradingModel.localization.getLocalizationWithParams(
                        "inventory.wired_trading.requirements.receive_text_disclaimer",
                        "",
                        "you_get_name",
                        this.tradingModel.localization.getLocalization(
                            "inventory.wired_trading.requirements.receiving"));
                this.resizeHtml(this.disclaimerText);
            }
            this._bubble.visible = showImmediate;
        }

        public function requirementsStateUpdated():void
        {
            if (this._requirement == null || this._give == null)
            {
                return;
            }
            var met:Boolean = this.tradingModel.canAccept;
            var amount:int = this.tradingModel.extra;
            if (this._requirement.rules != null
                && this._requirement.rules.type
                    == TradeRequirementTypes.FIXED_MULTIPLIER)
            {
                this.requirementsMetText.text =
                    this.tradingModel.localization.getLocalizationWithParams(
                        "inventory.wired_trading.requirements.indicator.multi",
                        "",
                        "times", this._requirement.rules.multiplier,
                        "amount", amount);
            }
            else if (met)
            {
                if (this._requirement.rules != null
                    && this._requirement.rules.type
                        == TradeRequirementTypes.AUTO_MULTIPLIER
                    && amount > 1)
                {
                    this.requirementsMetText.text =
                        this.tradingModel.localization.getLocalizationWithParams(
                            "inventory.wired_trading.requirements.indicator.met_numbered",
                            "", "amount", amount);
                }
                else
                {
                    this.requirementsMetText.text =
                        this.tradingModel.localization.getLocalization(
                            "inventory.wired_trading.requirements.indicator.met");
                }
            }
            else
            {
                this.requirementsMetText.text =
                    this.tradingModel.localization.getLocalization(
                        "inventory.wired_trading.requirements.indicator.not_met");
            }
            this.resizeHtml(this.requirementsMetText);
            this.requirementsMetIcon.assetUri =
                met ? "common_check_mark" : "common_cross_mark";

            this.additionalText.visible = false;
            if (this._requirement.rules != null
                && this._requirement.rules.type
                    == TradeRequirementTypes.AUTO_MULTIPLIER)
            {
                this.additionalText.visible = true;
                var key:String = this._requirement.isPaymentOnly()
                    ? "inventory.wired_trading.requirements.auto_mode_hint_payment"
                    : "inventory.wired_trading.requirements.auto_mode_hint_trade";
                this.additionalText.text =
                    this.tradingModel.localization.getLocalizationWithParams(
                        key, "",
                        "amount", this._requirement.rules.autoMultiplierMax);
                this.resizeHtml(this.additionalText);
            }
            this.resizeRequirementContainers();
            this.recenter();
        }

        private function resizeRequirementContainers():void
        {
            var width:int = NORMAL_WIDTH;
            if (this.youGetContainer.visible && this._receive != null
                && this._give.canMinimalizeWidth
                && this._receive.canMinimalizeWidth)
            {
                width = MINIMAL_WIDTH;
            }
            this.youGiveContainer.width = width;
            this.youGetContainer.width = width;

            var borderHeight:int = this._give.minBorderHeight;
            if (this._receive != null)
            {
                borderHeight = Math.max(
                    borderHeight, this._receive.minBorderHeight);
            }
            borderHeight = Math.max(
                MIN_BORDER_HEIGHT,
                borderHeight + 2 * BORDER_TOP_BOTTOM_OFFSET);
            this.offeringContainersSeparator.height = borderHeight;
            var containerHeight:int =
                borderHeight + this._offeringBorderMargins;
            this.youGiveContainer.height = containerHeight;
            this.youGetContainer.height = containerHeight;
            this._give.centerActiveElement();
            if (this._receive != null)
            {
                this._receive.centerActiveElement();
            }
        }

        private function stretchToParent(window:IWindowContainer):void
        {
            window.width = window.parent.width;
            window.height = window.parent.height;
            window.setParamFlag(128, true);
            window.setParamFlag(2048, true);
        }

        private function resizeHtml(window:IHTMLTextWindow):void
        {
            window.height = window.numLines * 15 + 2;
        }

        private function recenter():void
        {
            this._bubble.x = this.requirementsButton.x
                + this.requirementsButton.width + 4;
            this._bubble.y = this.requirementsButton.y
                + this.requirementsButton.height / 2
                - this._bubble.height / 2;
        }

        public function highlightRefresh():void
        {
            if (this._highlightTimer != null)
            {
                this._highlightTimer.stop();
                this._highlightTimer.reset();
            }
            this.highlightBorder.visible = true;
            this.highlightBorder.blend = 0.35;
            this._highlightTimer = new Timer(500, 1);
            this._highlightTimer.addEventListener(
                TimerEvent.TIMER_COMPLETE, this.onHighlightComplete);
            this._highlightTimer.start();
        }

        private function onHighlightComplete(event:TimerEvent):void
        {
            this.highlightBorder.visible = false;
        }

        private function clear():void
        {
            if (this._give != null)
            {
                if (this._give.window.parent != null)
                {
                    this.youGiveContainer.removeChild(this._give.window);
                }
                this._give.dispose();
                this._give = null;
            }
            if (this._receive != null)
            {
                if (this._receive.window.parent != null)
                {
                    this.youGetContainer.removeChild(this._receive.window);
                }
                this._receive.dispose();
                this._receive = null;
            }
            this._requirement = null;
        }

        public function dispose():void
        {
            if (this._disposed) { return; }
            this.clear();
            this.requirementsButton.removeEventListener(
                WindowMouseEvent.CLICK, this.onRequirementsClicked);
            if (this._highlightTimer != null)
            {
                this._highlightTimer.stop();
                this._highlightTimer.removeEventListener(
                    TimerEvent.TIMER_COMPLETE, this.onHighlightComplete);
                this._highlightTimer = null;
            }
            this.youGiveContainer.addChild(this._offeringTemplate);
            this._offeringTemplate = null;
            this._bubble = null;
            this._model = null;
            this._disposed = true;
        }

        public function get disposed():Boolean { return this._disposed; }
        private function get tradingModel():WiredTradingModel
        { return this._model.tradingModel; }
        private function get requirementsButton():IRegionWindow
        { return this.tradingModel.tradingView.requirementsButton; }
        private function get bubbleTitle():ITextWindow
        { return this._bubble.findChildByName("bubble_title") as ITextWindow; }
        private function get highlightBorder():IBorderWindow
        { return this._bubble.findChildByName("highlight_border") as IBorderWindow; }
        private function get youGiveContainer():IWindowContainer
        { return this._bubble.findChildByName("you_give_container") as IWindowContainer; }
        private function get youGetContainer():IWindowContainer
        { return this._bubble.findChildByName("you_get_container") as IWindowContainer; }
        private function get offeringContainersSeparator():IWidgetWindow
        { return this._bubble.findChildByName("offering_containers_separator") as IWidgetWindow; }
        private function get requirementsMetText():IHTMLTextWindow
        { return this._bubble.findChildByName("req_met_text") as IHTMLTextWindow; }
        private function get requirementsMetIcon():IStaticBitmapWrapperWindow
        { return this._bubble.findChildByName("req_met_icon") as IStaticBitmapWrapperWindow; }
        private function get additionalText():IHTMLTextWindow
        { return this._bubble.findChildByName("additional_text") as IHTMLTextWindow; }
        private function get disclaimerText():IHTMLTextWindow
        { return this._bubble.findChildByName("disclaimer_text") as IHTMLTextWindow; }
    }
}
