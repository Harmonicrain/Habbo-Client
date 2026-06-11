package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class DateMatchesConditionElement extends DefaultElement
    {
        private var _use:CheckboxGroupPreset;
        private var _weekdayMask:NamedNumberInputPreset;
        private var _dayMin:NamedNumberInputPreset;
        private var _dayMax:NamedNumberInputPreset;
        private var _monthMask:NamedNumberInputPreset;
        private var _yearMin:NamedNumberInputPreset;
        private var _yearMax:NamedNumberInputPreset;

        override public function get code():int { return ConditionCodes.DATE_MATCHES; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._use = _arg_1.createCheckboxGroup([new CheckboxOptionParam(l("time.day_selection"), 0), new CheckboxOptionParam(l("time.year_selection"), 1)]);
            this._weekdayMask = _arg_1.createNamedNumberInput(new NumberInputParam(0, 0, 127), l("time.weekday_selection"));
            this._dayMin = _arg_1.createNamedNumberInput(new NumberInputParam(1, 1, 31), "min");
            this._dayMax = _arg_1.createNamedNumberInput(new NumberInputParam(1, 1, 31), "max");
            this._monthMask = _arg_1.createNamedNumberInput(new NumberInputParam(0, 0, 4095), l("time.month_selection"));
            this._yearMin = _arg_1.createNamedNumberInput(new NumberInputParam(0, 0, 9999), "min");
            this._yearMax = _arg_1.createNamedNumberInput(new NumberInputParam(0, 0, 9999), "max");
            _arg_3.addElements(_arg_1.createSection(l("time.filter_selection"), this._use), _arg_1.createSection(l("time.weekday_selection"), this._weekdayMask), _arg_1.createSection(l("time.day_selection"), _arg_1.createSimpleListView(true, [this._dayMin, this._dayMax])), _arg_1.createSection(l("time.month_selection"), this._monthMask), _arg_1.createSection(l("time.year_selection"), _arg_1.createSimpleListView(true, [this._yearMin, this._yearMax])));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._use.get(0).selected ? 1 : 0, this._use.get(1).selected ? 1 : 0, this._weekdayMask.value, this._dayMin.value, this._dayMax.value, this._monthMask.value, this._yearMin.value, this._yearMax.value];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._use.mask = ((_arg_1.intData.length > 0 && _arg_1.intData[0] == 1) ? 1 : 0) | ((_arg_1.intData.length > 1 && _arg_1.intData[1] == 1) ? 2 : 0);
            this._weekdayMask.value = (_arg_1.intData.length > 2) ? _arg_1.intData[2] : 0;
            this._dayMin.value = (_arg_1.intData.length > 3) ? _arg_1.intData[3] : 1;
            this._dayMax.value = (_arg_1.intData.length > 4) ? _arg_1.intData[4] : 1;
            this._monthMask.value = (_arg_1.intData.length > 5) ? _arg_1.intData[5] : 0;
            this._yearMin.value = (_arg_1.intData.length > 6) ? _arg_1.intData[6] : 0;
            this._yearMax.value = (_arg_1.intData.length > 7) ? _arg_1.intData[7] : 0;
        }
    }
}
