package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class HorizontalSectionListPreset extends WiredUIPreset
    {
        private var _list:IItemListWindow;
        private var _splitters:Vector.<IWindow>;
        private var _presets:Array;

        public function HorizontalSectionListPreset(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle, presets:Array)
        {
            super(roomEvents, presetManager, style);
            this._list = presetManager.createLayout("horizontal_list_view") as IItemListWindow;
            this._list.spacing = 0;
            this._splitters = new Vector.<IWindow>();
            this._presets = presets;
            for (var i:int = 0; i < presets.length; i++)
            {
                var preset:WiredUIPreset = presets[i] as WiredUIPreset;
                if (i > 0)
                {
                    var splitter:IWindow = style.createSplitterVerticalView();
                    splitter.setParamFlag(16, false);
                    this._splitters.push(splitter);
                    this._list.addListItem(splitter);
                }
                this._list.addListItem(preset.window);
            }
        }

        override public function get window():IWindow { return this._list; }

        override public function resizeToWidth(width:int):void
        {
            super.resizeToWidth(width);
            var splitterWidth:int = this._splitters.length > 0 ? this._splitters[0].width : 0;
            var remaining:int = width - this._splitters.length * splitterWidth;
            var flexible:int = 0;
            var preset:WiredUIPreset;
            for each (preset in this._presets)
            {
                if (preset.hasStaticWidth()) remaining -= preset.staticWidth;
                else flexible++;
            }
            var share:int = flexible > 0 ? Math.max(0, int(remaining / flexible)) : 0;
            var lastFlexible:WiredUIPreset;
            var maximumHeight:int = 0;
            for each (preset in this._presets)
            {
                if (preset.hasStaticWidth()) preset.resizeToWidth(preset.staticWidth);
                else
                {
                    lastFlexible = preset;
                    preset.resizeToWidth(share);
                    remaining -= share;
                }
                maximumHeight = Math.max(maximumHeight, preset.window.height);
            }
            if (remaining > 0 && lastFlexible != null)
            {
                lastFlexible.resizeToWidth(share + remaining);
                maximumHeight = Math.max(maximumHeight, lastFlexible.window.height);
            }
            for each (var splitter:IWindow in this._splitters)
            {
                splitter.height = maximumHeight + this._style.sectionSpacing;
            }
            this._list.height = maximumHeight;
            this._list.width = width;
            this._list.arrangeListItems();
        }

        override protected function get childPresets():Array { return this._presets; }

        override public function dispose():void
        {
            if (disposed) return;
            super.dispose();
            this._list.dispose();
            this._list = null;
            this._presets = null;
            this._splitters = null;
        }
    }
}
