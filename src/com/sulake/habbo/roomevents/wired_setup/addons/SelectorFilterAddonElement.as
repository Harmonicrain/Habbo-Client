package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Shared July editor for addons 10 and 11. */
    public class SelectorFilterAddonElement extends DefaultElement
    {
        private var _filterAmount:ValueOrVariableSection;

        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._filterAmount = manager.createValueOrVariableSection(0, this.mergedSourceOptions(0),
                this.l("setfilter"), 1, 1000);
            builder.addElements(this._filterAmount);
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var values:Array = definition.intData;
            var variableId:String = definition.variableIds.length > 0 ? String(definition.variableIds[0]) : null;
            var amount:int = values.length > 0 ? int(values[0]) : 1;
            var option:int = values.length > 1 ? int(values[1]) : 0;
            var target:int = values.length > 2 ? int(values[2]) : 0;
            if (option == 0)
            {
                variableId = WiredVariable.NONE_ID;
            }
            else
            {
                amount = 1;
            }
            this._filterAmount.init(definition.wiredContext.roomVariablesList, variableId,
                target, option, amount);
        }

        override public function onEditInitialized():void { this._filterAmount.onEditInitialized(); }

        override public function readIntParamsFromForm():Array
        {
            return [this._filterAmount.numberValue, this._filterAmount.option,
                this._filterAmount.target];
        }

        override public function readVariableIdsFromForm():Array
        {
            return [this._filterAmount.finalizeSelection];
        }

        override public function isInputSourceDisabled(sourceType:int, index:int):Boolean
        {
            return sourceType == WiredInputSourcePicker.MERGED_SOURCE &&
                this._filterAmount.isSourcePickingDisabled();
        }

        override public function mergedSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function mergedSelections():Array { return [[0, 0]]; }
        override public function setMergedType(index:int, value:int):void { this._filterAmount.target = value; }
        override public function getMergedType(index:int):int { return this._filterAmount.target; }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
