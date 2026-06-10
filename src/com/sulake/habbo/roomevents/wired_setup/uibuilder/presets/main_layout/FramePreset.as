package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SpacerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.interfaces.IListPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * The real builder layout engine (May FramePreset): frame window, sticky
     * header/footer list composition, resize guard, fixHeight and close button.
     *
     * Phase 2 note: the May quick menu (frame.menuButton / MenuPreset) is deferred —
     * clean IFrameWindow has no menuButton. Save/close work through the footer
     * buttons and the frame's "close" tagged child. The menu-related public
     * methods are kept as no-op stubs so controller code can call them safely.
     */
    public class FramePreset extends WiredUIPreset
    {
        protected var _frame:IFrameWindow;
        protected var _headerPreset:HeaderPreset;
        protected var _listPreset:IListPreset;
        private var _onClose:Function;
        private var _holderKey:String;
        private var _code:int;
        private var _leftRightMargin:int;
        private var _topBottomMargin:int;
        private var _ignoreEvents:Boolean;
        private var _scrollParams:ListScrollParams;

        public function FramePreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array, _arg_5:Function, _arg_6:String, _arg_7:int, _arg_8:Boolean = false, _arg_9:Boolean = false, _arg_10:ListScrollParams = null)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._onClose = _arg_5;
            this._holderKey = _arg_6;
            this._code = _arg_7;
            this._scrollParams = _arg_10;
            this._frame = _arg_3.createFrame();
            this._leftRightMargin = ((this._frame.width - this._frame.margins.right) + this._frame.margins.left);
            this._topBottomMargin = ((this._frame.height - this._frame.margins.bottom) + this._frame.margins.top);
            this.createListView(_arg_4);
            this._listPreset.window.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onContentsResized);
            this._frame.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, this.onCloseClicked);
            this._frame.content.addChild(this._listPreset.window);
            this._frame.color = _style.frameColor;
            if (_arg_8)
            {
                this._frame.setParamFlag(65536, true);
                this._frame.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onFrameResized);
            }
        }

        protected function createListView(_arg_1:Array):void
        {
            var _local_16:SpacerPreset;
            var _local_8:int;
            var _local_17:WiredUIPreset;
            var _local_2:int;
            var _local_13:SpacerPreset;
            var _local_4:SpacerPreset;
            var _local_11:int;
            var _local_3:int;
            var _local_5:ListScrollParams;
            var _local_15:IListPreset;
            var _local_6:Array;
            var _local_12:int = _style.sectionSpacing;
            var _local_10:Array = [];
            var _local_9:HeaderPreset;
            var _local_14:FooterPreset;
            var _local_7:Array = _arg_1;
            if ((this._scrollParams != null) && this._scrollParams.stickyHeader && (_local_7.length > 0) && (_local_7[0] is HeaderPreset))
            {
                _local_9 = (_arg_1[0] as HeaderPreset);
                _local_7 = _arg_1.slice(1, _local_7.length);
            }
            if ((this._scrollParams != null) && this._scrollParams.stickyFooter && (_local_7.length > 0) && (_local_7[_local_7.length - 1] is FooterPreset))
            {
                _local_14 = (_local_7[_local_7.length - 1] as FooterPreset);
                _local_7 = _local_7.slice(0, (_local_7.length - 1));
            }
            _local_8 = 0;
            while (_local_8 < _local_7.length)
            {
                _local_17 = _local_7[_local_8];
                if (_local_17 is HeaderPreset)
                {
                    this._headerPreset = (_local_17 as HeaderPreset);
                }
                _local_10.push(_local_17);
                if (_local_8 < (_local_7.length - 1))
                {
                    _local_16 = _presetManager.createSpacer(_local_12);
                    _local_17.blendSpacer = _local_16;
                    _local_10.push(_local_16);
                }
                _local_8++;
            }
            if (this._scrollParams != null)
            {
                if ((_local_9 != null) || (_local_14 != null))
                {
                    _local_2 = 0;
                    if (_local_9 != null)
                    {
                        _local_2 += (_local_9.window.height + _local_12);
                        _local_13 = _presetManager.createSpacer(_local_12);
                        _local_10.unshift(_local_13);
                    }
                    if (_local_14 != null)
                    {
                        _local_2 += (_local_14.window.height + _local_12);
                        _local_4 = _presetManager.createSpacer(_local_12);
                        _local_10.push(_local_4);
                    }
                    _local_11 = Math.max(0, (this._scrollParams.minHeight - _local_2));
                    _local_3 = Math.max(_local_11, (this._scrollParams.maxHeight - _local_2));
                    _local_5 = new ListScrollParams(this._scrollParams.alwaysShowScrollbar, _local_11, _local_3, false, false);
                    _local_15 = _presetManager.createScrollList(_local_10, _local_5);
                    _local_15.spacing = 0;
                    _local_6 = [];
                    if (_local_9 != null)
                    {
                        _local_6.push(_local_9);
                    }
                    _local_6.push(_local_15);
                    if (_local_14 != null)
                    {
                        _local_6.push(_local_14);
                    }
                    this._listPreset = _presetManager.createSimpleListView(true, _local_6);
                    this._listPreset.spacing = 0;
                    return;
                }
                this._listPreset = _presetManager.createScrollList(_local_10, this._scrollParams);
            }
            else
            {
                this._listPreset = _presetManager.createSimpleListView(true, _local_10);
            }
            this._listPreset.spacing = 0;
        }

        public function set title(_arg_1:String):void
        {
            this._frame.caption = _arg_1;
        }

        public function refreshForNewTriggerable():void
        {
            // Quick menu deferred for Phase 2 — nothing to refresh.
        }

        public function updateButtonDisabledStates():void
        {
            // Quick menu deferred for Phase 2 — no menu buttons to update.
        }

        private function onFrameResized(_arg_1:WindowEvent):void
        {
            if (!this._ignoreEvents)
            {
                this.resizeToWidth(this._frame.width);
            }
        }

        private function onContentsResized(_arg_1:WindowEvent):void
        {
            if (!this._ignoreEvents)
            {
                this.fixHeight();
            }
        }

        private function onCloseClicked(_arg_1:WindowMouseEvent):void
        {
            if (this._onClose != null)
            {
                this._onClose();
            }
        }

        public function get isCopyingIntoMode():Boolean
        {
            return false;
        }

        override public function get window():IWindow
        {
            return this._frame;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._ignoreEvents = true;
            this._frame.width = _arg_1;
            this._listPreset.resizeToWidth(_arg_1 - this._leftRightMargin);
            this._ignoreEvents = false;
            this.fixHeight();
        }

        private function get headerFrameBackground():IWindow
        {
            return this._frame.findChildByTag("wired_header_bg");
        }

        private function fixHeight():void
        {
            this._ignoreEvents = true;
            var _local_2:int = (this._listPreset.window.height + this._topBottomMargin);
            this._frame.limits.minHeight = _local_2;
            this._frame.limits.maxHeight = _local_2;
            this._frame.height = _local_2;
            this._ignoreEvents = false;
            var _local_1:IWindow = this.headerFrameBackground;
            if ((_local_1 != null) && (this._headerPreset != null))
            {
                _local_1.height = ((this._headerPreset.window.height + this._frame.margins.top) + _style.sectionSpacing);
            }
        }

        override protected function get childPresets():Array
        {
            return [this._listPreset];
        }

        override public function dispose():void
        {
            this._listPreset.window.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onContentsResized);
            this._frame.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onFrameResized);
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._frame.dispose();
            this._frame = null;
            this._listPreset = null;
            this._onClose = null;
        }
    }
}
