package com.sulake.habbo.roomevents.wired_setup.variables
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableTypes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ChooseVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class EchoVariableElement extends VariableElement
    {
        private var _variableName:VariableNameSection;
        private var _variable:ChooseVariableSection;
        private var _initialVariable:WiredVariable;

        override public function get code():int { return VariableCodes.ECHO_VARIABLE; }
        override public function get inputMode():int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._variableName = manager.createVariableNameSection();
            this._variable = manager.createChooseVariableSection(-1, [
                WiredInputSourcePicker.FURNI_SOURCE,
                WiredInputSourcePicker.USER_SOURCE,
                VariableExtraSourceTypes.GLOBAL_SOURCE,
                VariableExtraSourceTypes.CONTEXT_SOURCE
            ], this.variableSelectionFilter, this.onVariableSelected);
            builder.addElements(this._variableName, this._variable);
        }
        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && value.variableType != WiredVariableTypes.DYNAMIC;
        }
        override public function onEditStart(data:Triggerable):void
        {
            var variableId:String = data.variableIds.length > 0
                ? String(data.variableIds[0]) : WiredVariable.NONE_ID;
            var target:int = WiredInputSourcePicker.USER_SOURCE;
            var selected:WiredVariable = findVariable(data.wiredContext.roomVariablesList.variables,
                variableId);
            if (selected != null) { target = selected.variableTarget; }
            this._variable.init(data.wiredContext.roomVariablesList, variableId, target);
            this._initialVariable = this._variable.selected;
            this.initialVariableName = data.stringData;
        }
        override public function onEditInitialized():void { this._variable.onEditInitialized(); }
        override public function readStringParamFromForm():String
        {
            return this._variableName.variableName;
        }
        override public function readVariableIdsFromForm():Array
        {
            return [this._variable.finalizeSelection];
        }
        private function onVariableSelected(value:WiredVariable):void
        {
            if (this._variableName.variableName.length == 0 ||
                this._initialVariable != null &&
                defaultEchoName(this._initialVariable) == this._variableName.variableName)
            {
                this._variableName.variableName = value == null ? "" : defaultEchoName(value);
            }
            this._initialVariable = value;
        }
        private static function defaultEchoName(value:WiredVariable):String
        {
            return value.variableName.replace("@", "").replace("~", "").replace(/\./g, "_");
        }
        private static function findVariable(variables:Array, id:String):WiredVariable
        {
            for each (var value:WiredVariable in variables)
            {
                if (value.variableId == id) { return value; }
            }
            return null;
        }
        override public function variableType():int { return this._variable.target; }
        override protected function get variableNameSection():VariableNameSection
        {
            return this._variableName;
        }
    }
}
