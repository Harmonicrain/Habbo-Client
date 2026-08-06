package com.sulake.habbo.roomevents.wired_setup.variables
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July variable code 0: value flag first, then availability. */
    public class FurniVariableElement extends VariableElement
    {
        private var _variableName:VariableNameSection;
        private var _availability:RadioGroupPreset;
        private var _settings:CheckboxGroupPreset;

        override public function get code():int { return VariableCodes.FURNI_VARIABLE; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.VARIABLES; }
        override public function get inputMode():int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function readIntParamsFromForm():Array
        {
            return [
                this._settings.get(0).selected ? 1 : 0,
                this._availability.selected
            ];
        }

        override public function onEditStart(k:Triggerable):void
        {
            super.onEditStart(k);
            var hasValue:Boolean = k != null && k.intData != null &&
                k.intData.length > 0 && int(k.intData[0]) != 0;
            var availability:int = VariableAvailabilityTypes.WHILE_ROOM_ACTIVE;
            if (k != null && k.intData != null && k.intData.length > 1)
            {
                var candidate:int = int(k.intData[1]);
                if (candidate == VariableAvailabilityTypes.WHILE_ROOM_ACTIVE ||
                    candidate == VariableAvailabilityTypes.PERMANENT)
                {
                    availability = candidate;
                }
            }
            this._settings.get(0).selected = hasValue;
            this._availability.selected = availability;
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
            this._availability = k.createRadioGroup([
                new RadioButtonParam(VariableAvailabilityTypes.WHILE_ROOM_ACTIVE,
                    l("variables.availability.1")),
                new RadioButtonParam(VariableAvailabilityTypes.PERMANENT,
                    l("variables.availability.10"))
            ]);
            var availabilitySection:SectionPreset = k.createSection(
                l("variables.availability"), this._availability);
            builder.addElements(this._variableName, settingsSection, availabilitySection);
        }

        override public function variableType():int { return VariableTargets.FURNI; }
        override protected function get variableNameSection():VariableNameSection
        {
            return this._variableName;
        }
    }
}
