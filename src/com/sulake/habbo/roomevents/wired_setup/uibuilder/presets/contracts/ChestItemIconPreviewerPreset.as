package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views.ChestItemTypeRenderableWrapper;
    import com.sulake.habbo.window.widgets.IProductIconWidget;

    public class ChestItemIconPreviewerPreset extends WiredUIPreset
    {
        private var _window:IWindowContainer;
        private var _item:ChestItemType;

        public function ChestItemIconPreviewerPreset(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle)
        {
            super(roomEvents, presetManager, style);
            this._window = style.createProductIconPreviewer();
            (this.widgetWindow.widget as IProductIconWidget).unknownImageUri = "";
        }

        public function set item(value:ChestItemType):void
        {
            this._item = value;
            (this.widgetWindow.widget as IProductIconWidget).productInfo =
                value == null ? null : new ChestItemTypeRenderableWrapper(value);
        }

        public function get item():ChestItemType { return this._item; }
        override public function get window():IWindow { return this._window; }
        override public function hasStaticWidth():Boolean { return true; }
        override public function get staticWidth():int { return this._window.width; }

        override public function dispose():void
        {
            if (disposed) return;
            super.dispose();
            this._window.dispose();
            this._window = null;
            this._item = null;
        }

        private function get widgetWindow():IWidgetWindow
        {
            return this._window.findChildByName("icon_preview") as IWidgetWindow;
        }
    }
}
