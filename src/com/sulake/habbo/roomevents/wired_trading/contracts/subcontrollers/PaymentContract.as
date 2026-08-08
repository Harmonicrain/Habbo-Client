package com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers
{
    import com.sulake.core.communication.util.Short;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRulesDefinition;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.TradeRuleListEditorPreset;
    import com.sulake.habbo.roomevents.wired_trading.contracts.WiredContractController;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.util.AbstractContract;

    public class PaymentContract extends AbstractContract
    {
        private static const LAYOUT_TYPES:Array = ["generic", "games"];

        private var _mode:RadioGroupPreset;
        private var _receiveText:TextInputPreset;
        private var _rules:TradeRuleListEditorPreset;
        private var _rulesSection:SectionPreset;
        private var _layout:DropdownPreset;

        public function PaymentContract(parent:WiredContractController,
            presetManager:PresetManager)
        {
            super(parent, presetManager);
            this._mode = presetManager.createRadioGroup([
                new RadioButtonParam(0, "${wiredcontracts.payment_contract.mode.0}"),
                new RadioButtonParam(1, "${wiredcontracts.payment_contract.mode.1}")
            ], this.onPaymentModeChange);
            var modeSection:SectionPreset = presetManager.createSection(
                "${wiredcontracts.payment_contract.mode}", this._mode);
            this._receiveText = presetManager.createTextInput(
                new TextInputParam("", 60));
            var textSection:SectionPreset = presetManager.createSection(
                "${wiredcontracts.payment_contract.receive_text}", this._receiveText);
            this._rules = presetManager.createRuleListEditorPreset(
                parent.addEditContractElement.onEdit,
                parent.addEditContractElement.onAdd);
            this._rulesSection = presetManager.createSection(
                "${wiredcontracts.payment_requirements}", this._rules);
            var options:Vector.<ExpandableDropdownOption> =
                new Vector.<ExpandableDropdownOption>();
            options.push(new ExpandableDropdownOption(0,
                "${wiredcontracts.payment_contract.layout_type.0}"));
            options.push(new ExpandableDropdownOption(1,
                "${wiredcontracts.payment_contract.layout_type.1}"));
            this._layout = presetManager.createDropdown(new DropdownParam(
                "${wiredcontracts.payment_contract.layout_type}", options));
            var layoutSection:SectionPreset = presetManager.createSection(
                "${wiredcontracts.payment_contract.layout_type}", this._layout,
                SectionParam.COLLAPSED);
            this.framePreset = presetManager.createFramePreset(
                [modeSection, textSection, this._rulesSection,
                    layoutSection, this.footerPreset],
                this.onCloseClicked);
            this.framePreset.resizeToWidth(262);
            this.framePreset.title = "${wiredcontracts.payment_contract.title}";
        }

        private function onPaymentModeChange(value:int):void
        {
            this._rulesSection.disabled = value != 1;
        }

        override protected function createNewDefinitionFromUI():TradeRequirementRulesDefinition
        {
            return new TradeRequirementRulesDefinition(this._rules.finalizeRules(), null);
        }

        override public function show(contents:ChestContractContentsMessageParser):void
        {
            if (contents.contractType != this.contractType() ||
                contents.definition.youGiveRule == null) return;
            super.show(contents);
            this._mode.selected = contents.paymentMode;
            this._receiveText.text = contents.receiveText;
            this._layout.selectedId = LAYOUT_TYPES.indexOf(contents.layoutType);
            this._rules.rules = contents.definition.youGiveRule;
            this.onPaymentModeChange(contents.paymentMode);
            this._rulesSection.updateDisabledState();
            this.showFrame();
        }

        override public function addContentsToComposer(data:Array):void
        {
            super.addContentsToComposer(data);
            data.push(new Short(this._mode.selected));
            data.push(this._receiveText.text);
            var index:int = this._layout.selectedId;
            if (index < 0 || index >= LAYOUT_TYPES.length) index = 0;
            data.push(LAYOUT_TYPES[index]);
        }

        override public function contractType():int { return 0; }

        override public function dispose():void
        {
            if (disposed) return;
            this._mode = null;
            this._receiveText = null;
            this._rules = null;
            this._rulesSection = null;
            this._layout = null;
            super.dispose();
        }
    }
}
