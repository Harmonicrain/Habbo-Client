package com.sulake.habbo.roomevents.wired_setup.uibuilder.styles
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IHTMLTextWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;

    /**
     * Wired 2.0 visual style base (May WiredStyle). Layout metrics return defaults;
     * concrete styles override them and provide the XML style template whose named
     * children are cloned out by the create* factories.
     */
    public class WiredStyle
    {
        private var _roomEvents:HabboUserDefinedRoomEvents;

        public function WiredStyle(_arg_1:HabboUserDefinedRoomEvents)
        {
            super();
            this._roomEvents = _arg_1;
        }

        protected function get styleTemplate():IWindowContainer
        {
            return null;
        }

        public function get radioButtonSpacing():int { return 0; }
        public function get checkboxSpacing():int { return 0; }
        public function get checkboxYOffset():int { return 0; }
        public function get radioButtonYOffset():int { return 0; }
        public function get namedTextYOffset():int { return 0; }
        public function get namedInputOffset():int { return 0; }
        public function get namedDropdownOffset():int { return 0; }
        public function get genericHorizontalSpacing():int { return 0; }
        public function get genericVerticalSpacing():int { return 0; }
        public function get sectionSpacing():int { return 0; }
        public function get sectionLeftRightMargin():int { return 0; }
        public function get headerMargin():int { return 0; }
        public function get headerBottomMarginWithLink():int { return 0; }
        public function get headerNameFontSize():int { return 0; }
        public function get frameColor():uint { return 0; }
        public function get backgroundColor():uint { return 0; }
        public function get advancedBackgroundColor():uint { return 0; }
        public function get yellowTextColor():uint { return 0; }
        public function get softTextColor():uint { return 0; }
        public function get redTextColor():uint { return 0; }
        public function get minimumOptionHeight():int { return 0; }
        public function get minimumOptionSpacing():int { return 0; }
        public function get optionExtraUnderSpacing():int { return 0; }
        public function get optionExtraUnderLeftMargin():int { return 0; }
        public function get LRContainerMargin():int { return 0; }
        public function get LRContainerSpacing():int { return 0; }
        public function get LRContainerTopBottomPadding():int { return 0; }
        public function get inputSourceListMinHeight():int { return 0; }
        public function get buttonRowSpacing():int { return 0; }
        public function get menuRightOffset():int { return 0; }
        public function get verticalSplitterColor():uint { return 0; }
        public function get name():String { return ""; }
        public function get isVolter():Boolean { return false; }
        public function get useInnerBorder():Boolean { return false; }
        public function get containerButtonPaddingTop():int { return 0; }
        public function get containerButtonPaddingLeft():int { return 0; }
        public function get paddedSectionTop():int { return 0; }
        public function get paddedSectionLeft():int { return 0; }

        public function createSplitterView():IWindowContainer
        {
            return this.recreateElement("ruler_view") as IWindowContainer;
        }

        public function createSplitterVerticalView():IWindowContainer
        {
            return this.recreateElement("ruler_view_vertical") as IWindowContainer;
        }

        public function createTextView(_arg_1:Boolean = true):ITextWindow
        {
            return this.recreateElement(_arg_1 ? "text_bold_view" : "text_view") as ITextWindow;
        }

        public function createHtmlView():IHTMLTextWindow
        {
            return this.recreateElement("text_html") as IHTMLTextWindow;
        }

        public function createTextInputView():IWindow
        {
            return this.recreateElement("input_template");
        }

        public function createCheckboxView():ICheckBoxWindow
        {
            return this.recreateElement("checkbox_view") as ICheckBoxWindow;
        }

        public function createRadioButtonView():IRadioButtonWindow
        {
            return this.recreateElement("radiobutton_view") as IRadioButtonWindow;
        }

        public function createExpandCollapseSectionRegion():IRegionWindow
        {
            return this.recreateElement("expand_collapse_region") as IRegionWindow;
        }

        public function createSourceTypeSelector():IItemListWindow
        {
            return this.recreateElement("sourcetype_selector_view") as IItemListWindow;
        }

        public function createDropdown():IDropMenuWindow
        {
            return this.recreateElement("dropdown_view") as IDropMenuWindow;
        }

        public function createSlider():IWindowContainer
        {
            return this.recreateElement("slider") as IWindowContainer;
        }

        public function createButton():IButtonWindow
        {
            return this.recreateElement("button") as IButtonWindow;
        }

        public function createAssetButton():IContainerButtonWindow
        {
            return this.recreateElement("asset_button") as IContainerButtonWindow;
        }

        public function createIconButton(_arg_1:String):IWindow
        {
            return this.recreateElement("iconbutton_" + _arg_1);
        }

        public function createMiniButton():IWindow
        {
            return this.recreateElement("mini_button_view");
        }

        public function createFrame():IFrameWindow
        {
            return this.recreateElement("frame") as IFrameWindow;
        }

        public function createQuickMenu():IWindowContainer
        {
            return this.recreateElement("quick_menu") as IWindowContainer;
        }

        public function createInnerBorder():IBorderWindow
        {
            return this.recreateElement("inner_border") as IBorderWindow;
        }

        public function createBorder():IBorderWindow
        {
            return this.recreateElement("border") as IBorderWindow;
        }

        public function createContainerButton():IContainerButtonWindow
        {
            return this.recreateElement("container_button") as IContainerButtonWindow;
        }

        private function recreateElement(_arg_1:String):IWindow
        {
            var _local_2:IWindow = this.styleTemplate.findChildByName(_arg_1);
            _local_2 = _local_2.clone();
            _local_2.visible = true;
            return _local_2;
        }
    }
}
