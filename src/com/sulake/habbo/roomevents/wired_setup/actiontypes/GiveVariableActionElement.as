package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxOptionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR action 39: create a variable, optionally overriding its value. */
    public class GiveVariableActionElement extends DefaultElement
    {
        private var _picker:VariablePickerPreset;
        private var _overrideExisting:CheckboxOptionPreset;
        private var _initialValue:NamedNumberInputPreset;
        private var _selectionSection:SectionPreset;
        private var _valueSection:SectionPreset;
        private var _target:int = 0;

        override public function get code():int { return ActionTypeCodes.GIVE_VARIABLE; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && value.canCreateAndDelete;
        }

        override public function readIntParamsFromForm():Array
        {
            var values:Array = [this._target];
            Util.pushIntAsLong(values, this._initialValue.value);
            values.push(this._overrideExisting.selected ? 1 : 0);
            return values;
        }

        override public function readVariableIdsFromForm():Array
        {
            return [this._picker.finalizeSelection];
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var variableId:String = definition.variableIds.length > 0 ? String(definition.variableIds[0]) : null;
            var values:Array = definition.intData;
            this._target = values.length > 0 ? int(values[0]) : 0;
            var initialValue:int = values.length > 2 ? int(values[2]) : 0;
            var overrideExisting:Boolean = values.length > 3 && int(values[3]) != 0;
            this._picker.init(definition.wiredContext.roomVariablesList, variableId, this._target);
            var selected:WiredVariable = this._picker.selected;
            if (selected == null || !selected.canWriteValue)
            {
                initialValue = 0;
            }
            this.onVariableSelected(selected);
            this._overrideExisting.selected = overrideExisting;
            this._initialValue.value = initialValue;
        }

        override public function onEditInitialized():void
        {
            this._selectionSection.getSourceTypeSelector().select(this._target);
        }

        private function onVariableSelected(value:WiredVariable):void
        {
            this._valueSection.disabled = value == null || !value.hasValue;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            var selector:SourceTypeSelectorParam = new SourceTypeSelectorParam(
                this.mergedSourceOptions(0), this.createSourceTypeListener(0));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter, this.onVariableSelected);
            this._overrideExisting = manager.createCheckboxOption(
                new CheckboxOptionParam(this.l("variables.value_settings.override_existing")));
            var list:SimpleListViewPreset = manager.createSimpleListView(true,
                [this._picker, this._overrideExisting]);
            this._selectionSection = manager.createSection(this.l("variables.variable_selection"), list,
                new SectionParam(selector));
            this._initialValue = manager.createNamedNumberInput(
                new NumberInputParam(0, -2147483648, 2147483647),
                this.l("variables.value_settings.initial_value"));
            this._valueSection = manager.createSection(this.l("variables.value_settings"), this._initialValue);
            builder.addElements(this._selectionSection, this._valueSection);
        }

        override public function mergedSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_destination";
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
            return [VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
