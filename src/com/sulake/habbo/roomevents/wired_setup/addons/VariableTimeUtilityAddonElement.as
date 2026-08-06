package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.VariableList;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.applications.SubVariableParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.SubVariableCreatorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Exact July add-on 1002 editor and payload. */
    public class VariableTimeUtilityAddonElement extends DefaultElement
    {
        private static const SOURCE_VALUE:int = 0;
        private static const SOURCE_CREATION_TIME:int = 1;
        private static const SOURCE_LAST_UPDATE_TIME:int = 2;

        private var _mode:DropdownPreset;
        private var _standard:SubVariableCreatorPreset;
        private var _advanced:SubVariableCreatorPreset;

        override public function get code():int { return AddonCodes.VARIABLE_TIME_UTIL; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._mode = manager.createDropdown(new DropdownParam(this.l("choose_type"),
                Vector.<ExpandableDropdownOption>([
                    new ExpandableDropdownOption(SOURCE_VALUE, this.l("time_util.mode.0")),
                    new ExpandableDropdownOption(SOURCE_CREATION_TIME, this.l("time_util.mode.1")),
                    new ExpandableDropdownOption(SOURCE_LAST_UPDATE_TIME, this.l("time_util.mode.2"))
                ])));

            this._standard = manager.createSubVariableCreator(
                "wiredfurni.params.time_util.subvariable.", [
                    new SubVariableParam(1, "milliseconds_of_seconds"),
                    new SubVariableParam(2, "seconds_of_minute"),
                    new SubVariableParam(3, "minute_of_hour"),
                    new SubVariableParam(4, "hour_of_day"),
                    new SubVariableParam(5, "day_of_week"),
                    new SubVariableParam(6, "day_of_month"),
                    new SubVariableParam(7, "day_of_year"),
                    new SubVariableParam(8, "week_of_year"),
                    new SubVariableParam(9, "month_of_year"),
                    new SubVariableParam(10, "year")
                ]);
            this._advanced = manager.createSubVariableCreator(
                "wiredfurni.params.time_util.subvariable.", [
                    new SubVariableParam(20, "millisecond"),
                    new SubVariableParam(21, "second"),
                    new SubVariableParam(22, "minute"),
                    new SubVariableParam(23, "hour"),
                    new SubVariableParam(24, "day"),
                    new SubVariableParam(25, "week"),
                    new SubVariableParam(26, "month")
                ]);

            builder.addElements(
                manager.createSection(this.l("choose_type"), this._mode),
                manager.createSection(this.loc("wiredfurni.params.create_subvariables"),
                    this._standard, SectionParam.EXPANDED_WITH_TOGGLE),
                manager.createSection(this.l("create_subvariables.advanced"),
                    manager.createSimpleListView(true, [
                        manager.createText(this.l("time_util.advanced_info")), this._advanced
                    ]), SectionParam.COLLAPSED));
        }

        override public function onEditStart(data:Triggerable):void
        {
            var mask:int = data.intData.length > 0 ? int(data.intData[0]) : 0;
            var selectedMode:int = data.intData.length > 1 ? int(data.intData[1]) : SOURCE_VALUE;
            this._standard.mask = mask & 0xFFFF;
            this._advanced.mask = mask & 0xFFFF0000;

            var variables:Array = data.wiredContext != null &&
                data.wiredContext.rulesetVariables != null
                ? data.wiredContext.rulesetVariables.variables : [];
            var options:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();
            if (this.showValue(variables, selectedMode))
                options.push(new ExpandableDropdownOption(SOURCE_VALUE, this.l("time_util.mode.0")));
            if (this.showCreationTime(variables, selectedMode))
                options.push(new ExpandableDropdownOption(SOURCE_CREATION_TIME, this.l("time_util.mode.1")));
            if (this.showLastUpdateTime(variables, selectedMode))
                options.push(new ExpandableDropdownOption(SOURCE_LAST_UPDATE_TIME, this.l("time_util.mode.2")));
            this._mode.reinit(options, selectedMode);
        }

        private function showValue(variables:Array, selectedMode:int):Boolean
        {
            if (selectedMode == SOURCE_VALUE || variables.length == 0) return true;
            for each (var variable:WiredVariable in variables) if (variable.hasValue) return true;
            return false;
        }

        private function showCreationTime(variables:Array, selectedMode:int):Boolean
        {
            if (selectedMode == SOURCE_CREATION_TIME || variables.length == 0) return true;
            for each (var variable:WiredVariable in variables)
                if (variable.canReadCreationTime) return true;
            return false;
        }

        private function showLastUpdateTime(variables:Array, selectedMode:int):Boolean
        {
            if (selectedMode == SOURCE_LAST_UPDATE_TIME || variables.length == 0) return true;
            for each (var variable:WiredVariable in variables)
                if (variable.canReadLastUpdateTime) return true;
            return false;
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._standard.mask | this._advanced.mask, this._mode.selectedId];
        }
    }
}
