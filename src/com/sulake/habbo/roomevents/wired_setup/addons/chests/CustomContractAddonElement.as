package com.sulake.habbo.roomevents.wired_setup.addons.chests
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.addons.AddonCodes;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 20: override a contract's payment and reward requirements. */
    public class CustomContractAddonElement extends DefaultElement
    {
        private static const TYPE_FURNI:int = 1;

        private var _paymentEnabled:CheckboxGroupPreset;
        private var _paymentType:RadioGroupPreset;
        private var _paymentAmount:ValueOrVariableSection;
        private var _rewardEnabled:CheckboxGroupPreset;
        private var _rewardType:RadioGroupPreset;
        private var _rewardAmount:ValueOrVariableSection;

        override public function get code():int { return AddonCodes.CUSTOM_CONTRACT; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.CHESTS |
                WiredCapabilityCodes.CHEST_WIRED | WiredCapabilityCodes.CONTRACTS |
                WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        override public function readIntParamsFromForm():Array
        {
            return [
                this._paymentEnabled.get(0).selected ? 1 : 0,
                this._paymentType.selected,
                this._paymentAmount.option,
                this._paymentAmount.numberValue,
                this._paymentAmount.target,
                this._rewardEnabled.get(0).selected ? 1 : 0,
                this._rewardType.selected,
                this._rewardAmount.option,
                this._rewardAmount.numberValue,
                this._rewardAmount.target
            ];
        }

        override public function readVariableIdsFromForm():Array
        {
            return [this._paymentAmount.finalizeSelection, this._rewardAmount.finalizeSelection];
        }

        override public function onEditStart(definition:Triggerable):void
        {
            this.initSide(definition, true);
            this.initSide(definition, false);
            this.onPaymentEnabled(0, this._paymentEnabled.get(0).selected);
            this.onRewardEnabled(0, this._rewardEnabled.get(0).selected);
        }

        private function initSide(definition:Triggerable, payment:Boolean):void
        {
            var base:int = payment ? 0 : 5;
            var variableIndex:int = payment ? 0 : 1;
            var enabled:Boolean = definition.intData.length > base &&
                int(definition.intData[base]) != 0;
            var type:int = definition.intData.length > base + 1 ?
                int(definition.intData[base + 1]) : 0;
            var option:int = definition.intData.length > base + 2 ?
                int(definition.intData[base + 2]) : 0;
            var amount:int = definition.intData.length > base + 3 ?
                int(definition.intData[base + 3]) : 1;
            var target:int = definition.intData.length > base + 4 ?
                int(definition.intData[base + 4]) : 0;
            var variableId:String = definition.variableIds.length > variableIndex ?
                String(definition.variableIds[variableIndex]) : WiredVariable.NONE_ID;
            if (enabled)
            {
                if (option == 0) variableId = WiredVariable.NONE_ID;
                else amount = 1;
            }
            else
            {
                variableId = WiredVariable.NONE_ID;
                amount = 1;
            }
            var enabledGroup:CheckboxGroupPreset = payment ?
                this._paymentEnabled : this._rewardEnabled;
            var typeGroup:RadioGroupPreset = payment ? this._paymentType : this._rewardType;
            var valueSection:ValueOrVariableSection = payment ?
                this._paymentAmount : this._rewardAmount;
            enabledGroup.get(0).selected = enabled;
            typeGroup.selected = type;
            valueSection.init(definition.wiredContext.roomVariablesList, variableId,
                target, option, amount);
        }

        override public function onEditInitialized():void
        {
            this._paymentAmount.onEditInitialized();
            this._rewardAmount.onEditInitialized();
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._paymentType = this.createTypeGroup(manager, this.onPaymentType);
            this._paymentAmount = manager.createValueOrVariableSection(0,
                this.mergedSourceOptions(0),
                "${wiredfurni.params.custom_contract.amount_selection}", 1, 100000);
            var paymentList:SimpleListViewPreset = manager.createSimpleListView(true, [
                manager.createSection("${wiredfurni.params.custom_contract.element_type_selection}",
                    this._paymentType),
                manager.createSpacer(style.sectionSpacing),
                this._paymentAmount
            ]);
            paymentList.spacing = 0;
            var paymentOption:CheckboxOptionParam =
                new CheckboxOptionParam("${wiredfurni.params.custom_contract.enable_payment}");
            paymentOption.extra2 = paymentList;
            this._paymentEnabled = manager.createCheckboxGroup([paymentOption],
                this.onPaymentEnabled);

            this._rewardType = this.createTypeGroup(manager, this.onRewardType);
            this._rewardAmount = manager.createValueOrVariableSection(1,
                this.mergedSourceOptions(1),
                "${wiredfurni.params.custom_contract.amount_selection}", 1, 100000);
            var rewardList:SimpleListViewPreset = manager.createSimpleListView(true, [
                manager.createSection("${wiredfurni.params.custom_contract.element_type_selection}",
                    this._rewardType),
                manager.createSpacer(style.sectionSpacing),
                this._rewardAmount
            ]);
            rewardList.spacing = 0;
            var rewardOption:CheckboxOptionParam =
                new CheckboxOptionParam("${wiredfurni.params.custom_contract.enable_reward}");
            rewardOption.extra2 = rewardList;
            this._rewardEnabled = manager.createCheckboxGroup([rewardOption],
                this.onRewardEnabled);

            builder.addElements(
                manager.createUsageInfoSection(
                    "${wiredfurni.params.custom_contract.usage_warning}", true),
                manager.createSection("${wiredfurni.params.custom_contract.payment}",
                    this._paymentEnabled, SectionParam.COLLAPSED),
                manager.createSection("${wiredfurni.params.custom_contract.reward}",
                    this._rewardEnabled, SectionParam.COLLAPSED),
                manager.createWrapperPreset(style.createSplitterView()));
        }

        private function createTypeGroup(manager:PresetManager, callback:Function):RadioGroupPreset
        {
            return manager.createRadioGroup([
                new RadioButtonParam(0,
                    "${wiredfurni.params.custom_contract.element_type_selection.0}"),
                new RadioButtonParam(1,
                    "${wiredfurni.params.custom_contract.element_type_selection.1}")
            ], callback, 2);
        }

        private function onPaymentEnabled(index:int, selected:Boolean):void
        {
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.FURNI_SOURCE, 0);
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 0);
        }
        private function onRewardEnabled(index:int, selected:Boolean):void
        {
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.FURNI_SOURCE, 1);
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 1);
        }
        private function onPaymentType(value:int):void
        {
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.FURNI_SOURCE, 0);
        }
        private function onRewardType(value:int):void
        {
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.FURNI_SOURCE, 1);
        }

        override public function isInputSourceDisabled(index:int, sourceType:int):Boolean
        {
            if (sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 0)
                return !this._paymentEnabled.get(0).selected ||
                    this._paymentAmount.isSourcePickingDisabled();
            if (sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 1)
                return !this._rewardEnabled.get(0).selected ||
                    this._rewardAmount.isSourcePickingDisabled();
            if (sourceType == WiredInputSourcePicker.FURNI_SOURCE && index == 0)
                return !this._paymentEnabled.get(0).selected ||
                    this._paymentType.selected != TYPE_FURNI;
            if (sourceType == WiredInputSourcePicker.FURNI_SOURCE && index == 1)
                return !this._rewardEnabled.get(0).selected ||
                    this._rewardType.selected != TYPE_FURNI;
            return false;
        }

        override public function mergedSelectionTitle(index:int):String
        {
            return index == 0 ?
                "wiredfurni.params.sources.merged.title.variables_reference_payment" :
                "wiredfurni.params.sources.merged.title.variables_reference_reward";
        }
        override public function furniSelectionTitle(index:int):String
        {
            return index == 0 ? "wiredfurni.params.sources.furni.title.payment" :
                "wiredfurni.params.sources.furni.title.reward";
        }
        override public function mergedSelections():Array { return [[2, 0], [3, 1]]; }
        override public function setMergedType(index:int, value:int):void
        {
            if (index == 0) this._paymentAmount.target = value;
            else this._rewardAmount.target = value;
        }
        override public function getMergedType(index:int):int
        {
            return index == 0 ? this._paymentAmount.target : this._rewardAmount.target;
        }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
        override public function get widthModifier():Number { return 1.2; }
    }
}
