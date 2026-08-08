package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 9: animation duration in milliseconds. */
    public class AnimationTimeAddonElement extends DefaultElement
    {
        private var _time:SliderSection;

        override public function get code():int { return AddonCodes.ANIMATION_TIME; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.ADDONS; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._time = manager.createSliderSection("wiredfurni.params.setanimationtime2", "",
                SliderSection.CONVERTER_ECHO, 50, 2000, 50);
            builder.addElements(this._time);
        }

        override public function onEditStart(definition:Triggerable):void
        {
            this._time.value = definition.intData.length > 0 ? int(definition.intData[0]) : 50;
        }

        override public function readIntParamsFromForm():Array { return [this._time.value]; }
    }
}
