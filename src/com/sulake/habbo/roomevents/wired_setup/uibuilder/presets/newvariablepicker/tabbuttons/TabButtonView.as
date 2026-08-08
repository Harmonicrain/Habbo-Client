package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.ExpandedVariablePickerView;

    public class TabButtonView implements IDisposable
    {
        private static const SELECTED_BG:uint = 0xE0E0E0;
        private static const SELECTED_SHADOW:uint = 0xFFA9AAAA;
        private static const HOVER_BG:uint = 0xEFEFEF;
        private static const HOVER_SHADOW:uint = 0xFFCCCCCC;
        private static const NONE_BG:uint = 0xFAFAFA;
        private static const NONE_SHADOW:uint = 0xFFDDDDDD;

        private var _parent:ExpandedVariablePickerView;
        private var _window:IRegionWindow;
        private var _tabConfig:TabButtonConfig;
        private var _disposed:Boolean;
        private var _active:Boolean;
        private var _hover:Boolean;

        public function TabButtonView(parent:ExpandedVariablePickerView, config:TabButtonConfig, width:int)
        {
            this._parent = parent;
            this._tabConfig = config;
            this._window = parent.tabButtonTemplate.clone() as IRegionWindow;
            this._window.width = width;
            this._window.toolTipCaption = parent.roomEvents.localization.getLocalization(config.tooltipCaption, config.tooltipCaption);
            this.image.assetUri = config.assetUri;
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._window.addEventListener(WindowMouseEvent.OVER, this.onOver);
            this._window.addEventListener(WindowMouseEvent.OUT, this.onOut);
            this.updateColoring();
        }

        public function set active(value:Boolean):void { this._active = value; this.updateColoring(); }
        public function get tabConfig():TabButtonConfig { return this._tabConfig; }
        public function get window():IRegionWindow { return this._window; }

        private function onClick(event:WindowMouseEvent):void { this._parent.selectTab(this); }
        private function onOver(event:WindowMouseEvent):void { this._hover = true; this.updateColoring(); }
        private function onOut(event:WindowMouseEvent):void { this._hover = false; this.updateColoring(); }

        private function updateColoring():void
        {
            this.buttonBorder.color = this._active ? SELECTED_BG : (this._hover ? HOVER_BG : NONE_BG);
            this.buttonShadow.color = this._active ? SELECTED_SHADOW : (this._hover ? HOVER_SHADOW : NONE_SHADOW);
            this.image.blend = this._active ? 0.6 : (this._hover ? 0.5 : 0.4);
        }

        private function get buttonBorder():IBorderWindow { return this._window.findChildByName("button_border") as IBorderWindow; }
        private function get buttonShadow():IWindowContainer { return this._window.findChildByName("button_shadow") as IWindowContainer; }
        private function get image():IStaticBitmapWrapperWindow { return this._window.findChildByName("button_img") as IStaticBitmapWrapperWindow; }

        public function dispose():void
        {
            if (this._disposed) { return; }
            this._window.dispose();
            this._window = null;
            this._parent = null;
            this._tabConfig = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
