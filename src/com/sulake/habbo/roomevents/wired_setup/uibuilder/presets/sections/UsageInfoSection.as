package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
{
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * "Usage information" help section (May UsageInfoSection): soft-colored
     * multiline text under a collapsible header — expanded with a chevron by
     * default, or collapsed when requested.
     */
    public class UsageInfoSection extends AbstractSectionPreset
    {
        private var _textPreset:TextPreset;

        public function UsageInfoSection(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:Boolean = false, _arg_6:String = null)
        {
            super(_arg_1, _arg_2, _arg_3);
            var _local_7:TextParam = new TextParam(1);
            _local_7.textColor = _arg_3.softTextColor;
            this._textPreset = _arg_2.createText(_arg_4, _local_7);
            if (_arg_6 == null)
            {
                _arg_6 = l("general_box_info");
            }
            initializeSection(_arg_6, this._textPreset, (_arg_5) ? SectionParam.COLLAPSED : SectionParam.EXPANDED_WITH_TOGGLE);
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._textPreset = null;
        }
    }
}
