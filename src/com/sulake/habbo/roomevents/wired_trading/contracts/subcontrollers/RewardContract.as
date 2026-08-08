package com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers
{
    import com.sulake.core.communication.util.Short;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRulesDefinition;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.TradeRuleEditorPreset;
    import com.sulake.habbo.roomevents.wired_trading.contracts.WiredContractController;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.util.AbstractContract;

    public class RewardContract extends AbstractContract
    {
        private var _rule:TradeRuleEditorPreset;
        private var _category:DropdownPreset;
        private var _categorySection:SectionPreset;
        private var _rewardText:TextAreaPreset;
        private var _showByDefault:CheckboxGroupPreset;

        public function RewardContract(parent:WiredContractController,
            presetManager:PresetManager)
        {
            super(parent, presetManager);
            this._rule = presetManager.createRuleEditorPreset(
                "${wiredcontracts.reward_rule}",
                parent.addEditContractElement.onEdit,
                parent.addEditContractElement.onAdd, null,
                this.onRulesChange);
            var ruleSection:SectionPreset = presetManager.createSection(
                "${wiredcontracts.reward_requirements}", this._rule);
            this._rewardText = presetManager.createTextArea(new TextAreaParam(
                52, -1, 3, -1, 200, "",
                "${wiredcontracts.reward_contract.reward_popup.text.tooltip}"));
            this._showByDefault = presetManager.createCheckboxGroup([
                new CheckboxOptionParam(
                    "${wiredcontracts.reward_contract.reward_popup.show_by_default}")
            ]);
            var popupContents:SimpleListViewPreset =
                presetManager.createSimpleListView(true,
                    [this._rewardText, this._showByDefault]);
            var popupSection:SectionPreset = presetManager.createSection(
                "${wiredcontracts.reward_contract.reward_popup}", popupContents);
            var options:Vector.<ExpandableDropdownOption> =
                new <ExpandableDropdownOption>[
                    new ExpandableDropdownOption(11,
                        "${wiredfurni.params.earnings_category.11}"),
                    new ExpandableDropdownOption(13,
                        "${wiredfurni.params.earnings_category.13}")
                ];
            this._category = presetManager.createDropdown(new DropdownParam(
                "${wiredcontracts.reward_contract.earnings_category}", options));
            this._categorySection = presetManager.createSection(
                "${wiredcontracts.reward_contract.earnings_category}",
                this._category, SectionParam.COLLAPSED);
            this.framePreset = presetManager.createFramePreset(
                [ruleSection, popupSection, this._categorySection,
                    this.footerPreset], this.onCloseClicked);
            this.framePreset.resizeToWidth(262);
            this.framePreset.title = "${wiredcontracts.reward_contract.title}";
        }

        private function onRulesChange():void
        {
            this._categorySection.disabled = !this.hasCreditNode();
        }

        private function hasCreditNode():Boolean
        {
            var rule:TradeRequirementRule = this._rule.finalizeRule();
            for each (var node:TradeRequirementNode in rule.nodes)
                if (node.type == TradeRequirementNode.TYPE_COIN) return true;
            return false;
        }

        override protected function createNewDefinitionFromUI():TradeRequirementRulesDefinition
        {
            return new TradeRequirementRulesDefinition(null, this._rule.finalizeRule());
        }

        override public function show(contents:ChestContractContentsMessageParser):void
        {
            if (contents.contractType != this.contractType() ||
                contents.definition.youGetRule == null) return;
            super.show(contents);
            this._rule.rule = contents.definition.youGetRule;
            this._showByDefault.get(0).selected = contents.showDialog;
            this._category.selectedId = contents.rewardCategory;
            this._rewardText.text = contents.rewardText;
            this.onRulesChange();
            this._categorySection.updateDisabledState();
            this.showFrame();
        }

        override public function addContentsToComposer(data:Array):void
        {
            super.addContentsToComposer(data);
            data.push(new Short(this._category.selectedId));
            data.push(this._showByDefault.get(0).selected);
            data.push(this._rewardText.text);
        }

        override public function contractType():int { return 2; }

        override public function dispose():void
        {
            if (disposed) return;
            this._rule = null;
            this._category = null;
            this._categorySection = null;
            this._rewardText = null;
            this._showByDefault = null;
            super.dispose();
        }
    }
}
