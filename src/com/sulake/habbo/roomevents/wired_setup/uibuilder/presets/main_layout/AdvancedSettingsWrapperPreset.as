package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextualButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class AdvancedSettingsWrapperPreset extends WiredUIPreset
    {
        private var _container:IItemListWindow;
        private var _button:TextualButtonPreset = null;
        private var _buttonWrapper:WiredUIPreset = null;
        private var _subsectionsPreset:SimpleListViewPreset;
        private var _isExpanded:Boolean = false;
        private var _alwaysExpanded:Boolean = false;

        public function AdvancedSettingsWrapperPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array, _arg_5:Boolean)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._alwaysExpanded = _arg_5;
            this._container = _arg_2.createLayout("vertical_list_view") as IItemListWindow;
            this._container.spacing = _arg_3.sectionSpacing;
            this._subsectionsPreset = _presetManager.createSimpleListView(true, _arg_4);
            this._subsectionsPreset.spacing = _arg_3.sectionSpacing;
            this._subsectionsPreset.backgroundColor = _arg_3.advancedBackgroundColor;
            blendingBackgroundColor = _arg_3.backgroundColor;
            if (!_arg_5)
            {
                this._button = _presetManager.createTextualButtonPreset("${wiredfurni.params.sources.expand}", this.expandOrCollapse);
                this._buttonWrapper = this._button.alignCenter();
                this._container.addListItem(this._buttonWrapper.window);
            }
            else
            {
                this.expanded = true;
            }
        }

        public function set expanded(_arg_1:Boolean):void
        {
            if ((this._isExpanded != _arg_1) && (!(this._alwaysExpanded && this._isExpanded)))
            {
                this.expandOrCollapse();
            }
        }

        private function expandOrCollapse():void
        {
            if (this._isExpanded)
            {
                this._container.removeListItem(this._subsectionsPreset.window);
                this._isExpanded = false;
                blendingBackgroundColor = _style.backgroundColor;
            }
            else
            {
                this._container.addListItem(this._subsectionsPreset.window);
                this._isExpanded = true;
                blendingBackgroundColor = _style.advancedBackgroundColor;
            }
            if (this._button != null)
            {
                this._button.text = (this._isExpanded) ? "${wiredfurni.params.sources.collapse}" : "${wiredfurni.params.sources.expand}";
                this._buttonWrapper.resizeToWidth(this._container.width);
            }
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
            if (this._buttonWrapper != null)
            {
                this._buttonWrapper.resizeToWidth(_arg_1);
            }
            this._subsectionsPreset.resizeToWidth(_arg_1);
        }

        override protected function get childPresets():Array
        {
            if (this._buttonWrapper == null)
            {
                return [this._subsectionsPreset];
            }
            return [this._buttonWrapper, this._subsectionsPreset];
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
            this._button = null;
            this._buttonWrapper = null;
            this._subsectionsPreset = null;
        }
    }
}
