package com.sulake.habbo.roomevents.wired_setup.selectors
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxOptionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * July AIR variable-comparison selector shared by selector 17 (furni) and
     * selector 18 (users). Its payload is:
     * [comparison, valueFilterMode, valueSign, valueInt, referenceScope],
     * with [targetVariableId, referenceVariableId] in variableIds.
     */
    public class VariableSelectorElement extends DefaultElement
    {
        private var _variableSection:SectionPreset;
        private var _picker:VariablePickerPreset;
        private var _valueEnabledSection:SectionPreset;
        private var _valueEnabled:CheckboxOptionPreset;
        private var _comparisonSection:SectionPreset;
        private var _comparison:RadioGroupPreset;
        private var _referenceSection:ValueOrVariableSection;

        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return true;
        }

        /** The target scope is fixed by the concrete selector: furni or user. */
        protected function get variableSource():int { return WiredInputSourcePicker.FURNI_SOURCE; }

        override public function readIntParamsFromForm():Array
        {
            var values:Array = [this._comparison.selected,
                this._valueEnabled.selected ? this._referenceSection.option + 1 : 0];
            Util.pushIntAsLong(values, this._referenceSection.numberValue);
            values.push(this._referenceSection.target);
            return values;
        }

        override public function readVariableIdsFromForm():Array
        {
            return [this._picker.finalizeSelection, this._referenceSection.finalizeSelection];
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var values:Array = definition.intData;
            var variableIds:Array = definition.variableIds;
            var targetVariableId:String = variableIds != null && variableIds.length > 0
                ? String(variableIds[0]) : null;
            var referenceVariableId:String = variableIds != null && variableIds.length > 1
                ? String(variableIds[1]) : null;
            var comparison:int = values.length > 0 ? int(values[0]) : 1;
            var valueFilterMode:int = values.length > 1 ? int(values[1]) : 0;
            // index 2 is the signed-long high word. The NumberInput stores index 3.
            var valueInt:int = values.length > 3 ? int(values[3]) : 0;
            var referenceScope:int = values.length > 4 ? int(values[4]) : 0;

            this._picker.init(definition.wiredContext.roomVariablesList, targetVariableId, this.variableSource);
            this._comparison.selected = comparison;

            if (valueFilterMode == 0 || this._picker.selected == null || !this._picker.selected.hasValue)
            {
                referenceVariableId = null;
                valueInt = 0;
                valueFilterMode = 0;
                this._valueEnabled.selected = false;
            }
            else if (valueFilterMode == 1)
            {
                referenceVariableId = null;
                this._valueEnabled.selected = true;
            }
            else
            {
                valueInt = 0;
                this._valueEnabled.selected = true;
            }

            this._referenceSection.init(definition.wiredContext.roomVariablesList,
                referenceVariableId, referenceScope, valueFilterMode - 1, valueInt);
            this.setValueSelectionVisibility(this._picker.selected != null && this._picker.selected.hasValue
                && valueFilterMode > 0);
            this.onVariableSelected(this._picker.selected);
        }

        override public function onEditInitialized():void
        {
            // Source slot 0 owns the reference variable's furni/user scope.
            this._referenceSection.onEditInitialized();
        }

        override public function isInputSourceDisabled(sourceType:int, index:int):Boolean
        {
            return index == 0 && sourceType == WiredInputSourcePicker.MERGED_SOURCE
                && (this._valueEnabledSection.disabled || !this._valueEnabled.selected
                    || this._referenceSection.isSourcePickingDisabled());
        }

        private function onVariableSelected(value:WiredVariable):void
        {
            var hasValue:Boolean = value != null && value.hasValue;
            this._valueEnabledSection.disabled = !hasValue;
            this.setValueSelectionVisibility(hasValue && this._valueEnabled.selected);
        }

        private function setValueSelectionVisibility(visible:Boolean):void
        {
            this._comparisonSection.disabled = !visible;
            this._referenceSection.disabled = !visible;
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 0);
        }

        private function onSelectByValueChange(id:int, selected:Boolean):void
        {
            this.setValueSelectionVisibility(selected);
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._picker = manager.createVariablePicker(this.variableSelectionFilter, this.onVariableSelected);
            this._variableSection = manager.createSection(this.l("variables.variable_selection"), this._picker);

            var valueToggle:CheckboxGroupPreset = manager.createCheckboxGroup([
                new CheckboxOptionParam(this.l("variables.value_settings.select_by_value"))
            ], this.onSelectByValueChange);
            this._valueEnabled = valueToggle.get(0);
            this._valueEnabledSection = manager.createSection(this.l("choose_type"), this._valueEnabled);

            this._comparison = manager.createRadioGroup([
                new RadioButtonParam(2, ">"),
                new RadioButtonParam(5, "≥"),
                new RadioButtonParam(1, "="),
                new RadioButtonParam(3, "≤"),
                new RadioButtonParam(0, "<"),
                new RadioButtonParam(4, "≠")
            ], null, 6);
            this._comparisonSection = manager.createSection(this.l("comparison_selection"), this._comparison);
            this._referenceSection = manager.createValueOrVariableSection(0, this.mergedSourceOptions(0),
                this.l("variables.reference_value"), -2147483648, 2147483647);
            builder.addElements(this._variableSection, this._valueEnabledSection,
                this._comparisonSection, this._referenceSection);
        }

        override public function mergedSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }

        override public function mergedSelections():Array { return [[0, 0]]; }
        override public function setMergedType(index:int, value:int):void { this._referenceSection.target = value; }
        override public function getMergedType(index:int):int { return this._referenceSection.target; }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
