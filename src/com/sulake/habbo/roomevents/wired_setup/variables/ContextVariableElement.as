package com.sulake.habbo.roomevents.wired_setup.variables
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July variable code 3: one has-value flag and no availability section. */
    public class ContextVariableElement extends VariableElement
    {
        private var _variableName:VariableNameSection;
        private var _settings:CheckboxGroupPreset;

        override public function get code():int { return VariableCodes.CONTEXT_VARIABLE; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.VARIABLES; }
        override public function get inputMode():int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function readIntParamsFromForm():Array
        {
            return [this._settings.get(0).selected ? 1 : 0];
        }

        override public function onEditStart(k:Triggerable):void
        {
            super.onEditStart(k);
            this._settings.get(0).selected = k != null && k.intData != null &&
                k.intData.length > 0 && int(k.intData[0]) != 0;
            this.initialVariableName = k != null ? k.stringData : "";
        }

        override public function readStringParamFromForm():String
        {
            return this._variableName.variableName;
        }

        override public function buildInputs(k:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._variableName = k.createVariableNameSection();
            this._settings = k.createCheckboxGroup([
                new CheckboxOptionParam(l("variables.settings.has_value"))
            ]);
            var settingsSection:SectionPreset = k.createSection(
                l("variables.settings"), this._settings);
            builder.addElements(this._variableName, settingsSection);
        }

        override public function variableType():int { return VariableTargets.CONTEXT; }
        override protected function get variableNameSection():VariableNameSection
        {
            return this._variableName;
        }
    }
}
