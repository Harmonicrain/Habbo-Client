package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.interfaces.IListPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class ScrollListPreset extends WiredUIPreset implements IListPreset
    {
        private var SCROLLBAR_WIDTH:int = 9;
        private var SCROLLBAR_MARGIN:int = 3;

        private var _container:IScrollableListWindow;
        private var _presets:Vector.<WiredUIPreset>;
        private var _centerItems:Boolean;
        private var _scrollParams:ListScrollParams;
        private var _cachedWidth:int;
        private var _ignoreListeners:Boolean;

        public function ScrollListPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array, _arg_5:ListScrollParams, _arg_6:Boolean = false)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("vertical_scroll_list_view") as IScrollableListWindow;
            this._centerItems = _arg_6;
            this._scrollParams = _arg_5;
            this._container.spacing = _arg_3.genericVerticalSpacing;
            this._presets = new Vector.<WiredUIPreset>();
            for each (var _local_7:WiredUIPreset in _arg_4)
            {
                this._presets.push(_local_7);
                this._container.addListItem(_local_7.window);
            }
            this._container.limits.minHeight = _arg_5.minHeight;
            this._container.limits.maxHeight = _arg_5.maxHeight;
            if (_arg_5.alwaysShowScrollbar)
            {
                this._container.autoHideScrollBar = true;
            }
            this._container.scrollableWindow.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onScrollableWindowResized);
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        public function set spacing(_arg_1:int):void
        {
            this._container.spacing = _arg_1;
        }

        public function get spacing():int
        {
            return this._container.spacing;
        }

        public function resizeChildrenToWidth(_arg_1:int):void
        {
            var _local_3:WiredUIPreset;
            var _local_2:int;
            _local_2 += (this._container.spacing * (this._presets.length - 1));
            for each (_local_3 in this._presets)
            {
                _local_3.resizeToWidth(_arg_1);
                _local_2 += _local_3.window.height;
            }
            if (this._centerItems)
            {
                for each (_local_3 in this._presets)
                {
                    _local_3.window.x = ((_arg_1 / 2) - (_local_3.window.width / 2));
                }
            }
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            this._ignoreListeners = true;
            this._cachedWidth = _arg_1;
            super.resizeToWidth(_arg_1);
            var _local_2:int = _arg_1;
            var _local_3:int = _arg_1;
            if (!this._scrollParams.alwaysShowScrollbar)
            {
                this.resizeChildrenToWidth(_local_2);
                this.fixHeight();
            }
            if (this._container.isScrollBarVisible)
            {
                _local_2 = (_arg_1 - SCROLLBAR_WIDTH - SCROLLBAR_MARGIN);
                this.resizeChildrenToWidth(_local_2);
                _local_3 = (_arg_1 - SCROLLBAR_MARGIN);
            }
            this._container.width = _local_3;
            this.fixHeight();
            this._ignoreListeners = false;
        }

        private function fixHeight():void
        {
            this._container.height = Math.min(this._scrollParams.maxHeight, Math.max(this._scrollParams.minHeight, this._container.scrollableRegion.height));
        }

        private function onScrollableWindowResized(_arg_1:WindowEvent):void
        {
            if (this._ignoreListeners || disposing)
            {
                return;
            }
            this.resizeToWidth(this._cachedWidth);
        }

        public function set backgroundColor(_arg_1:uint):void
        {
            this._container.background = true;
            this._container.color = (0xFF000000 | _arg_1);
        }

        override protected function get childPresets():Array
        {
            return toArray(this._presets);
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
            this._presets = null;
        }
    }
}
