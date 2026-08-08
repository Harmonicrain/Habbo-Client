package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
{
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SourceTypeSelectorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class AbstractSectionPreset extends WiredUIPreset
    {
        protected var _section:SectionPreset;

        public function AbstractSectionPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        protected function initializeSection(_arg_1:String, _arg_2:WiredUIPreset, _arg_3:SectionParam = null):void
        {
            this._section = _presetManager.createSection(_arg_1, _arg_2, _arg_3);
        }

        override public function get window():IWindow
        {
            return this._section.window;
        }

        public function set sectionTitle(_arg_1:String):void
        {
            this._section.titleText = _arg_1;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._section.resizeToWidth(_arg_1);
        }

        public function set splitterVisible(_arg_1:Boolean):void
        {
            this._section.splitterVisible = _arg_1;
        }

        public function getSourceTypeSelector():SourceTypeSelectorPreset
        {
            return this._section.getSourceTypeSelector();
        }

        override protected function get childPresets():Array
        {
            return [this._section];
        }

        override public function dispose():void
        {
            super.dispose();
            this._section = null;
        }
    }
}
