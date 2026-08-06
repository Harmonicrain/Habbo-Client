package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
{
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedTextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July single/multiple placeholder selector with a delimiter field. */
    public class PlaceholderTypeSection extends AbstractSectionPreset
    {
        private var _options:RadioGroupPreset;
        private var _delimiter:NamedTextInputPreset;

        public function PlaceholderTypeSection(roomEvents:HabboUserDefinedRoomEvents,
                                               manager:PresetManager, style:WiredStyle,
                                               type:String = null)
        {
            super(roomEvents, manager, style);
            this._delimiter = manager.createNamedTextInput(new TextInputParam("", 5, null, 55),
                this.l("texts.select_delimiter"));
            var typePrefix:String = type == null ? "" : type + ".";
            this._options = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("texts.placeholder_type." + typePrefix + "1")),
                new RadioButtonParam(1, this.l("texts.placeholder_type." + typePrefix + "2"), null,
                    this._delimiter)
            ]);
            this.initializeSection(this.l("texts.placeholder_type"), this._options);
        }

        public function get isShowMultiple():Boolean { return this._options.selected == 1; }
        public function set isShowMultiple(value:Boolean):void { this._options.selected = value ? 1 : 0; }
        public function get delimiter():String { return this.isShowMultiple ? this._delimiter.text : ""; }
        public function set delimiter(value:String):void { this._delimiter.text = value != null ? value : ""; }
        public function get(index:int):RadioButtonPreset { return this._options.get(index); }
    }
}
