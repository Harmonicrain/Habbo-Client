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
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariablePlaceholderModeSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 16: capture a textual/numeric phrase input into a context variable. */
    public class VariableCapturerAddonElement extends DefaultElement
    {
        private var _name:PlaceholderNameSection;
        private var _variable:ChooseVariableSection;
        private var _inputMode:VariablePlaceholderModeSection;
        private var _lastVariable:WiredVariable;

        override public function get code():int { return AddonCodes.VARIABLE_CAPTURER; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && value.hasValue && value.canCreateAndDelete && value.canWriteValue;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._name = manager.createPlaceholderNameSection(this.l("texts.capturer_name"), "#");
            this._variable = manager.createChooseVariableSection(-1, null,
                this.variableSelectionFilter, this.onChangeVariable);
            this._inputMode = manager.createVariablePlaceholderModeSection(this.l("texts.variable_input_type"));
            builder.addElements(this._name, this._variable, this._inputMode);
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var variableId:String = definition.variableIds.length > 0 ? String(definition.variableIds[0]) : null;
            this._name.placeholderName = definition.stringData.split("\t")[0];
            this._inputMode.isTextMode = definition.intData.length > 0 && int(definition.intData[0]) == 1;
            this._variable.init(definition.wiredContext.roomVariablesList, variableId,
                VariableExtraSourceTypes.CONTEXT_SOURCE);
            this._lastVariable = this._variable.selected;
            this.onChangeVariable(this._lastVariable);
        }

        override public function onEditInitialized():void { this._variable.onEditInitialized(); }
        override public function readIntParamsFromForm():Array { return [this._inputMode.isTextMode ? 1 : 0]; }
        override public function readStringParamFromForm():String { return this._name.placeholderName; }
        override public function readVariableIdsFromForm():Array { return [this._variable.finalizeSelection]; }

        private function onChangeVariable(value:WiredVariable):void
        {
            var textUnavailable:Boolean = value == null || !value.hasTextConnector;
            this._inputMode.get(1).disabled = textUnavailable;
            if (textUnavailable) { this._inputMode.isTextMode = false; }
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
    }
}
