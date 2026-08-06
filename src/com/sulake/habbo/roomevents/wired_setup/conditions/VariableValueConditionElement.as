package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR condition 42: compare a variable value with a literal or variable. */
    public class VariableValueConditionElement extends DefaultElement
    {
        private var _picker:VariablePickerPreset;
        private var _comparison:RadioGroupPreset;
        private var _selectionSection:SectionPreset;
        private var _operandSection:ValueOrVariableSection;
        private var _target:int = 0;

        override public function get code():int { return ConditionCodes.VARIABLE_VALUE; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && value.hasValue;
        }

        override public function readIntParamsFromForm():Array
        {
            var values:Array = [this._target, this._comparison.selected, this._operandSection.option];
            Util.pushIntAsLong(values, this._operandSection.numberValue);
            values.push(this._operandSection.target);
            return values;
        }

        override public function readVariableIdsFromForm():Array
        {
            return [this._picker.finalizeSelection, this._operandSection.finalizeSelection];
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var values:Array = definition.intData;
            var variableId:String = definition.variableIds.length > 0 ? String(definition.variableIds[0]) : null;
            var referenceVariableId:String = definition.variableIds.length > 1 ? String(definition.variableIds[1]) : null;
            this._target = values.length > 0 ? int(values[0]) : 0;
            var comparison:int = values.length > 1 ? int(values[1]) : 0;
            var referenceMode:int = values.length > 2 ? int(values[2]) : 0;
            var referenceValue:int = values.length > 4 ? int(values[4]) : 0;
            var referenceTarget:int = values.length > 5 ? int(values[5]) : 0;
            this._picker.init(definition.wiredContext.roomVariablesList, variableId, this._target);
            if (referenceMode == 0)
            {
                referenceVariableId = WiredVariable.NONE_ID;
            }
            else
            {
                referenceValue = 0;
            }
            this._comparison.selected = comparison;
            this._operandSection.init(definition.wiredContext.roomVariablesList, referenceVariableId,
                referenceTarget, referenceMode, referenceValue);
        }

        override public function onEditInitialized():void
        {
            this._selectionSection.getSourceTypeSelector().select(this._target);
            this._operandSection.onEditInitialized();
        }

        override public function isInputSourceDisabled(sourceType:int, index:int):Boolean
        {
            return sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 1 &&
                this._operandSection.isSourcePickingDisabled();
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            var selector:SourceTypeSelectorParam = new SourceTypeSelectorParam(
                this.mergedSourceOptions(0), this.createSourceTypeListener(0));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter);
            this._selectionSection = manager.createSection(this.l("variables.variable_selection"), this._picker,
                new SectionParam(selector));
            this._comparison = manager.createRadioGroup([
                new RadioButtonParam(2, ">"), new RadioButtonParam(5, "≥"),
                new RadioButtonParam(1, "="), new RadioButtonParam(3, "≤"),
                new RadioButtonParam(0, "<"), new RadioButtonParam(4, "≠")
            ], null, 6);
            this._operandSection = manager.createValueOrVariableSection(1, this.mergedSourceOptions(1),
                this.l("variables.reference_value"), -2147483648, 2147483647);
            builder.addElements(this._selectionSection,
                manager.createSection(this.l("comparison_selection"), this._comparison), this._operandSection);
        }

        override public function mergedSelectionTitle(index:int):String
        {
            return index == 0
                ? "wiredfurni.params.sources.merged.title.variables"
                : "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function mergedSelections():Array { return [[0, 0], [1, 1]]; }
        override public function setMergedType(index:int, value:int):void
        {
            if (index == 0)
            {
                this._target = value;
                this._picker.variableTarget = value;
            }
            else
            {
                this._operandSection.target = value;
            }
        }
        override public function getMergedType(index:int):int
        {
            return index == 0 ? this._target : this._operandSection.target;
        }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
