package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications
{
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.applications.SubVariableParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July's checkbox + immutable generated-variable-name control. */
    public class SubVariableCreatorPreset extends WiredUIPreset
    {
        private var _checkboxGroup:CheckboxGroupPreset;

        public function SubVariableCreatorPreset(roomEvents:HabboUserDefinedRoomEvents,
                                                 presets:PresetManager,
                                                 style:WiredStyle,
                                                 localizationPrefix:String,
                                                 variables:Array)
        {
            super(roomEvents, presets, style);
            var options:Array = [];
            for each (var variable:SubVariableParam in variables)
            {
                var key:String = localizationPrefix + variable.id;
                var option:CheckboxOptionParam = new CheckboxOptionParam("${" + key + "}", variable.id);
                option.extra1 = presets.createTextInput(
                    new TextInputParam(variable.name, -1, null, 85, null, false)).alignRight();
                if (variable.hasExtraText)
                {
                    var textParam:TextParam = new TextParam(1);
                    textParam.textColor = style.softTextColor;
                    option.extra2 = presets.createText("${" + key + ".extra}", textParam);
                }
                options.push(option);
            }
            this._checkboxGroup = presets.createCheckboxGroup(options);
        }

        public function set mask(value:int):void { this._checkboxGroup.mask = value; }
        public function get mask():int { return this._checkboxGroup.mask; }
        override public function get window():IWindow { return this._checkboxGroup.window; }
        override public function resizeToWidth(value:int):void
        {
            super.resizeToWidth(value);
            this._checkboxGroup.resizeToWidth(value);
        }
        override protected function get childPresets():Array { return [this._checkboxGroup]; }
        override public function dispose():void
        {
            if (disposed) { return; }
            super.dispose();
            this._checkboxGroup = null;
        }
    }
}
