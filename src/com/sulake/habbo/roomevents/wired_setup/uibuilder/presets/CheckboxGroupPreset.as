package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class CheckboxGroupPreset extends WiredUIPreset
    {
        private var _container:IItemListWindow;
        private var _checkboxes:Map;
        private var _onChange:Function;
        private var _rows:Vector.<IItemListWindow>;
        private var _columns:int;

        public function CheckboxGroupPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array, _arg_5:Function, _arg_6:int = 1)
        {
            var _local_9:Boolean;
            var _local_8:CheckboxOptionPreset;
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("vertical_list_view") as IItemListWindow;
            this._columns = _arg_6;
            this._onChange = _arg_5;
            var _local_10:int = 0;
            var _local_7:IItemListWindow;
            if (this._columns > 0)
            {
                this._rows = new Vector.<IItemListWindow>();
            }
            this._checkboxes = new Map();
            for each (var _local_11:CheckboxOptionParam in _arg_4)
            {
                if (_local_11.id == -1)
                {
                    _local_11.id = _local_10;
                }
                _local_9 = (_arg_4[_arg_4.length - 1] == _local_11);
                _local_8 = _arg_2.createCheckboxOption(_local_11, _local_9);
                this._checkboxes.add(_local_11.id, _local_8);
                if (_arg_6 > 1)
                {
                    if ((_local_10 % _arg_6) == 0)
                    {
                        _local_7 = _arg_2.createLayout("horizontal_list_view") as IItemListWindow;
                        _local_7.spacing = _arg_3.genericHorizontalSpacing;
                        this._rows.push(_local_7);
                        this._container.addListItem(_local_7);
                    }
                    _local_7.addListItem(_local_8.window);
                }
                else
                {
                    this._container.addListItem(_local_8.window);
                }
                if (_arg_5 != null)
                {
                    _local_8.checkbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSelectionChange);
                    _local_8.checkbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onSelectionChange);
                }
                _local_10++;
            }
        }

        private function onSelectionChange(_arg_1:WindowEvent):void
        {
            var _local_2:int;
            if (this._onChange != null)
            {
                _local_2 = _arg_1.window.id;
                this._onChange(_local_2, this.get(_local_2).selected);
            }
        }

        public function get(_arg_1:int):CheckboxOptionPreset
        {
            return this._checkboxes.getValue(_arg_1);
        }

        public function get numCheckboxes():int
        {
            return this._checkboxes.length;
        }

        public function get mask():int
        {
            var _local_1:int;
            for each (var _local_2:CheckboxOptionPreset in this._checkboxes.getValues())
            {
                if (_local_2.selected)
                {
                    _local_1 = (_local_1 | (1 << _local_2.checkbox.id));
                }
            }
            return _local_1;
        }

        public function set mask(_arg_1:int):void
        {
            var _local_2:Boolean;
            for each (var _local_3:CheckboxOptionPreset in this._checkboxes.getValues())
            {
                _local_2 = ((_arg_1 & (1 << _local_3.checkbox.id)) != 0);
                Util.select(_local_3.checkbox, _local_2);
            }
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            var _local_5:IItemListWindow;
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
            var _local_2:int = ((_arg_1 - ((this._columns - 1) * _style.genericHorizontalSpacing)) / this._columns);
            var _local_3:int = 0;
            for each (var _local_4:CheckboxOptionPreset in this._checkboxes.getValues())
            {
                _local_4.resizeToWidth(_local_2);
                if (this._columns > 1)
                {
                    _local_5 = this._rows[int(_local_3 / this._columns)];
                    if (_local_4.window.height > _local_5.height)
                    {
                        _local_5.height = _local_4.window.height;
                    }
                }
                _local_3++;
            }
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override protected function get childPresets():Array
        {
            return this._checkboxes.getValues();
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
            this._checkboxes = null;
            this._onChange = null;
            this._rows = null;
        }
    }
}
