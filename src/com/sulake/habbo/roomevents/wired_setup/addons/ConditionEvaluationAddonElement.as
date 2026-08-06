package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.UsageInfoSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 0: choose how the wired conditions are evaluated. */
    public class ConditionEvaluationAddonElement extends DefaultElement
    {
        private static const COMPARISON_MODE_START:int = 4;
        private static const COMPARISON_COUNT:int = 3;

        private var _comparisonValues:Vector.<NumberInputPreset>;
        private var _mode:RadioGroupPreset;

        override public function get code():int { return AddonCodes.CONDITION_EVALUATION; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.ADDONS; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            var comparison:int;
            this._comparisonValues = new Vector.<NumberInputPreset>();
            for (comparison = 0; comparison < COMPARISON_COUNT; comparison++)
            {
                this._comparisonValues.push(manager.createNumberInput(
                    new NumberInputParam(0, 0, 1000, 35, 0, false, false)));
            }
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("eval_mode.0")),
                new RadioButtonParam(1, this.l("eval_mode.1")),
                new RadioButtonParam(2, this.l("eval_mode.2")),
                new RadioButtonParam(3, this.l("eval_mode.3")),
                new RadioButtonParam(4, this.l("eval_mode.cmp.0"), this._comparisonValues[0]),
                new RadioButtonParam(5, this.l("eval_mode.cmp.1"), this._comparisonValues[1]),
                new RadioButtonParam(6, this.l("eval_mode.cmp.2"), this._comparisonValues[2])
            ]);
            builder.addElements(manager.createUsageInfoSection(this.l("cond_eval.note")),
                manager.createSection(this.l("eval_mode"), this._mode));
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var index:int;
            for (index = 0; index < COMPARISON_COUNT; index++)
            {
                this._comparisonValues[index].value = 0;
            }
            var mode:int = definition.intData.length > 0 ? int(definition.intData[0]) : 0;
            if (mode == -1)
            {
                index = definition.intData.length > 1 ? int(definition.intData[1]) : 0;
                var value:int = definition.intData.length > 2 ? int(definition.intData[2]) : 0;
                mode = COMPARISON_MODE_START + index;
                if (index >= 0 && index < this._comparisonValues.length)
                {
                    this._comparisonValues[index].value = value;
                }
            }
            this._mode.selected = mode;
        }

        override public function readIntParamsFromForm():Array
        {
            var mode:int = this._mode.selected;
            var index:int = 0;
            var value:int = 0;
            if (mode >= COMPARISON_MODE_START)
            {
                index = mode - COMPARISON_MODE_START;
                value = this._comparisonValues[index].value;
                mode = -1;
            }
            return [mode, index, value];
        }
    }
}
