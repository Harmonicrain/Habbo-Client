package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR action 41: mutate a numeric variable using a selected operation. */
    public class ChangeVariableActionElement extends DefaultElement
    {
        private var _picker:VariablePickerPreset;
        private var _operator:DropdownPreset;
        private var _selectionSection:SectionPreset;
        private var _operationSection:SectionPreset;
        private var _operandSection:ValueOrVariableSection;
        private var _target:int = 0;

        override public function get code():int { return ActionTypeCodes.CHANGE_VARIABLE; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        private function operatorOptions():Vector.<ExpandableDropdownOption>
        {
            var options:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();
            var id:int;
            for (id = 0; id < 7; id++)
            {
                options.push(new ExpandableDropdownOption(id,
                    this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation." + id), false));
            }
            options.push(new ExpandableDropdownOption(40,
                this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation.40"), true));
            options.push(new ExpandableDropdownOption(41,
                this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation.41"), true));
            options.push(new ExpandableDropdownOption(50,
                this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation.50"), true));
            options.push(new ExpandableDropdownOption(60,
                this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation.60"), true));
            for (id = 100; id < 106; id++)
            {
                options.push(new ExpandableDropdownOption(id,
                    this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation." + id), true));
            }
            for (id = 110; id < 119; id++)
            {
                options.push(new ExpandableDropdownOption(id,
                    this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation." + id), true));
            }
            return options;
        }

        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && value.canWriteValue;
        }

        private function requiresOperand():Boolean
        {
            return this._operator.selectedId != 103 && this._operator.selectedId != 60 &&
                this._operator.selectedId != 110;
        }

        override public function readIntParamsFromForm():Array
        {
            var values:Array = [this._target, this._operator.selectedId,
                this.requiresOperand() ? this._operandSection.option : 0];
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
            var operandVariableId:String = definition.variableIds.length > 1 ? String(definition.variableIds[1]) : null;
            this._target = values.length > 0 ? int(values[0]) : 0;
            var operation:int = values.length > 1 ? int(values[1]) : 0;
            var operandOption:int = values.length > 2 ? int(values[2]) : 0;
            var operandValue:int = values.length > 4 ? int(values[4]) : 0;
            var operandTarget:int = values.length > 5 ? int(values[5]) : 0;
            this._picker.init(definition.wiredContext.roomVariablesList, variableId, this._target);
            if (operandOption == 0)
            {
                operandVariableId = null;
            }
            else
            {
                operandValue = 0;
            }
            this._operandSection.init(definition.wiredContext.roomVariablesList, operandVariableId,
                operandTarget, operandOption, operandValue);
            this._operator.selectedId = operation;
        }

        override public function onEditInitialized():void
        {
            this._selectionSection.getSourceTypeSelector().select(this._target);
            this._operandSection.onEditInitialized();
        }

        private function onChangeOperator(value:ExpandableDropdownOption):void
        {
            this._operandSection.disabled = !this.requiresOperand();
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 1);
        }

        override public function isInputSourceDisabled(sourceType:int, index:int):Boolean
        {
            return index == 1 && sourceType == WiredInputSourcePicker.MERGED_SOURCE &&
                (this._operandSection.isSourcePickingDisabled() || !this.requiresOperand());
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            var selector:SourceTypeSelectorParam = new SourceTypeSelectorParam(
                this.mergedSourceOptions(0), this.createSourceTypeListener(0));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter);
            this._selectionSection = manager.createSection(this.l("variables.variable_selection"), this._picker,
                new SectionParam(selector));
            this._operator = manager.createDropdown(new DropdownParam(this.l("variables.operation.tooltip"),
                this.operatorOptions(), this.onChangeOperator, this.l("variables.operation.advanced")));
            this._operationSection = manager.createSection(this.l("variables.operation"), this._operator);
            this._operandSection = manager.createValueOrVariableSection(1, this.mergedSourceOptions(1),
                this.l("variables.reference_value"), -2147483648, 2147483647);
            builder.addElements(this._selectionSection, this._operationSection, this._operandSection);
        }

        override public function mergedSelectionTitle(index:int):String
        {
            return index == 0
                ? "wiredfurni.params.sources.merged.title.variables_destination"
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
