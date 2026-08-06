package com.sulake.habbo.roomevents.wired_setup.actiontypes.chests
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Shared July editor contract for actions 45 and 46. */
    public class GiveFromChestActionElement extends DefaultElement
    {
        protected static const MODE_AMOUNT:int = 0;
        protected static const MODE_ALL:int = 1;

        private var _modeSection:SectionPreset;
        private var _amount:ValueOrVariableSection;
        private var _popupSection:SectionPreset;
        private var _mode:RadioGroupPreset;
        private var _popupText:TextAreaPreset;
        private var _showPopup:CheckboxGroupPreset;

        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.CHESTS | WiredCapabilityCodes.CHEST_WIRED |
                WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._mode.selected, this._amount.numberValue, this._amount.option,
                this._amount.target, this._showPopup.get(0).selected ? 1 : 0];
        }

        override public function readVariableIdsFromForm():Array
        {
            return [this._amount.finalizeSelection];
        }

        override public function readStringParamFromForm():String { return this._popupText.text; }

        override public function onEditStart(definition:Triggerable):void
        {
            var values:Array = definition.intData;
            var variableId:String = definition.variableIds.length > 0 ?
                String(definition.variableIds[0]) : WiredVariable.NONE_ID;
            var mode:int = values.length > 0 ? int(values[0]) : MODE_AMOUNT;
            var amount:int = values.length > 1 ? int(values[1]) : 1;
            var option:int = values.length > 2 ? int(values[2]) : 0;
            var target:int = values.length > 3 ? int(values[3]) : 0;
            if (mode == MODE_AMOUNT)
            {
                if (option == 0) variableId = WiredVariable.NONE_ID;
                else amount = 1;
            }
            else
            {
                variableId = WiredVariable.NONE_ID;
                amount = 1;
            }
            this._mode.selected = mode;
            this._amount.disabled = mode == MODE_ALL;
            this._amount.init(definition.wiredContext.roomVariablesList, variableId,
                target, option, amount);
            this._showPopup.get(0).selected = values.length > 4 && int(values[4]) != 0;
            this._popupText.text = definition.stringData;
        }

        override public function onEditInitialized():void { this._amount.onEditInitialized(); }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(MODE_AMOUNT, this.l("rewarding_mode.0")),
                new RadioButtonParam(MODE_ALL, this.l("rewarding_mode.1"))
            ], this.onModeChange);
            this._modeSection = manager.createSection(this.l("rewarding_mode"), this._mode);
            this._amount = manager.createValueOrVariableSection(0, this.mergedSourceOptions(0),
                this.l("amount_to_give"), 1, 2147483647);
            this._popupText = manager.createTextArea(new TextAreaParam(45, -1, 3, -1, 200,
                "", "${wiredfurni.reward_contract.reward_popup.text.tooltip}"));
            this._showPopup = manager.createCheckboxGroup([new CheckboxOptionParam(
                "${wiredfurni.reward_contract.reward_popup.show_by_default}")]);
            var list:SimpleListViewPreset = manager.createSimpleListView(true,
                [this._popupText, this._showPopup]);
            this._popupSection = manager.createSection(
                "${wiredfurni.reward_contract.reward_popup}", list);
            this.finalizeBuilding(builder);
        }

        protected function finalizeBuilding(builder:WiredUIBuilder):void
        {
            builder.addElements(this._modeSection, this._amount, this._popupSection);
        }

        protected function get rewardingMode():int { return this._mode.selected; }

        protected function onModeChange(value:int):void
        {
            this._amount.disabled = value == MODE_ALL;
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 0);
        }

        override public function isInputSourceDisabled(index:int, sourceType:int):Boolean
        {
            return sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 0 &&
                (this._amount.isSourcePickingDisabled() || this._amount.disabled);
        }

        override public function mergedSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function furniSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.furni.title.chests";
        }
        override public function userSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.users.title.reward_user";
        }
        override public function mergedSelections():Array { return [[1, 1]]; }
        override public function setMergedType(index:int, value:int):void { this._amount.target = value; }
        override public function getMergedType(index:int):int { return this._amount.target; }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
