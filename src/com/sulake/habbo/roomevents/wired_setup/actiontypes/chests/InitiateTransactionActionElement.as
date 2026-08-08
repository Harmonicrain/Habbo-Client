package com.sulake.habbo.roomevents.wired_setup.actiontypes.chests
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July action 47: initiate a contract transaction. */
    public class InitiateTransactionActionElement extends DefaultElement
    {
        private static const MODE_NO_MULTIPLIER:int = 0;
        private static const MODE_ALTERNATE_LABEL:int = 2;

        private var _mode:RadioGroupPreset;
        private var _multiplier:ValueOrVariableSection;
        private var _timeoutEnabled:CheckboxGroupPreset;
        private var _timeout:NamedNumberInputPreset;

        override public function get code():int { return ActionTypeCodes.INITIATE_TRANSACTION; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.CHESTS | WiredCapabilityCodes.CHEST_WIRED |
                WiredCapabilityCodes.CONTRACTS | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._mode.selected, this._multiplier.numberValue, this._multiplier.option,
                this._multiplier.target, this._timeoutEnabled.get(0).selected ? 1 : 0,
                this._timeout.value];
        }

        override public function readVariableIdsFromForm():Array
        {
            return [this._multiplier.finalizeSelection];
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var values:Array = definition.intData;
            var variableId:String = definition.variableIds.length > 0 ?
                String(definition.variableIds[0]) : WiredVariable.NONE_ID;
            var mode:int = values.length > 0 ? int(values[0]) : 0;
            var amount:int = values.length > 1 ? int(values[1]) : 1;
            var option:int = values.length > 2 ? int(values[2]) : 0;
            var target:int = values.length > 3 ? int(values[3]) : 0;
            if (option == 0) variableId = WiredVariable.NONE_ID;
            else amount = 1;
            this._mode.selected = mode;
            this._multiplier.init(definition.wiredContext.roomVariablesList, variableId,
                target, option, amount);
            this._timeoutEnabled.get(0).selected = values.length > 4 && int(values[4]) != 0;
            this._timeout.value = values.length > 5 ? int(values[5]) : 300;
            this.onModeChange(mode);
        }

        override public function onEditInitialized():void { this._multiplier.onEditInitialized(); }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(0, "${wiredfurni.params.contract.mode.0}"),
                new RadioButtonParam(1, "${wiredfurni.params.contract.mode.1}"),
                new RadioButtonParam(2, "${wiredfurni.params.contract.mode.2}")
            ], this.onModeChange);
            this._multiplier = manager.createValueOrVariableSection(0,
                this.mergedSourceOptions(0), "${wiredfurni.params.contract.multiplier_selection}",
                1, 500);
            this._timeout = manager.createNamedNumberInput(
                new NumberInputParam(300, 30, 3600),
                "${wiredfurni.params.contract.timeout.selection}");
            var timeoutOption:CheckboxOptionParam =
                new CheckboxOptionParam("${wiredfurni.params.contract.timeout.desc}");
            timeoutOption.extra2 = this._timeout;
            this._timeoutEnabled = manager.createCheckboxGroup([timeoutOption]);
            builder.addElements(
                manager.createSection("${wiredfurni.params.contract.mode}", this._mode),
                this._multiplier,
                manager.createSection("${wiredfurni.params.contract.timeout}",
                    this._timeoutEnabled));
        }

        private function onModeChange(value:int):void
        {
            this._multiplier.sectionTitle = value == MODE_ALTERNATE_LABEL
                ? "${wiredfurni.params.contract.multiplier_selection2}"
                : "${wiredfurni.params.contract.multiplier_selection}";
            this._multiplier.disabled = value == MODE_NO_MULTIPLIER;
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 0);
        }

        override public function isInputSourceDisabled(index:int, sourceType:int):Boolean
        {
            return sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 0 &&
                (this._multiplier.disabled || this._multiplier.isSourcePickingDisabled());
        }
        override public function mergedSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function furniSelectionTitle(index:int):String
        {
            return index == 0 ? "wiredfurni.params.sources.furni.title.chests" :
                "wiredfurni.params.sources.furni.title.contracts";
        }
        override public function mergedSelections():Array { return [[2, 1]]; }
        override public function setMergedType(index:int, value:int):void { this._multiplier.target = value; }
        override public function getMergedType(index:int):int { return this._multiplier.target; }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
