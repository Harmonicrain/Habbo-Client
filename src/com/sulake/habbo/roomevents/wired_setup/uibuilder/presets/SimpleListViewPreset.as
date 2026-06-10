package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.interfaces.IListPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class SimpleListViewPreset extends WiredUIPreset implements IListPreset
    {
        private var _container:IItemListWindow;
        private var _presets:Vector.<WiredUIPreset>;
        private var _vertical:Boolean;
        private var _centerItems:Boolean;
        private var _allChildrenStaticWidth:Boolean;
        private var _staticWidth:int;

        public function SimpleListViewPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Boolean, _arg_5:Array, _arg_6:Boolean)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = (_arg_4) ? (_arg_2.createLayout("vertical_list_view") as IItemListWindow) : (_arg_2.createLayout("horizontal_list_view") as IItemListWindow);
            this._vertical = _arg_4;
            this._centerItems = _arg_6;
            this._container.spacing = (_arg_4) ? _arg_3.genericHorizontalSpacing : _arg_3.genericVerticalSpacing;
            this._presets = new Vector.<WiredUIPreset>();
            for each (var _local_7:WiredUIPreset in _arg_5)
            {
                this._presets.push(_local_7);
                this._container.addListItem(_local_7.window);
                _local_7.invisibilityListener = this;
            }
            if (!_arg_4)
            {
                this._allChildrenStaticWidth = true;
                this._staticWidth = 0;
                for each (_local_7 in this._presets)
                {
                    if (!_local_7.hasStaticWidth())
                    {
                        this._allChildrenStaticWidth = false;
                        break;
                    }
                    this._staticWidth += _local_7.staticWidth;
                }
                if (this._allChildrenStaticWidth && (this._presets.length > 1))
                {
                    this._staticWidth += (this._container.spacing * (this._presets.length - 1));
                }
                if (this._allChildrenStaticWidth)
                {
                    this._container.width = this._staticWidth;
                }
            }
        }

        override protected function onInvisibilityChanged(_arg_1:WiredUIPreset, _arg_2:Boolean):void
        {
            this._container.arrangeListItems();
            resize();
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

        public function set minHeight(_arg_1:int):void
        {
            this._container.limits.minHeight = _arg_1;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            var _local_7:WiredUIPreset;
            var _local_8:int;
            var _local_5:int;
            var _local_3:int;
            var _local_9:int;
            var _local_2:int;
            var _local_4:int;
            super.resizeToWidth(_arg_1);
            var _local_6:int = 0;
            for each (_local_7 in this._presets)
            {
                if (_local_7.visible)
                {
                    _local_6++;
                }
            }
            if (this._vertical)
            {
                this._container.width = _arg_1;
                for each (_local_7 in this._presets)
                {
                    _local_7.resizeToWidth(_arg_1);
                }
                if (this._centerItems)
                {
                    throw new Exception("Centering vertical lists not implemented yet");
                }
            }
            else
            {
                _local_8 = (this._allChildrenStaticWidth) ? this._staticWidth : _arg_1;
                _local_5 = (_local_8 - ((_local_6 - 1) * this._container.spacing));
                _local_3 = 0;
                for each (_local_7 in this._presets)
                {
                    if (_local_7.visible)
                    {
                        if (_local_7.hasStaticWidth())
                        {
                            _local_5 -= _local_7.staticWidth;
                        }
                        else
                        {
                            _local_3++;
                        }
                    }
                }
                _local_9 = Math.max(0, int(_local_5 / _local_3));
                _local_2 = int(this._container.limits.minHeight);
                for each (_local_7 in this._presets)
                {
                    if (_local_7.visible)
                    {
                        if (_local_7.hasStaticWidth())
                        {
                            _local_7.resizeToWidth(_local_7.staticWidth);
                        }
                        else
                        {
                            _local_7.resizeToWidth(_local_9);
                        }
                        _local_4 = _local_7.window.height;
                        if (_local_4 > _local_2)
                        {
                            _local_2 = _local_4;
                        }
                    }
                }
                if (this._centerItems)
                {
                    for each (_local_7 in this._presets)
                    {
                        _local_7.window.y = ((_local_2 / 2) - (_local_7.window.height / 2));
                    }
                }
                this._container.width = _local_8;
                this._container.height = _local_2;
            }
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

        override public function hasStaticWidth():Boolean
        {
            return this._allChildrenStaticWidth;
        }

        override public function get staticWidth():int
        {
            if (!this._allChildrenStaticWidth)
            {
                return -1;
            }
            return this._staticWidth;
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
