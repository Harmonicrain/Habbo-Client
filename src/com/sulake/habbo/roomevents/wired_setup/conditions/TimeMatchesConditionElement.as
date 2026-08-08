package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.common.utils.ChronoFieldRangeFilter;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.ChronoRangeFilterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class TimeMatchesConditionElement extends ChronoConditionElement
    {
        private var _seconds:ChronoRangeFilterPreset;
        private var _minutes:ChronoRangeFilterPreset;
        private var _hours:ChronoRangeFilterPreset;

        override public function get code():int { return ConditionCodes.TIME_MATCHES; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(m:PresetManager, style:WiredStyle, b:WiredUIBuilder):void
        {
            this._hours = m.createChronoRangeFilter(l("time.skip"), l("time.exact"), l("time.range"), 0, 0, 23, 25);
            this._minutes = m.createChronoRangeFilter(l("time.skip"), l("time.exact"), l("time.range"), 0, 0, 59, 25);
            this._seconds = m.createChronoRangeFilter(l("time.skip"), l("time.exact"), l("time.range"), 0, 0, 59, 25);
            b.addElements(m.createSection(l("time.hour_selection"), this._hours),
                m.createSection(l("time.minute_selection"), this._minutes),
                m.createSection(l("time.second_selection"), this._seconds),
                createTimezoneSection(m));
        }

        override public function onEditStart(d:Triggerable):void
        {
            super.onEditStart(d);
            var a:Array = d.intData;
            this._seconds.applyFilter(new ChronoFieldRangeFilter("second", a.length > 0 && a[0] == 1,
                a.length > 3 ? a[3] : 0, a.length > 4 ? a[4] : 0));
            this._minutes.applyFilter(new ChronoFieldRangeFilter("minute", a.length > 1 && a[1] == 1,
                a.length > 5 ? a[5] : 0, a.length > 6 ? a[6] : 0));
            this._hours.applyFilter(new ChronoFieldRangeFilter("hour", a.length > 2 && a[2] == 1,
                a.length > 7 ? a[7] : 0, a.length > 8 ? a[8] : 0));
        }

        override public function readIntParamsFromForm():Array
        {
            var s:ChronoFieldRangeFilter = this._seconds.getFilter("second");
            var m:ChronoFieldRangeFilter = this._minutes.getFilter("minute");
            var h:ChronoFieldRangeFilter = this._hours.getFilter("hour");
            return [s.useFilter ? 1 : 0, m.useFilter ? 1 : 0, h.useFilter ? 1 : 0,
                s.min, s.max, m.min, m.max, h.min, h.max];
        }
    }
}
