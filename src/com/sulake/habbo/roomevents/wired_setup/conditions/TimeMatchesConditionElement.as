package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class TimeMatchesConditionElement extends DefaultElement
    {
        private var _use:CheckboxGroupPreset;
        private var _sMin:NamedNumberInputPreset;
        private var _sMax:NamedNumberInputPreset;
        private var _mMin:NamedNumberInputPreset;
        private var _mMax:NamedNumberInputPreset;
        private var _hMin:NamedNumberInputPreset;
        private var _hMax:NamedNumberInputPreset;

        override public function get code():int { return ConditionCodes.TIME_MATCHES; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._use = _arg_1.createCheckboxGroup([new CheckboxOptionParam(l("time.second_selection"), 0), new CheckboxOptionParam(l("time.minute_selection"), 1), new CheckboxOptionParam(l("time.hour_selection"), 2)]);
            this._sMin = _arg_1.createNamedNumberInput(new NumberInputParam(0, 0, 59), "min");
            this._sMax = _arg_1.createNamedNumberInput(new NumberInputParam(0, 0, 59), "max");
            this._mMin = _arg_1.createNamedNumberInput(new NumberInputParam(0, 0, 59), "min");
            this._mMax = _arg_1.createNamedNumberInput(new NumberInputParam(0, 0, 59), "max");
            this._hMin = _arg_1.createNamedNumberInput(new NumberInputParam(0, 0, 23), "min");
            this._hMax = _arg_1.createNamedNumberInput(new NumberInputParam(0, 0, 23), "max");
            _arg_3.addElements(_arg_1.createSection(l("time.filter_selection"), this._use), _arg_1.createSection(l("time.second_selection"), _arg_1.createSimpleListView(true, [this._sMin, this._sMax])), _arg_1.createSection(l("time.minute_selection"), _arg_1.createSimpleListView(true, [this._mMin, this._mMax])), _arg_1.createSection(l("time.hour_selection"), _arg_1.createSimpleListView(true, [this._hMin, this._hMax])));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._use.get(0).selected ? 1 : 0, this._use.get(1).selected ? 1 : 0, this._use.get(2).selected ? 1 : 0, this._sMin.value, this._sMax.value, this._mMin.value, this._mMax.value, this._hMin.value, this._hMax.value];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._use.mask = ((_arg_1.intData.length > 0 && _arg_1.intData[0] == 1) ? 1 : 0) | ((_arg_1.intData.length > 1 && _arg_1.intData[1] == 1) ? 2 : 0) | ((_arg_1.intData.length > 2 && _arg_1.intData[2] == 1) ? 4 : 0);
            this._sMin.value = (_arg_1.intData.length > 3) ? _arg_1.intData[3] : 0;
            this._sMax.value = (_arg_1.intData.length > 4) ? _arg_1.intData[4] : 0;
            this._mMin.value = (_arg_1.intData.length > 5) ? _arg_1.intData[5] : 0;
            this._mMax.value = (_arg_1.intData.length > 6) ? _arg_1.intData[6] : 0;
            this._hMin.value = (_arg_1.intData.length > 7) ? _arg_1.intData[7] : 0;
            this._hMax.value = (_arg_1.intData.length > 8) ? _arg_1.intData[8] : 0;
        }
    }
}
