package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SpacingPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR condition 43: compare a variable creation/update timestamp against a duration. */
    public class VariableAgeConditionElement extends DefaultElement
    {
        private var _selectionSection:SectionPreset;
        private var _picker:VariablePickerPreset;
        private var _comparison:RadioGroupPreset;
        private var _timestampKind:RadioGroupPreset;
        private var _duration:NamedNumberInputPreset;
        private var _timeUnit:DropdownPreset;
        private var _target:int = 0;

        override public function get code():int { return ConditionCodes.VARIABLE_AGE; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && (value.canReadCreationTime || value.canReadLastUpdateTime);
        }

        override public function readIntParamsFromForm():Array
        {
            var values:Array = [this._target, this._comparison.selected, this._timestampKind.selected];
            Util.pushIntAsLong(values, this._duration.value);
            values.push(this._timeUnit.selectedId);
            return values;
        }

        override public function readVariableIdsFromForm():Array { return [this._picker.finalizeSelection]; }

        override public function onEditStart(definition:Triggerable):void
        {
            var values:Array = definition.intData;
            var variableId:String = definition.variableIds.length > 0 ? String(definition.variableIds[0]) : null;
            this._target = values.length > 0 ? int(values[0]) : 0;
            var comparison:int = values.length > 1 ? int(values[1]) : 0;
            var timestampKind:int = values.length > 2 ? int(values[2]) : 0;
            var duration:int = values.length > 4 ? int(values[4]) : 0;
            var timeUnit:int = values.length > 5 ? int(values[5]) : 0;
            this._picker.init(definition.wiredContext.roomVariablesList, variableId, this._target);
            this._comparison.selected = comparison;
            this._timestampKind.selected = timestampKind;
            this._duration.value = duration;
            this._timeUnit.selectedId = timeUnit;
            this.updateAgeOptions(this._picker.selected);
        }

        override public function onEditInitialized():void
        {
            this._selectionSection.getSourceTypeSelector().select(this._target);
        }

        private function updateAgeOptions(value:WiredVariable):void
        {
            this._timestampKind.setOptionDisabled(0, false);
            this._timestampKind.setOptionDisabled(1, false);
            if (value == null) { return; }
            if (!value.canReadCreationTime)
            {
                this._timestampKind.setOptionDisabled(0, true);
            }
            else if (!value.canReadLastUpdateTime)
            {
                this._timestampKind.setOptionDisabled(1, true);
            }
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            var selector:SourceTypeSelectorParam = new SourceTypeSelectorParam(
                this.mergedSourceOptions(0), this.createSourceTypeListener(0));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter, this.updateAgeOptions);
            this._selectionSection = manager.createSection(this.l("variables.variable_selection"), this._picker,
                new SectionParam(selector));
            this._timestampKind = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("variables.compare_value.0")),
                new RadioButtonParam(1, this.l("variables.compare_value.1"))
            ]);
            this._comparison = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("comparison.0")),
                new RadioButtonParam(2, this.l("comparison.2"))
            ]);
            this._duration = manager.createNamedNumberInput(
                new NumberInputParam(0, -2147483648, 2147483647), this.l("variables.duration"));
            this._timeUnit = manager.createDropdown(new DropdownParam("",
                Vector.<ExpandableDropdownOption>([
                    new ExpandableDropdownOption(0, this.l("variables.duration.0")),
                    new ExpandableDropdownOption(1, this.l("variables.duration.1")),
                    new ExpandableDropdownOption(2, this.l("variables.duration.2")),
                    new ExpandableDropdownOption(3, this.l("variables.duration.3")),
                    new ExpandableDropdownOption(4, this.l("variables.duration.4")),
                    new ExpandableDropdownOption(5, this.l("variables.duration.5")),
                    new ExpandableDropdownOption(6, this.l("variables.duration.6")),
                    new ExpandableDropdownOption(7, this.l("variables.duration.7"))
                ])));
            var durationList:SimpleListViewPreset = manager.createSimpleListView(false,
                [this._duration, manager.createSpacing(false, 5), this._timeUnit], true);
            builder.addElements(this._selectionSection,
                manager.createSection(this.l("variables.compare_value"), this._timestampKind),
                manager.createSection(this.l("comparison_selection"), this._comparison),
                manager.createSection(this.l("variables.time_selection"), durationList));
        }

        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function mergedSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.merged.title.variables";
        }
        override public function mergedSelections():Array { return [[0, 0]]; }
        override public function setMergedType(index:int, value:int):void
        {
            this._target = value;
            this._picker.variableTarget = value;
        }
        override public function getMergedType(index:int):int { return this._target; }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
