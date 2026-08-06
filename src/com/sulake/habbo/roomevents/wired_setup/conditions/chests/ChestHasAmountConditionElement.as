package com.sulake.habbo.roomevents.wired_setup.conditions.chests
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July condition 45: compare chest content amount to a literal or variable. */
    public class ChestHasAmountConditionElement extends DefaultElement
    {
        protected var amount:ValueOrVariableSection;
        private var _comparison:RadioGroupPreset;

        override public function get code():int { return ConditionCodes.CHEST_HAS_ITEMS; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.CHESTS | WiredCapabilityCodes.CHEST_WIRED |
                WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }
        override public function readIntParamsFromForm():Array
        {
            return [this.amount.numberValue, this.amount.option, this.amount.target,
                this._comparison.selected];
        }
        override public function readVariableIdsFromForm():Array
        {
            return [this.amount.finalizeSelection];
        }
        override public function onEditStart(definition:Triggerable):void
        {
            var values:Array = definition.intData;
            var variableId:String = definition.variableIds.length > 0 ?
                String(definition.variableIds[0]) : WiredVariable.NONE_ID;
            var value:int = values.length > 0 ? int(values[0]) : 0;
            var option:int = values.length > 1 ? int(values[1]) : 0;
            var target:int = values.length > 2 ? int(values[2]) : 0;
            if (option == 0) variableId = WiredVariable.NONE_ID;
            else value = 1;
            this.amount.init(definition.wiredContext.roomVariablesList, variableId,
                target, option, value);
            this._comparison.selected = values.length > 3 ? int(values[3]) : 1;
        }
        override public function onEditInitialized():void { this.amount.onEditInitialized(); }
        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._comparison = manager.createRadioGroup([
                new RadioButtonParam(2, ">"), new RadioButtonParam(5, "≥"),
                new RadioButtonParam(1, "="), new RadioButtonParam(3, "≤"),
                new RadioButtonParam(0, "<"), new RadioButtonParam(4, "≠")
            ], null, 6);
            this.amount = manager.createValueOrVariableSection(0, this.mergedSourceOptions(0),
                this.l("chest_compare_amount"), 0, 1000000);
            builder.addElements(
                manager.createSection(this.l("comparison_selection"), this._comparison),
                this.amount);
        }
        override public function isInputSourceDisabled(index:int, sourceType:int):Boolean
        {
            return sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 0 &&
                this.amount.isSourcePickingDisabled();
        }
        override public function mergedSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function furniSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.furni.title.chests";
        }
        override public function mergedSelections():Array { return [[1, 0]]; }
        override public function setMergedType(index:int, value:int):void { this.amount.target = value; }
        override public function getMergedType(index:int):int { return this.amount.target; }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
