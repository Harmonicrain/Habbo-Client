package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.IWiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * Abstract base for builder presets (May WiredUIPreset). Universal constructor
     * prefix (roomEvents, presetManager, style) is shared by every concrete preset.
     */
    public class WiredUIPreset implements IWiredUIPreset
    {
        private var _disposing:Boolean = false;
        private var _isDisposed:Boolean = false;
        protected var _roomEvents:HabboUserDefinedRoomEvents;
        protected var _presetManager:PresetManager;
        protected var _style:WiredStyle;
        private var _blendSpacer:SpacerPreset;
        private var _blendingBackgroundColor:int = 0;
        private var _cacheWidth:int = -1;
        private var _isDisabled:Boolean;
        private var _invisibilityListener:WiredUIPreset;

        public function WiredUIPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle)
        {
            super();
            this._roomEvents = _arg_1;
            this._presetManager = _arg_2;
            this._style = _arg_3;
        }

        protected static function toArray(_arg_1:*):Array
        {
            var _local_2:Array = [];
            for each (var _local_3:* in _arg_1)
            {
                _local_2.push(_local_3);
            }
            return _local_2;
        }

        public function get window():IWindow
        {
            return null;
        }

        public function resizeToWidth(_arg_1:int):void
        {
            this._cacheWidth = _arg_1;
        }

        public function resize():void
        {
            if (this._cacheWidth != -1)
            {
                this.resizeToWidth(this._cacheWidth);
            }
        }

        public function hasStaticWidth():Boolean
        {
            return false;
        }

        public function get staticWidth():int
        {
            return -1;
        }

        public function alignRight():WiredUIPreset
        {
            return new AlignRightWrapperPreset(this._roomEvents, this._presetManager, this._style, this);
        }

        public function alignCenter():WiredUIPreset
        {
            return new AlignCenterWrapperPreset(this._roomEvents, this._presetManager, this._style, this);
        }

        public function staticHeight(_arg_1:int):WiredUIPreset
        {
            return new StaticHeightPreset(this._roomEvents, this._presetManager, this._style, this, _arg_1);
        }

        public function floatVertically():WiredUIPreset
        {
            return new FloatVerticallyPreset(this._roomEvents, this._presetManager, this._style, this);
        }

        public function wrapWindow(_arg_1:IWindow, _arg_2:Boolean = false):WiredUIPreset
        {
            return new WindowWrapperPreset(this._roomEvents, this._presetManager, this._style, _arg_1, _arg_2);
        }

        public function noDisable():WiredUIPreset
        {
            window.tags.push("DO_NOT_DISABLE");
            return this;
        }

        public function halfBlend():WiredUIPreset
        {
            window.blend = 0.5;
            window.tags.push("HALF_BLEND");
            return this;
        }

        public function set disabled(_arg_1:Boolean):void
        {
            if (this._isDisabled == _arg_1)
            {
                return;
            }
            this._isDisabled = _arg_1;
            this.updateDisabledState();
        }

        public function updateDisabledState():void
        {
            Util.disableSection(window, this._isDisabled);
            if (!this._isDisabled)
            {
                for each (var _local_1:WiredUIPreset in this.childPresets)
                {
                    _local_1.updateDisabledState();
                }
            }
        }

        protected function get childPresets():Array
        {
            return [];
        }

        public function get disabled():Boolean
        {
            return this._isDisabled;
        }

        public function set visible(_arg_1:Boolean):void
        {
            if (window.visible != _arg_1)
            {
                window.visible = _arg_1;
                if (this._invisibilityListener != null)
                {
                    this._invisibilityListener.onInvisibilityChanged(this, _arg_1);
                }
            }
        }

        public function get visible():Boolean
        {
            return window.visible;
        }

        internal function set invisibilityListener(_arg_1:WiredUIPreset):void
        {
            this._invisibilityListener = _arg_1;
        }

        protected function onInvisibilityChanged(_arg_1:WiredUIPreset, _arg_2:Boolean):void
        {
        }

        protected function loc(_arg_1:String):String
        {
            return this._roomEvents.localization.getLocalization(_arg_1, _arg_1);
        }

        protected function l(_arg_1:String):String
        {
            return this._roomEvents.localization.getLocalization("wiredfurni.params." + _arg_1, _arg_1);
        }

        protected function get localizations():IHabboLocalizationManager
        {
            return this._roomEvents.localization;
        }

        protected function get disposing():Boolean
        {
            return this._disposing;
        }

        public function dispose():void
        {
            this._disposing = true;
            if (this._isDisposed)
            {
                return;
            }
            this._blendSpacer = null;
            this._roomEvents = null;
            this._style = null;
            this._presetManager = null;
            this._invisibilityListener = null;
            for each (var _local_1:WiredUIPreset in this.childPresets)
            {
                _local_1.dispose();
            }
            this._isDisposed = true;
        }

        public function set blendSpacer(_arg_1:SpacerPreset):void
        {
            this._blendSpacer = _arg_1;
            this.updateBackgroundColorBlending();
        }

        protected function set blendingBackgroundColor(_arg_1:int):void
        {
            this._blendingBackgroundColor = _arg_1;
            this.updateBackgroundColorBlending();
        }

        private function updateBackgroundColorBlending():void
        {
            var _local_1:Boolean;
            if (this._blendSpacer != null)
            {
                _local_1 = (this._blendingBackgroundColor != 0);
                this._blendSpacer.backgroundEnabled = _local_1;
                if (_local_1)
                {
                    this._blendSpacer.backgroundColor = this._blendingBackgroundColor;
                }
            }
        }

        protected function resolveAssetFullName(_arg_1:String):String
        {
            var _local_2:String = ("wired_styles_" + this._style.name + "_" + _arg_1);
            if (this._roomEvents.windowManager.assets.getAssetByName(_local_2) != null)
            {
                return _local_2;
            }
            return ("wired_" + _arg_1);
        }

        public function get disposed():Boolean
        {
            return this._isDisposed;
        }
    }
}
