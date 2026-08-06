package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
{
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class NodeOverviewPreset extends TradeRuleEditorPreset
    {
        private var _onNodeClick:Function;

        public function NodeOverviewPreset(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle, title:String,
            onNodeClick:Function = null)
        {
            super(roomEvents, presetManager, style, title, null, null);
            var button:IWindow = this.addMoreButton;
            button.parent = null;
            button.dispose();
            this.closeRegion.visible = false;
            this._onNodeClick = onNodeClick;
        }

        override protected function get isOneLineMode():Boolean { return false; }
        override protected function get showNodeCloseButton():Boolean { return false; }
        override protected function updateCloseButtonVisibility():void {}
        override internal function editNode(view:TradeRuleNodeView):void
        {
            if (this._onNodeClick != null) this._onNodeClick(view.node);
        }
    }
}
