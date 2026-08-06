package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableTypes;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.wired_setup.variables.VariableAvailabilityTypes;

    /** July AIR trigger 22: created/value-changed/deleted variable mutation filter. */
    public class VariableChangedTriggerElement extends DefaultElement implements ISourceTypeListener
    {
        private static const CREATED_INDEX:int = 0;
        private static const VALUE_CHANGED_INDEX:int = 1;
        private static const DELETED_INDEX:int = 2;

        private var _variableSection:SectionPreset;
        private var _picker:VariablePickerPreset;
        private var _optionGroup:CheckboxGroupPreset;
        private var _changeDirectionGroup:CheckboxGroupPreset;

        override public function get code():int { return WiredTriggerType.VARIABLE_CHANGED; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        private static function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && value.canInterceptChanges;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle, builder:WiredUIBuilder):void
        {
            var targetSelector:SourceTypeSelectorParam = new SourceTypeSelectorParam([
                WiredInputSourcePicker.FURNI_SOURCE,
                WiredInputSourcePicker.USER_SOURCE,
                VariableExtraSourceTypes.GLOBAL_SOURCE
            ], this);
            this._picker = manager.createVariablePicker(variableSelectionFilter, this.onChangeVariable);
            this._variableSection = manager.createSection(
                this.loc("wiredfurni.params.variables.variable_selection"),
                this._picker,
                new SectionParam(targetSelector));

            this._changeDirectionGroup = manager.createCheckboxGroup([
                new CheckboxOptionParam(this.l("variables.trigger_options.1.0"), 0),
                new CheckboxOptionParam(this.l("variables.trigger_options.1.1"), 1),
                new CheckboxOptionParam(this.l("variables.trigger_options.1.2"), 2)
            ]);
            var valueChanged:CheckboxOptionParam = new CheckboxOptionParam(
                this.l("variables.trigger_options.1"), VALUE_CHANGED_INDEX);
            valueChanged.extra2 = this._changeDirectionGroup;
            this._optionGroup = manager.createCheckboxGroup([
                new CheckboxOptionParam(this.l("variables.trigger_options.0"), CREATED_INDEX),
                valueChanged,
                new CheckboxOptionParam(this.l("variables.trigger_options.2"), DELETED_INDEX)
            ]);
            builder.addElements(this._variableSection,
                manager.createSection(this.l("variables.trigger_options"), this._optionGroup));
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var selectedId:String = definition.variableIds.length > 0 ? String(definition.variableIds[0]) : null;
            var target:int = WiredInputSourcePicker.USER_SOURCE;
            var variables:AllVariablesInRoom = definition.wiredContext == null
                ? null : definition.wiredContext.roomVariablesList;
            var selected:WiredVariable = findVariableById(variables, selectedId);
            if (selected != null) { target = selected.variableTarget; }
            this._variableSection.getSourceTypeSelector().select(target);
            this._picker.init(variables, selectedId, target);
            this.onChangeVariable(this._picker.selected);
            this._optionGroup.get(CREATED_INDEX).selected = definition.getBoolean(0);
            this._optionGroup.get(VALUE_CHANGED_INDEX).selected = definition.getBoolean(1);
            this._optionGroup.get(DELETED_INDEX).selected = definition.getBoolean(2);
            this._changeDirectionGroup.mask = definition.intData.length > 3 ? int(definition.intData[3]) : 0;
        }

        private static function findVariableById(variables:AllVariablesInRoom, id:String):WiredVariable
        {
            if (variables == null || variables.variables == null) { return null; }
            for each (var value:WiredVariable in variables.variables)
            {
                if (value.variableId == id) { return value; }
            }
            return null;
        }

        private function onChangeVariable(value:WiredVariable):void
        {
            var supportsCreateDelete:Boolean = value == null || value.canCreateAndDelete;
            var specialAvailability:Boolean = value != null &&
                (value.variableType == WiredVariableTypes.USER_CREATED_SPECIAL ||
                 value.availabilityType == VariableAvailabilityTypes.SHARED_DYNAMIC);
            var dynamicOrInternal:Boolean = value != null &&
                (value.variableType == WiredVariableTypes.DYNAMIC || value.variableType == WiredVariableTypes.INTERNAL);
            var supportsValue:Boolean = value == null || value.hasValue;
            this._optionGroup.get(CREATED_INDEX).disabled =
                !supportsCreateDelete && !specialAvailability && !dynamicOrInternal;
            this._optionGroup.get(VALUE_CHANGED_INDEX).disabled = !supportsValue && !dynamicOrInternal;
            this._optionGroup.get(DELETED_INDEX).disabled =
                !supportsCreateDelete && !specialAvailability && !dynamicOrInternal;
        }

        public function set sourceType(value:int):void { this._picker.variableTarget = value; }

        override public function readVariableIdsFromForm():Array { return [this._picker.finalizeSelection]; }
        override public function readIntParamsFromForm():Array
        {
            return [
                this._optionGroup.get(CREATED_INDEX).selected ? 1 : 0,
                this._optionGroup.get(VALUE_CHANGED_INDEX).selected ? 1 : 0,
                this._optionGroup.get(DELETED_INDEX).selected ? 1 : 0,
                this._changeDirectionGroup.mask
            ];
        }
    }
}
