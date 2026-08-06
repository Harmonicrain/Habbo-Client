package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.common.utils.ChronoFieldRangeFilter;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.ChronoMaskFilterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.ChronoRangeFilterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class DateMatchesConditionElement extends ChronoConditionElement
    {
        private var _weekdays:ChronoMaskFilterPreset;
        private var _day:ChronoRangeFilterPreset;
        private var _months:ChronoMaskFilterPreset;
        private var _year:ChronoRangeFilterPreset;

        override public function get code():int { return ConditionCodes.DATE_MATCHES; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(m:PresetManager, style:WiredStyle, b:WiredUIBuilder):void
        {
            this._weekdays = m.createChronoMaskFilter(labels("time.weekday.", 7), 2);
            this._day = m.createChronoRangeFilter(l("time.skip"), l("time.exact"), l("time.range"), 1, 1, 31, 25);
            this._months = m.createChronoMaskFilter(labels("time.month.", 12), 3);
            this._year = m.createChronoRangeFilter(l("time.skip"), l("time.exact"), l("time.range"), 0, 0, 9999, 35);
            b.addElements(m.createSection(l("time.weekday_selection"), this._weekdays),
                m.createSection(l("time.day_selection"), this._day),
                m.createSection(l("time.month_selection"), this._months),
                m.createSection(l("time.year_selection"), this._year),
                createTimezoneSection(m));
        }

        override public function onEditStart(d:Triggerable):void
        {
            super.onEditStart(d);
            var a:Array = d.intData;
            this._weekdays.mask = a.length > 2 ? a[2] : 0;
            this._day.applyFilter(new ChronoFieldRangeFilter("day", a.length > 0 && a[0] == 1,
                a.length > 3 ? a[3] : 1, a.length > 4 ? a[4] : 1, 1));
            this._months.mask = a.length > 5 ? a[5] : 0;
            this._year.applyFilter(new ChronoFieldRangeFilter("year", a.length > 1 && a[1] == 1,
                a.length > 6 ? a[6] : 0, a.length > 7 ? a[7] : 0));
        }

        override public function readIntParamsFromForm():Array
        {
            var d:ChronoFieldRangeFilter = this._day.getFilter("day");
            var y:ChronoFieldRangeFilter = this._year.getFilter("year");
            return [d.useFilter ? 1 : 0, y.useFilter ? 1 : 0, this._weekdays.mask,
                d.min, d.max, this._months.mask, y.min, y.max];
        }

        private function labels(prefix:String, count:int):Array
        {
            var result:Array = [];
            for (var i:int = 1; i <= count; i++) result.push(l(prefix + i));
            return result;
        }
    }
}
