package com.sulake.habbo.roomevents.wired_setup.uibuilder.styles
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;

    public class IlluminaWiredStyle extends WiredStyle
    {
        public static const NAME:String = "illumina";

        private var _styleTemplate:IWindowContainer;

        public function IlluminaWiredStyle(_arg_1:HabboUserDefinedRoomEvents)
        {
            super(_arg_1);
            this._styleTemplate = IWindowContainer(_arg_1.getXmlWindow("wired_style_illumina"));
        }

        override protected function get styleTemplate():IWindowContainer
        {
            return this._styleTemplate;
        }

        override public function get radioButtonSpacing():int { return 3; }
        override public function get checkboxSpacing():int { return 3; }
        override public function get checkboxYOffset():int { return 2; }
        override public function get namedInputOffset():int { return 2; }
        override public function get namedDropdownOffset():int { return 2; }
        override public function get radioButtonYOffset():int { return 0; }
        override public function get namedTextYOffset():int { return 0; }
        override public function get genericHorizontalSpacing():int { return 5; }
        override public function get genericVerticalSpacing():int { return 5; }
        override public function get sectionSpacing():int { return 5; }
        override public function get sectionLeftRightMargin():int { return 5; }
        override public function get headerMargin():int { return 5; }
        override public function get headerBottomMarginWithLink():int { return 1; }
        override public function get headerNameFontSize():int { return 12; }
        override public function get minimumOptionHeight():int { return 20; }
        override public function get minimumOptionSpacing():int { return 4; }
        override public function get optionExtraUnderSpacing():int { return 3; }
        override public function get optionExtraUnderLeftMargin():int { return 25; }
        override public function get LRContainerMargin():int { return 9; }
        override public function get LRContainerSpacing():int { return 6; }
        override public function get LRContainerTopBottomPadding():int { return 4; }
        override public function get inputSourceListMinHeight():int { return 23; }
        override public function get buttonRowSpacing():int { return 12; }
        override public function get menuRightOffset():int { return 12; }
        override public function get verticalSplitterColor():uint { return 0xFFAAAAAA; }
        override public function get frameColor():uint { return 0xE2E2E2; }
        override public function get backgroundColor():uint { return frameColor; }
        override public function get advancedBackgroundColor():uint { return 0xCCCCCC; }
        override public function get yellowTextColor():uint { return 0x727514; }
        override public function get softTextColor():uint { return 0x444444; }
        override public function get redTextColor():uint { return 0xED3033; }
        override public function get name():String { return NAME; }
    }
}
