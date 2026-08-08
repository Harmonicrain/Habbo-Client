package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR conditions 40/41: selected variable exists/does not exist. */
    public class HasVariableConditionElement extends DefaultElement
    {
        private var _picker:VariablePickerPreset;
        private var _selectionSection:SectionPreset;
        private var _target:int = 0;

        override public function get code():int { return ConditionCodes.HAS_VARIABLE; }
        override public function get negativeCode():int { return ConditionCodes.NOT_HAS_VARIABLE; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && !value.alwaysAvailable;
        }

        override public function readIntParamsFromForm():Array { return [this._target]; }
        override public function readVariableIdsFromForm():Array { return [this._picker.finalizeSelection]; }

        override public function onEditStart(definition:Triggerable):void
        {
            var variableId:String = definition.variableIds.length > 0 ? String(definition.variableIds[0]) : null;
            this._target = definition.intData.length > 0 ? int(definition.intData[0]) : 0;
            this._picker.init(definition.wiredContext.roomVariablesList, variableId, this._target);
        }

        override public function onEditInitialized():void
        {
            this._selectionSection.getSourceTypeSelector().select(this._target);
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            var selector:SourceTypeSelectorParam = new SourceTypeSelectorParam(
                this.mergedSourceOptions(0), this.createSourceTypeListener(0));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter);
            this._selectionSection = manager.createSection(this.l("variables.variable_selection"), this._picker,
                new SectionParam(selector));
            builder.addElements(this._selectionSection);
        }

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
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
