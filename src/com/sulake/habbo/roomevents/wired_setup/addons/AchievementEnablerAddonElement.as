package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 2001: newline-separated achievement identifiers to enable. */
    public class AchievementEnablerAddonElement extends DefaultElement
    {
        private var _identifiers:TextAreaPreset;

        override public function get code():int { return AddonCodes.ACHIEVEMENT_ENABLER; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.ENVIRONMENT_V2;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._identifiers = manager.createTextArea(new TextAreaParam(60, -1, -1, 100, 2000,
                "", this.l("achievement_enabler.placeholder")));
            builder.addElements(manager.createSection(this.l("achievement_enabler"), this._identifiers));
        }

        override public function onEditStart(definition:Triggerable):void
        {
            this._identifiers.text = definition.stringData;
        }

        override public function readStringParamFromForm():String { return this._identifiers.text; }
    }
}
