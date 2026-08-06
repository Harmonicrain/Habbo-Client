package com.sulake.habbo.roomevents.wired_setup.uibuilder.styles
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;

    /** July's dedicated style for Wired trading, contracts and reward dialogs. */
    public class UbuntuWiredStyle extends WiredStyle
    {
        public static const NAME:String = "ubuntu";

        private var _template:IWindowContainer;

        public function UbuntuWiredStyle(roomEvents:HabboUserDefinedRoomEvents)
        {
            super(roomEvents);
            this._template = roomEvents.getXmlWindow("wired_style_ubuntu") as IWindowContainer;
            if (this._template != null && this._template.parent != null)
            {
                this._template.parent = null;
            }
        }

        override protected function get styleTemplate():IWindowContainer { return this._template; }
        override public function get radioButtonSpacing():int { return 3; }
        override public function get checkboxSpacing():int { return 3; }
        override public function get checkboxYOffset():int { return -1; }
        override public function get radioButtonYOffset():int { return -1; }
        override public function get namedTextYOffset():int { return 2; }
        override public function get genericHorizontalSpacing():int { return 5; }
        override public function get genericVerticalSpacing():int { return 5; }
        override public function get sectionSpacing():int { return 7; }
        override public function get sectionLeftRightMargin():int { return 7; }
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
        override public function get frameColor():uint { return 4296112; }
        override public function get backgroundColor():uint { return 15329761; }
        override public function get advancedBackgroundColor():uint { return 14277073; }
        override public function get yellowTextColor():uint { return 8685354; }
        override public function get softTextColor():uint { return 3355443; }
        override public function get redTextColor():uint { return 16069173; }
        override public function get containerButtonPaddingLeft():int { return 10; }
        override public function get containerButtonPaddingTop():int { return 5; }
        override public function get paddedSectionTop():int { return 10; }
        override public function get paddedSectionLeft():int { return 5; }
        override public function get name():String { return NAME; }
    }
}
