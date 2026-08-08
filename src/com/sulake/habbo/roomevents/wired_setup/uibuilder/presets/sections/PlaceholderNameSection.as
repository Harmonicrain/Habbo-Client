package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
{
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.HtmlTextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.HtmlPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July placeholder-name input with its live normalized usage preview. */
    public class PlaceholderNameSection extends AbstractSectionPreset
    {
        private var _name:TextInputPreset;
        private var _preview:HtmlPreset;
        private var _prefix:String;

        public function PlaceholderNameSection(roomEvents:HabboUserDefinedRoomEvents,
                                               manager:PresetManager, style:WiredStyle,
                                               title:String, prefix:String)
        {
            super(roomEvents, manager, style);
            this._prefix = prefix;
            this._name = manager.createTextInput(new TextInputParam("", 32, null, -1, "a-zA-Z_0-9 "));
            this._preview = manager.createHtml(this.l("texts.placeholder_preview"), new HtmlTextParam(1, true, 2));
            this._name.addListener(this.onPlaceholderChange);
            this.initializeSection(title, manager.createSimpleListView(true, [this._name, this._preview]));
        }

        private function onPlaceholderChange(value:String):void
        {
            var normalized:String = (value != null ? value : "").split(" ").join("_").toLowerCase();
            if (this._name.text != normalized) { this._name.text = normalized; }
            this._preview.text = this._roomEvents.localization.getLocalizationWithParams(
                "wiredfurni.params.texts.placeholder_preview", "", "placeholder",
                this._prefix + "(" + normalized + ")");
        }

        public function set placeholderName(value:String):void
        {
            this._name.text = value != null ? value : "";
            this.onPlaceholderChange(this._name.text);
        }

        public function get placeholderName():String
        {
            return this._name.text.split(" ").join("_").toLowerCase();
        }
    }
}
