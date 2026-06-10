package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.components.ItemListController;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class RadioGroupPreset extends WiredUIPreset
    {
        private var _container:ISelectorWindow;
        private var _radioButtons:Vector.<RadioButtonPreset>;
        private var _onChange:Function;
        private var _rows:Vector.<IItemListWindow>;
        private var _columns:int;

        public function RadioGroupPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array, _arg_5:Function, _arg_6:int = 1)
        {
            var _local_7:Boolean;
            var _local_9:RadioButtonPreset;
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("radio_group_view") as ISelectorWindow;
            this._columns = _arg_6;
            var _local_10:IItemListWindow;
            if (this._columns > 0)
            {
                this._rows = new Vector.<IItemListWindow>();
            }
            this._radioButtons = new Vector.<RadioButtonPreset>();
            var _local_11:int = -1;
            var _local_12:int = 0;
            for each (var _local_13:RadioButtonParam in _arg_4)
            {
                _local_7 = (_arg_4[_arg_4.length - 1] == _local_13);
                _local_9 = _arg_2.createRadioButton(_local_13, _local_7);
                this._radioButtons.push(_local_9);
                if (_arg_6 > 1)
                {
                    if (_local_12 == 0)
                    {
                        _local_10 = _arg_2.createLayout("horizontal_list_view") as IItemListWindow;
                        _local_10.spacing = _arg_3.genericHorizontalSpacing;
                        this._rows.push(_local_10);
                        this.itemList.addListItem(_local_10);
                        _local_11++;
                    }
                    _local_10.addListItem(_local_9.window);
                    _local_9.layoutRowIndex = _local_11;
                    _local_9.layoutColumnIndex = _local_12;
                    _local_9.spanRemainingWidth = _local_13.newLine;
                    if (_local_13.newLine || (_local_12 == (_arg_6 - 1)))
                    {
                        _local_12 = 0;
                    }
                    else
                    {
                        _local_12++;
                    }
                }
                else
                {
                    this.itemList.addListItem(_local_9.window);
                }
                if (_arg_5 != null)
                {
                    _local_9.radioButton.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSelectionChange);
                }
            }
            this.selected = 0;
            this._onChange = _arg_5;
        }

        private function onSelectionChange(_arg_1:WindowEvent):void
        {
            if (this._onChange != null)
            {
                this._onChange(this.selected);
            }
        }

        public function get selected():int
        {
            return this._container.getSelected().id;
        }

        public function set selected(_arg_1:int):void
        {
            var _local_2:IRadioButtonWindow = (this._container as IWindowContainer).findChildByName(RadioButtonPreset.OPTION_PREFIX + _arg_1) as IRadioButtonWindow;
            this._container.setSelected(_local_2);
        }

        public function setOptionDisabled(_arg_1:int, _arg_2:Boolean):void
        {
            this._radioButtons[_arg_1].disabled = _arg_2;
        }

        public function get(_arg_1:int):RadioButtonPreset
        {
            return this._radioButtons[_arg_1];
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            var _local_2:int;
            var _local_5:int;
            var _local_8:IItemListWindow;
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
            this.itemList.width = _arg_1;
            var _local_3:int = ((_arg_1 - ((this._columns - 1) * _style.genericHorizontalSpacing)) / this._columns);
            if (this._columns > 1)
            {
                for each (var _local_7:IItemListWindow in this._rows)
                {
                    _local_7.height = 0;
                    _local_7.width = _arg_1;
                }
            }
            var _local_4:int = 0;
            for each (var _local_6:RadioButtonPreset in this._radioButtons)
            {
                _local_2 = _local_3;
                if ((this._columns > 1) && _local_6.spanRemainingWidth)
                {
                    _local_5 = ((_local_6.layoutColumnIndex * _local_3) + (_local_6.layoutColumnIndex * _style.genericHorizontalSpacing));
                    _local_2 = Math.max(_local_3, (_arg_1 - _local_5));
                }
                _local_6.resizeToWidth(_local_2);
                if (this._columns > 1)
                {
                    _local_8 = this._rows[_local_6.layoutRowIndex];
                    if (_local_6.window.height > _local_8.height)
                    {
                        _local_8.height = _local_6.window.height;
                    }
                }
                _local_4++;
            }
        }

        private function get itemList():ItemListController
        {
            return (this._container as IWindowContainer).findChildByName("radio_button_list") as ItemListController;
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override protected function get childPresets():Array
        {
            return toArray(this._radioButtons);
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
            this._radioButtons = null;
            this._onChange = null;
            this._rows = null;
        }
    }
}
