package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    /** July 2026 condition 38: compare the selected furni/user input-source count. */
    public class InputSourceQuantityConditionElement extends DefaultElement
    {
        private var _amount:SliderSection;
        private var _comparison:RadioGroupPreset;
        private var _userSource:Boolean;

        override public function get code():int { return ConditionCodes.INPUT_SOURCE_QUANTITY; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle, builder:WiredUIBuilder):void
        {
            this._comparison = manager.createRadioGroup([
                new RadioButtonParam(0, l("comparison.0")),
                new RadioButtonParam(1, l("comparison.1")),
                new RadioButtonParam(2, l("comparison.2"))
            ]);
            this._amount = manager.createSliderSection("wiredfurni.params.setamount2", "", new SliderValueEcho(), 0, 100, 1);
            builder.addElements(manager.createSection(l("comparison_selection"), this._comparison), this._amount);
        }

        override public function onEditStart(definition:Triggerable):void
        {
            this._userSource = definition.intData.length > 0 && definition.intData[0] != 0;
            this._amount.value = definition.intData.length > 1 ? definition.intData[1] : 0;
            this._comparison.selected = definition.intData.length > 2 ? definition.intData[2] : 1;
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._userSource ? 1 : 0, this._amount.value, this._comparison.selected];
        }

        override public function mergedSelections():Array { return [[0, 0]]; }
        override public function setMergedType(index:int, value:int):void
        {
            this._userSource = value == WiredInputSourcePicker.USER_SOURCE;
        }
        override public function getMergedType(index:int):int
        {
            return this._userSource ? WiredInputSourcePicker.USER_SOURCE : WiredInputSourcePicker.FURNI_SOURCE;
        }
        override public function advancedAlwaysVisible():Boolean { return true; }
    }
}
