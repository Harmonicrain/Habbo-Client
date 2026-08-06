package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
{
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July numeric/textual variable representation selector. */
    public class VariablePlaceholderModeSection extends AbstractSectionPreset
    {
        private var _options:RadioGroupPreset;

        public function VariablePlaceholderModeSection(roomEvents:HabboUserDefinedRoomEvents,
                                                       manager:PresetManager, style:WiredStyle,
                                                       title:String)
        {
            super(roomEvents, manager, style);
            this._options = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("texts.variable_display_type.1")),
                new RadioButtonParam(1, this.l("texts.variable_display_type.2"), null,
                    manager.createText(this.l("texts.variable_display_type.2.info")))
            ]);
            this.initializeSection(title, this._options);
        }

        public function get isTextMode():Boolean { return this._options.selected == 1; }
        public function set isTextMode(value:Boolean):void { this._options.selected = value ? 1 : 0; }
        public function get(index:int):RadioButtonPreset { return this._options.get(index); }
    }
}
