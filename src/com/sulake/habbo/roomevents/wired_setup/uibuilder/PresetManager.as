package com.sulake.habbo.roomevents.wired_setup.uibuilder
{
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.IWiredTypeHolder;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.ISliderValueConverter;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.HtmlTextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonRowPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CenteredContainerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxOptionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CollapseExpandSectionButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ContainerButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.HtmlPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.IconButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.PaddedContainerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.PressedButtonMiniAssetIconButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ScrollListPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SliderPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SourceTypeSelectorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SpacerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SpacingPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SplitterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.StaticBitmapAssetWrapperPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextualButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WindowWrapperPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedDropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedTextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.AdvancedSettingsWrapperPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FooterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FramePreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.HeaderPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.IlluminaHeaderPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.InputSourceSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.BorderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.UsageInfoSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * Central preset factory (May PresetManager, Phase 2 trimmed). Domain factories
     * (variable picker, rewards, floor editor, source-type selector, contracts,
     * chests, menu, avatar image, chrono filters) are deferred to their owning
     * phases and intentionally not present — do not add their imports until the
     * backing preset classes are ported.
     */
    public class PresetManager
    {
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _presetTemplates:Map = new Map();

        public function PresetManager(_arg_1:HabboUserDefinedRoomEvents)
        {
            super();
            this._roomEvents = _arg_1;
        }

        public function createRadioButton(_arg_1:RadioButtonParam, _arg_2:Boolean = false):RadioButtonPreset
        {
            return new RadioButtonPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2);
        }

        public function createRadioGroup(_arg_1:Array, _arg_2:Function = null, _arg_3:int = 1):RadioGroupPreset
        {
            return new RadioGroupPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createCheckboxOption(_arg_1:CheckboxOptionParam, _arg_2:Boolean = false):CheckboxOptionPreset
        {
            return new CheckboxOptionPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2);
        }

        public function createCheckboxGroup(_arg_1:Array, _arg_2:Function = null, _arg_3:int = 1):CheckboxGroupPreset
        {
            return new CheckboxGroupPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createSection(_arg_1:String, _arg_2:WiredUIPreset, _arg_3:SectionParam = null):SectionPreset
        {
            return new SectionPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createBorderSection(_arg_1:String, _arg_2:WiredUIPreset, _arg_3:SectionParam = null):BorderSection
        {
            return new BorderSection(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createUsageInfoSection(_arg_1:String, _arg_2:Boolean = false, _arg_3:String = null):UsageInfoSection
        {
            return new UsageInfoSection(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createCollapseExpandSectionButton(_arg_1:Function = null, _arg_2:Boolean = true):CollapseExpandSectionButtonPreset
        {
            return new CollapseExpandSectionButtonPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2);
        }

        public function createTextInput(_arg_1:TextInputParam):TextInputPreset
        {
            return new TextInputPreset(this._roomEvents, this, this.wiredStyle, _arg_1);
        }

        public function createNumberInput(_arg_1:NumberInputParam):NumberInputPreset
        {
            return new NumberInputPreset(this._roomEvents, this, this.wiredStyle, _arg_1);
        }

        public function createNamedNumberInput(_arg_1:NumberInputParam, _arg_2:String, _arg_3:Boolean = false):NamedNumberInputPreset
        {
            return new NamedNumberInputPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createNamedTextInput(_arg_1:TextInputParam, _arg_2:String, _arg_3:Boolean = false):NamedTextInputPreset
        {
            return new NamedTextInputPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createNamedDropdown(_arg_1:DropdownParam, _arg_2:String, _arg_3:Boolean = false):NamedDropdownPreset
        {
            return new NamedDropdownPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createTextArea(_arg_1:TextAreaParam):TextAreaPreset
        {
            return new TextAreaPreset(this._roomEvents, this, this.wiredStyle, _arg_1);
        }

        public function createSimpleListView(_arg_1:Boolean, _arg_2:Array, _arg_3:Boolean = false):SimpleListViewPreset
        {
            return new SimpleListViewPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createScrollList(_arg_1:Array, _arg_2:ListScrollParams, _arg_3:Boolean = false):ScrollListPreset
        {
            return new ScrollListPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createSplitter():SplitterPreset
        {
            return new SplitterPreset(this._roomEvents, this, this.wiredStyle);
        }

        public function createSpacer(_arg_1:int):SpacerPreset
        {
            return new SpacerPreset(this._roomEvents, this, this.wiredStyle, _arg_1);
        }

        public function createText(_arg_1:String, _arg_2:TextParam = null):TextPreset
        {
            if (_arg_2 == null)
            {
                _arg_2 = TextParam.DEFAULT;
            }
            return new TextPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2);
        }

        public function createHtml(_arg_1:String, _arg_2:HtmlTextParam):HtmlPreset
        {
            return new HtmlPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2);
        }

        public function createDropdown(_arg_1:DropdownParam):DropdownPreset
        {
            return new DropdownPreset(this._roomEvents, this, this.wiredStyle, _arg_1);
        }

        public function createSpacing(_arg_1:Boolean, _arg_2:int):SpacingPreset
        {
            return new SpacingPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2);
        }

        public function createBitmapWrapperPreset(_arg_1:String):StaticBitmapAssetWrapperPreset
        {
            return new StaticBitmapAssetWrapperPreset(this._roomEvents, this, this.wiredStyle, _arg_1);
        }

        public function createTextualButtonPreset(_arg_1:String, _arg_2:Function):TextualButtonPreset
        {
            return new TextualButtonPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2);
        }

        public function createHeaderPreset(_arg_1:String, _arg_2:IWiredTypeHolder, _arg_3:int, _arg_4:Function, _arg_5:Function, _arg_6:Function):HeaderPreset
        {
            // Phase 2: only the Illumina header exists; Volter is deferred and
            // unknown styles fall back to Illumina instead of crashing.
            return new IlluminaHeaderPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        public function createIconButtonPreset(_arg_1:String, _arg_2:Function):IconButtonPreset
        {
            return new IconButtonPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2);
        }

        public function createMiniAssetIconButtonPreset(_arg_1:String, _arg_2:String, _arg_3:Function):PressedButtonMiniAssetIconButtonPreset
        {
            return new PressedButtonMiniAssetIconButtonPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createSliderPreset(_arg_1:Number = 0, _arg_2:Number = 1, _arg_3:Number = 0):SliderPreset
        {
            return new SliderPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createSliderSection(_arg_1:String, _arg_2:String, _arg_3:ISliderValueConverter, _arg_4:Number = 0, _arg_5:Number = 1, _arg_6:Number = 0, _arg_7:Boolean = true, _arg_8:SectionParam = null):SliderSection
        {
            return new SliderSection(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
        }

        public function createButton(_arg_1:String, _arg_2:Function, _arg_3:int = 0):ButtonPreset
        {
            return new ButtonPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createButtonRow(_arg_1:Array):ButtonRowPreset
        {
            return new ButtonRowPreset(this._roomEvents, this, this.wiredStyle, _arg_1);
        }

        public function createFooterPreset(_arg_1:Function, _arg_2:Function):FooterPreset
        {
            return new FooterPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2);
        }

        public function createFramePreset(_arg_1:Array, _arg_2:Function, _arg_3:String = null, _arg_4:int = -1, _arg_5:Boolean = false, _arg_6:Boolean = false, _arg_7:ListScrollParams = null):FramePreset
        {
            // Phase 2: InnerBorderFramePreset (useInnerBorder styles) is deferred.
            return new FramePreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
        }

        public function createAdvancedSettingsWrapperPreset(_arg_1:Array, _arg_2:Boolean):AdvancedSettingsWrapperPreset
        {
            return new AdvancedSettingsWrapperPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2);
        }

        public function createInputSourceSection(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Array = null, _arg_5:Boolean = false, _arg_6:Boolean = false):InputSourceSection
        {
            return new InputSourceSection(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        public function createSourceTypeSelector(_arg_1:SourceTypeSelectorParam):SourceTypeSelectorPreset
        {
            return new SourceTypeSelectorPreset(this._roomEvents, this, this.wiredStyle, _arg_1);
        }

        public function createPaddedContainerPreset(_arg_1:WiredUIPreset, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:IWindowContainer = null, _arg_7:Boolean = false):PaddedContainerPreset
        {
            return new PaddedContainerPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
        }

        public function createContainerButtonPreset(_arg_1:WiredUIPreset, _arg_2:Function, _arg_3:Boolean = true):ContainerButtonPreset
        {
            return new ContainerButtonPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createCenteredContainerPreset(_arg_1:WiredUIPreset, _arg_2:int, _arg_3:IWindowContainer = null):CenteredContainerPreset
        {
            return new CenteredContainerPreset(this._roomEvents, this, this.wiredStyle, _arg_1, _arg_2, _arg_3);
        }

        public function createWrapperPreset(_arg_1:IWindow):WindowWrapperPreset
        {
            return new WindowWrapperPreset(this._roomEvents, this, this.wiredStyle, _arg_1, false);
        }

        public function get wiredStyle():WiredStyle
        {
            return this._roomEvents.wiredCtrl.wiredStyle;
        }

        public function createLayout(_arg_1:String):IWindow
        {
            if (this._presetTemplates.hasKey(_arg_1))
            {
                return IWindow(this._presetTemplates.getValue(_arg_1)).clone();
            }
            var _local_2:IWindow = this._roomEvents.getXmlWindow(_arg_1);
            this._presetTemplates.add(_arg_1, _local_2);
            return _local_2.clone();
        }
    }
}
