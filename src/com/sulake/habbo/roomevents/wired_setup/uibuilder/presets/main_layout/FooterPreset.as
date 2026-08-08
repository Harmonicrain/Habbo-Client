package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonRowPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SplitterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class FooterPreset extends WiredUIPreset
    {
        private var _container:IItemListWindow;
        private var _splitter:SplitterPreset;
        private var _buttonRow:ButtonRowPreset;
        private var _saveButton:ButtonPreset;

        public function FooterPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Function, _arg_5:Function)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("vertical_list_view") as IItemListWindow;
            this._splitter = _arg_2.createSplitter();
            this._saveButton = _arg_2.createButton(loc("wiredfurni.ready"), _arg_4);
            var _local_6:ButtonPreset = _arg_2.createButton(loc("cancel"), _arg_5);
            this._buttonRow = _arg_2.createButtonRow([this._saveButton, _local_6]);
            this._buttonRow.window.x = _arg_3.sectionLeftRightMargin;
            this._container.spacing = _style.sectionSpacing;
            this._container.addListItem(this._splitter.window);
            this._container.addListItem(this._buttonRow.window);
        }

        public function set saveButtonDisabled(_arg_1:Boolean):void
        {
            this._saveButton.disabled = _arg_1;
        }

        public function set saveButtonCaption(_arg_1:String):void
        {
            if ((this._saveButton != null) && (this._saveButton.window != null))
            {
                this._saveButton.window.caption = _arg_1;
            }
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        public function set splitterVisible(_arg_1:Boolean):void
        {
            this._splitter.visible = _arg_1;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
            this._splitter.resizeToWidth(_arg_1);
            this._buttonRow.resizeToWidth(_arg_1 - (_style.sectionLeftRightMargin * 2));
        }

        override protected function get childPresets():Array
        {
            return [this._splitter, this._buttonRow];
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._splitter = null;
            this._buttonRow = null;
            this._saveButton = null;
        }
    }
}
