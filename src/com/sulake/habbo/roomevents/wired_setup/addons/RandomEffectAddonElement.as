package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 1: pick effects randomly while avoiding recent selections. */
    public class RandomEffectAddonElement extends DefaultElement
    {
        private var _skips:SliderSection;
        private var _picks:SliderSection;

        override public function get code():int { return AddonCodes.RANDOM_EFFECT; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.ADDONS; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._skips = manager.createSliderSection("wiredfurni.params.skipactions", "skips",
                SliderSection.CONVERTER_ECHO, 0, 100, 1, false);
            this._picks = manager.createSliderSection("wiredfurni.params.pickamount", "picks",
                SliderSection.CONVERTER_ECHO, 1, 100, 1, false);
            builder.addElements(this._picks, this._skips);
        }

        override public function onEditStart(definition:Triggerable):void
        {
            this._skips.value = definition.intData.length > 0 ? int(definition.intData[0]) : 0;
            this._picks.value = definition.intData.length > 1 ? int(definition.intData[1]) : 1;
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._skips.value, this._picks.value];
        }
    }
}
