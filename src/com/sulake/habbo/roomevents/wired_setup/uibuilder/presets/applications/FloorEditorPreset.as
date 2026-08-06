package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.AssetButtonRowPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CenteredContainerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class FloorEditorPreset extends WiredUIPreset
    {
        private var _container:IWindowContainer;
        private var _list:SimpleListViewPreset;
        private var _buttonRow:AssetButtonRowPreset;
        private var _drawingPreset:FloorDrawingPreset;
        private var _centeredDrawing:CenteredContainerPreset;

        public function FloorEditorPreset(roomEvents:HabboUserDefinedRoomEvents, presets:PresetManager, style:WiredStyle, buttonRow:AssetButtonRowPreset, drawingPreset:FloorDrawingPreset)
        {
            super(roomEvents, presets, style);
            this._buttonRow = buttonRow;
            this._drawingPreset = drawingPreset;
            var border:IBorderWindow = presets.createLayout("border_view") as IBorderWindow;
            border.color = style.advancedBackgroundColor;
            this._centeredDrawing = presets.createCenteredContainerPreset(this._drawingPreset, 5, border);
            this._list = presets.createSimpleListView(true, [this._buttonRow, this._centeredDrawing]);
            this._list.spacing = style.genericVerticalSpacing;
            this._container = presets.createLayout("growing_container_view") as IWindowContainer;
            this._container.addChild(this._list.window);
        }

        override public function get window():IWindow { return this._container; }

        override public function resizeToWidth(width:int):void
        {
            super.resizeToWidth(width);
            this._list.resizeToWidth(width);
            this._container.width = width;
            this._container.height = this._list.window.height;
        }

        override protected function get childPresets():Array { return [this._list]; }

        override public function dispose():void
        {
            if (disposed) return;
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._list = null;
            this._buttonRow = null;
            this._drawingPreset = null;
            this._centeredDrawing = null;
        }
    }
}
