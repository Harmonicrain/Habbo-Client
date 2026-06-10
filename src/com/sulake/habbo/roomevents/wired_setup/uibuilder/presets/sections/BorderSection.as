package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
{
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class BorderSection extends AbstractSectionPreset
    {
        public function BorderSection(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:WiredUIPreset, _arg_6:SectionParam = null)
        {
            super(_arg_1, _arg_2, _arg_3);
            initializeSection(_arg_4, _arg_2.createPaddedContainerPreset(_arg_5, _arg_3.paddedSectionLeft, _arg_3.paddedSectionTop, _arg_3.paddedSectionLeft, _arg_3.paddedSectionTop, _arg_3.createBorder()));
        }
    }
}
