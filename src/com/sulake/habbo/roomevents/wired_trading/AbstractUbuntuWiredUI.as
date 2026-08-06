package com.sulake.habbo.roomevents.wired_trading
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FooterPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FramePreset;

    public class AbstractUbuntuWiredUI implements IDisposable
    {
        private var _framePreset:FramePreset;
        private var _footerPreset:FooterPreset;
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _presetManager:PresetManager;
        private var _disposed:Boolean;
        private var _hasLocation:Boolean;

        public function AbstractUbuntuWiredUI(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager)
        {
            this._roomEvents = roomEvents;
            this._presetManager = presetManager;
            this._footerPreset = this.createFooterPreset();
        }

        protected function createFooterPreset():FooterPreset
        {
            return this._presetManager.createFooterPreset(this.onSaveClicked,
                this.onCloseClicked);
        }
        public function get footerPreset():FooterPreset { return this._footerPreset; }
        public function onSaveClicked():void {}
        public function onCloseClicked():void { this.hide(); }
        public function isShowing():Boolean
        {
            return this._framePreset != null && this._framePreset.window.parent != null
                && this._framePreset.window.visible;
        }
        public function get xOffsetFromCenter():int { return 0; }
        protected function showFrame():void
        {
            if (!this.isShowing())
            {
                var desktop:IDesktopWindow = this._roomEvents.windowManager.getDesktop(1);
                if (desktop != null) { desktop.addChild(this._framePreset.window); }
                if (!this.isRememberLocation || !this._hasLocation)
                {
                    this._framePreset.window.center();
                    this._framePreset.window.x += this.xOffsetFromCenter;
                    this._hasLocation = true;
                }
            }
            this._framePreset.window.activate();
        }
        public function get window():IWindow { return this._framePreset.window; }
        public function forgetLocation():void { this._hasLocation = false; }
        protected function get isRememberLocation():Boolean { return false; }
        protected function get isBoundToParentRect():Boolean { return false; }
        public function hide():void { this.hideFrame(); }
        protected function hideFrame():void
        {
            if (this.isShowing())
            {
                var desktop:IDesktopWindow = this._roomEvents.windowManager.getDesktop(1);
                if (desktop != null) { desktop.removeChild(this._framePreset.window); }
            }
        }
        protected function set framePreset(value:FramePreset):void
        {
            this._framePreset = value;
            if (this.isBoundToParentRect) { value.window.setParamFlag(32, true); }
        }
        protected function get framePreset():FramePreset { return this._framePreset; }
        protected function get roomEvents():HabboUserDefinedRoomEvents { return this._roomEvents; }
        protected function get localization():IHabboLocalizationManager
        {
            return this._roomEvents.localization;
        }
        protected function get presetManager():PresetManager { return this._presetManager; }
        public function dispose():void
        {
            if (this._disposed) { return; }
            if (this._framePreset != null) { this._framePreset.dispose(); }
            this._framePreset = null;
            this._footerPreset = null;
            this._roomEvents = null;
            this._presetManager = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
