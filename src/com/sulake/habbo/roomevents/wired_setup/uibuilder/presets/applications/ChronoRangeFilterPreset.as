package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications
{
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.common.utils.ChronoFieldRangeFilter;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class ChronoRangeFilterPreset extends WiredUIPreset
    {
        private var _mode:RadioGroupPreset;
        private var _exact:NumberInputPreset;
        private var _min:NumberInputPreset;
        private var _max:NumberInputPreset;
        private var _defaultValue:int;

        public function ChronoRangeFilterPreset(events:HabboUserDefinedRoomEvents, manager:PresetManager,
                                                style:WiredStyle, skip:String, exact:String, range:String,
                                                initial:int, minimum:int, maximum:int, width:int)
        {
            super(events, manager, style);
            this._defaultValue = initial;
            this._exact = manager.createNumberInput(new NumberInputParam(initial, minimum, maximum, width));
            this._min = manager.createNumberInput(new NumberInputParam(initial, minimum, maximum, width));
            this._max = manager.createNumberInput(new NumberInputParam(initial, minimum, maximum, width));
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(0, skip),
                new RadioButtonParam(1, exact, this._exact),
                new RadioButtonParam(2, range, manager.createSimpleListView(false,
                    [this._min, manager.createText("-", new TextParam(0)), this._max], true))]);
            this._mode.selected = 0;
        }

        public function applyFilter(filter:ChronoFieldRangeFilter):void
        {
            this._mode.selected = !filter.useFilter ? 0 : (filter.min == filter.max ? 1 : 2);
            this._exact.value = this._mode.selected == 1 ? filter.min : this._defaultValue;
            this._min.value = this._mode.selected == 2 ? filter.min : this._defaultValue;
            this._max.value = this._mode.selected == 2 ? filter.max : this._defaultValue;
        }

        public function getFilter(name:String):ChronoFieldRangeFilter
        {
            if (this._mode.selected == 0)
                return new ChronoFieldRangeFilter(name, false, this._defaultValue, this._defaultValue, this._defaultValue);
            if (this._mode.selected == 1)
                return new ChronoFieldRangeFilter(name, true, this._exact.value, this._exact.value, this._defaultValue);
            return new ChronoFieldRangeFilter(name, true, this._min.value, this._max.value, this._defaultValue);
        }

        override public function get window():IWindow { return this._mode.window; }
        override public function resizeToWidth(value:int):void { super.resizeToWidth(value); this._mode.resizeToWidth(value); }
        override protected function get childPresets():Array { return [this._mode]; }
    }
}
