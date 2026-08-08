package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications
{
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class ChronoMaskFilterPreset extends WiredUIPreset
    {
        private var _group:CheckboxGroupPreset;

        public function ChronoMaskFilterPreset(events:HabboUserDefinedRoomEvents, manager:PresetManager,
                                               style:WiredStyle, labels:Array, columns:int = 1)
        {
            super(events, manager, style);
            var options:Array = [];
            for (var i:int = 0; i < labels.length; i++)
                options.push(new CheckboxOptionParam(labels[i], i));
            this._group = manager.createCheckboxGroup(options, null, columns);
        }

        public function get mask():int { return this._group.mask; }
        public function set mask(value:int):void { this._group.mask = value; }
        override public function get window():IWindow { return this._group.window; }
        override public function resizeToWidth(value:int):void { super.resizeToWidth(value); this._group.resizeToWidth(value); }
        override protected function get childPresets():Array { return [this._group]; }
    }
}
