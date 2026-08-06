package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.AssetButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class AssetButtonRowPreset extends WiredUIPreset
    {
        private var _container:IWindowContainer;
        private var _list:SimpleListViewPreset;
        private var _buttons:Vector.<AssetButtonPreset>;
        private var _elements:Array;

        public function AssetButtonRowPreset(roomEvents:HabboUserDefinedRoomEvents, presets:PresetManager, style:WiredStyle, parameters:Array)
        {
            super(roomEvents, presets, style);
            this._buttons = new Vector.<AssetButtonPreset>();
            this._elements = [];
            for each (var parameter:AssetButtonParam in parameters)
            {
                var button:AssetButtonPreset = presets.createAssetButtonPreset(parameter.assetName, parameter.tooltip, parameter.onClick);
                this._buttons.push(button);
                this._elements.push(parameter.alignRight ? button.alignRight() : button);
                if (parameter.isFollowedBySplitter)
                {
                    if (button.window.height == 0) throw new Error("AssetButtonRowPreset requires button height to resolve splitter height");
                    this._elements.push(new VerticalSplitterPreset(roomEvents, presets, style, button.window.height));
                }
            }
            this._list = presets.createSimpleListView(false, this._elements);
            this._list.spacing = style.genericHorizontalSpacing;
            this._container = presets.createLayout("growing_container_view") as IWindowContainer;
            this._container.addChild(this._list.window);
        }

        public function get buttons():Vector.<AssetButtonPreset> { return this._buttons; }
        override public function get window():IWindow { return this._container; }

        override public function resizeToWidth(width:int):void
        {
            super.resizeToWidth(width);
            this._list.resizeToWidth(width);
            this._container.width = this._list.window.width;
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
            this._buttons = null;
            this._elements = null;
        }
    }
}
