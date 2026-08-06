package com.sulake.habbo.roomevents.wired_setup.variables
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class QuestChainVariableElement extends VariableElement
    {
        private static const SPLITTER:String = "\t";
        private var _variableName:VariableNameSection;
        private var _questChainName:TextInputPreset;

        override public function get code():int { return VariableCodes.QUEST_CHAIN_VARIABLE; }
        override public function get inputMode():int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._variableName = manager.createVariableNameSection();
            this._questChainName = manager.createTextInput(new TextInputParam("", 500));
            builder.addElements(this._variableName, manager.createSection(
                l("variables.quest_chain_name"), this._questChainName));
        }
        override public function onEditStart(data:Triggerable):void
        {
            super.onEditStart(data);
            var parts:Array = data.stringData.split(SPLITTER);
            this.initialVariableName = parts.length > 0 ? String(parts[0]) : "";
            this._questChainName.text = parts.length > 1 ? String(parts[1]) : "";
        }
        override public function readStringParamFromForm():String
        {
            return this._variableName.variableName + SPLITTER + this._questChainName.text;
        }
        override public function variableType():int { return VariableTargets.USER; }
        override protected function get variableNameSection():VariableNameSection
        {
            return this._variableName;
        }
    }
}
