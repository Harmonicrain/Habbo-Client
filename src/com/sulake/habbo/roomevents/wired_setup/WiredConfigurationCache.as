package com.sulake.habbo.roomevents.wired_setup
{
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.AdvancedSettingsWrapperPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FooterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FramePreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.HeaderPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;

    /**
     * Value struct snapshotting one built editor window's presets so the controller
     * can restore it from its keyed cache (May WiredConfigurationCache).
     * Input-source presets remain an Array because a configuration can expose
     * several independently typed source slots.
     */
    public class WiredConfigurationCache
    {
        private var _frame:FramePreset;
        private var _headerPreset:HeaderPreset;
        private var _selectorOptionsPreset:CheckboxGroupPreset;
        private var _furniPicksSectionPreset:SectionPreset;
        private var _delayPreset:SliderSection;
        private var _initialWidth:int;
        private var _advancedSettingsWrapperPreset:AdvancedSettingsWrapperPreset;
        private var _conditionQuantifierOptions:RadioGroupPreset;
        private var _inputSourcePresets:Array;
        private var _footerPreset:FooterPreset;

        public function WiredConfigurationCache(_arg_1:FramePreset, _arg_2:HeaderPreset, _arg_3:CheckboxGroupPreset, _arg_4:SectionPreset, _arg_5:SliderSection, _arg_6:AdvancedSettingsWrapperPreset, _arg_7:RadioGroupPreset, _arg_8:Array, _arg_9:FooterPreset, _arg_10:int)
        {
            super();
            this._frame = _arg_1;
            this._headerPreset = _arg_2;
            this._selectorOptionsPreset = _arg_3;
            this._furniPicksSectionPreset = _arg_4;
            this._delayPreset = _arg_5;
            this._advancedSettingsWrapperPreset = _arg_6;
            this._conditionQuantifierOptions = _arg_7;
            this._inputSourcePresets = _arg_8;
            this._footerPreset = _arg_9;
            this._initialWidth = _arg_10;
        }

        public function get frame():FramePreset
        {
            return this._frame;
        }

        public function get headerPreset():HeaderPreset
        {
            return this._headerPreset;
        }

        public function get selectorOptionsPreset():CheckboxGroupPreset
        {
            return this._selectorOptionsPreset;
        }

        public function get furniPicksSectionPreset():SectionPreset
        {
            return this._furniPicksSectionPreset;
        }

        public function get delayPreset():SliderSection
        {
            return this._delayPreset;
        }

        public function get advancedSettingsWrapperPreset():AdvancedSettingsWrapperPreset
        {
            return this._advancedSettingsWrapperPreset;
        }

        public function get conditionQuantifierOptions():RadioGroupPreset
        {
            return this._conditionQuantifierOptions;
        }

        public function get inputSourcePresets():Array
        {
            return this._inputSourcePresets;
        }

        public function get footerPreset():FooterPreset
        {
            return this._footerPreset;
        }

        public function get initialWidth():int
        {
            return this._initialWidth;
        }
    }
}
