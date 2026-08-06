package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SourceTypeSelectorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR value-or-variable editor used by Change Variable (action 41). */
    public class ValueOrVariableSection extends AbstractSectionPreset implements ISourceTypeListener
    {
        private var _optionGroup:RadioGroupPreset;
        private var _numberInput:NumberInputPreset;
        private var _picker:VariablePickerPreset;
        private var _sourceSelector:SourceTypeSelectorPreset;
        private var _mergedSelectionId:int;
        private var _target:int;

        public function ValueOrVariableSection(roomEvents:HabboUserDefinedRoomEvents,
                                               manager:PresetManager,
                                               style:WiredStyle,
                                               mergedSelectionId:int,
                                               sourceOptions:Array,
                                               title:String,
                                               minimum:int,
                                               maximum:int)
        {
            super(roomEvents, manager, style);
            this._mergedSelectionId = mergedSelectionId;
            this._numberInput = manager.createNumberInput(
                new NumberInputParam(0, minimum, maximum, 45, 0, false, true));
            this._sourceSelector = manager.createSourceTypeSelector(
                new SourceTypeSelectorParam(sourceOptions, this));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter);
            this._optionGroup = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("variables.reference_value.set_value"), this._numberInput),
                new RadioButtonParam(1, this.l("variables.reference_value.from_variable"),
                    this._sourceSelector.alignRight(), this._picker)
            ], this.onChangeRadioOption);
            this.initializeSection(title, this._optionGroup);
        }

        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && value.hasValue;
        }

        public function init(variables:AllVariablesInRoom, variableId:String,
                             target:int, option:int, value:int):void
        {
            this._picker.init(variables, variableId, target);
            this._target = target;
            this._optionGroup.selected = option;
            this._numberInput.value = value;
        }

        public function onEditInitialized():void
        {
            this._sourceSelector.select(this._target);
        }

        public function set target(value:int):void
        {
            this._target = value;
            this._picker.variableTarget = value;
        }

        public function get target():int { return this._target; }
        public function get option():int { return this._optionGroup.selected; }
        public function get numberValue():int { return this._numberInput.value; }
        public function get finalizeSelection():String { return this._picker.finalizeSelection; }

        private function onChangeRadioOption(value:int):void
        {
            this._roomEvents.wiredCtrl.updateSourceContainer(
                WiredInputSourcePicker.MERGED_SOURCE, this._mergedSelectionId);
        }

        public function isSourcePickingDisabled():Boolean
        {
            return this._optionGroup.selected == 0;
        }

        public function set sourceType(value:int):void
        {
            this._roomEvents.wiredCtrl.setMergedSourceType(this._mergedSelectionId, value);
        }

        override public function dispose():void
        {
            if (disposed) { return; }
            super.dispose();
            this._optionGroup = null;
            this._numberInput = null;
            this._picker = null;
            this._sourceSelector = null;
        }
    }
}
