package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ChooseVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.PlaceholderNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.PlaceholderTypeSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariablePlaceholderModeSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 15: variable placeholder definition. */
    public class VariablePlaceholderAddonElement extends DefaultElement
    {
        private var _name:PlaceholderNameSection;
        private var _variable:ChooseVariableSection;
        private var _displayMode:VariablePlaceholderModeSection;
        private var _type:PlaceholderTypeSection;
        private var _lastVariable:WiredVariable;

        override public function get code():int { return AddonCodes.VARIABLE_PLACEHOLDER; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && value.hasValue;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._name = manager.createPlaceholderNameSection(this.l("texts.placeholder_name"), "$");
            this._variable = manager.createChooseVariableSection(0, this.mergedSourceOptions(0),
                this.variableSelectionFilter, this.onChangeVariable);
            this._displayMode = manager.createVariablePlaceholderModeSection(this.l("texts.variable_display_type"));
            this._type = manager.createPlaceholderTypeSection();
            builder.addElements(this._name, this._variable, this._displayMode, this._type);
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var text:Array = definition.stringData.split("\t");
            var variableId:String = definition.variableIds.length > 0 ? String(definition.variableIds[0]) : null;
            var target:int = definition.intData.length > 1 ? int(definition.intData[1]) : 0;
            this._name.placeholderName = text.length > 0 ? String(text[0]) : "";
            this._type.isShowMultiple = definition.intData.length > 0 && int(definition.intData[0]) == 1;
            this._type.delimiter = text.length > 1 ? String(text[1]) : "";
            this._displayMode.isTextMode = definition.intData.length > 2 && int(definition.intData[2]) == 1;
            this._variable.init(definition.wiredContext.roomVariablesList, variableId, target);
            this._lastVariable = this._variable.selected;
            this.onChangeVariable(this._lastVariable);
            this.updateMultipleOptionVisibility();
        }

        override public function onEditInitialized():void { this._variable.onEditInitialized(); }
        override public function readIntParamsFromForm():Array
        {
            return [this._type.isShowMultiple ? 1 : 0, this._variable.target,
                this._displayMode.isTextMode ? 1 : 0];
        }
        override public function readStringParamFromForm():String
        {
            return this._type.isShowMultiple
                ? this._name.placeholderName + "\t" + this._type.delimiter : this._name.placeholderName;
        }
        override public function readVariableIdsFromForm():Array { return [this._variable.finalizeSelection]; }

        private function onChangeVariable(value:WiredVariable):void
        {
            var textUnavailable:Boolean = value == null || !value.hasTextConnector;
            this._displayMode.get(1).disabled = textUnavailable;
            if (textUnavailable) { this._displayMode.isTextMode = false; }
            if (this._name.placeholderName == "" || (this._lastVariable != null &&
                this.prettifiedName(this._lastVariable) == this._name.placeholderName))
            {
                this._name.placeholderName = this.prettifiedName(value);
            }
            this._lastVariable = value;
        }

        private function prettifiedName(value:WiredVariable):String
        {
            return value == null ? "" : value.variableName.replace("@", "").replace("~", "").replace(/\./g, "_");
        }

        private function updateMultipleOptionVisibility():void
        {
            var customTarget:Boolean = this._variable.target == VariableExtraSourceTypes.CONTEXT_SOURCE ||
                this._variable.target == VariableExtraSourceTypes.GLOBAL_SOURCE;
            this._type.get(1).disabled = customTarget;
            if (customTarget) { this._type.isShowMultiple = false; }
        }

        override public function mergedSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.merged.title.variables";
        }
        override public function mergedSelections():Array { return [[0, 0]]; }
        override public function setMergedType(index:int, value:int):void
        {
            this._variable.target = value;
            this.updateMultipleOptionVisibility();
        }
        override public function getMergedType(index:int):int { return this._variable.target; }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
