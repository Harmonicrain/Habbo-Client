package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
{
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Variable-name input with the normalization used by the July client. */
    public class VariableNameSection extends AbstractSectionPreset
    {
        private var _name:TextInputPreset;

        public function VariableNameSection(roomEvents:HabboUserDefinedRoomEvents,
                                            presetManager:PresetManager,
                                            style:WiredStyle)
        {
            super(roomEvents, presetManager, style);
            this._name = presetManager.createTextInput(new TextInputParam("", 40));
            this._name.addListener(this.onNameChanged);
            this.initializeSection(l("variables.variable_name"), this._name);
        }

        private function onNameChanged(value:String):void
        {
            var normalized:String = normalize(value);
            if (this._name.text != normalized)
            {
                this._name.text = normalized;
            }
        }

        private static function normalize(value:String):String
        {
            return (value != null ? value : "").split(" ").join("_").toLowerCase();
        }

        public function set variableName(value:String):void
        {
            this._name.text = value != null ? value : "";
            this.onNameChanged(this._name.text);
        }

        public function get variableName():String
        {
            return normalize(this._name.text);
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._name = null;
        }
    }
}
