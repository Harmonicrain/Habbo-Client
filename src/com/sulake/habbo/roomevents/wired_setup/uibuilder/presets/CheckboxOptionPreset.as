package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class CheckboxOptionPreset extends WiredUIPreset
    {
        private var _container:IWindowContainer;
        private var _verticalList:IItemListWindow;
        private var _horizontalList:IItemListWindow;
        private var _checkbox:ICheckBoxWindow;
        private var _textPreset:TextPreset;
        private var _iconPreset:StaticBitmapAssetWrapperPreset;
        private var _extra1:WiredUIPreset;
        private var _extra2:WiredUIPreset;
        private var _last:Boolean;

        public function CheckboxOptionPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:CheckboxOptionParam, _arg_5:Boolean = false)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("growing_container_view") as IWindowContainer;
            this._verticalList = _arg_2.createLayout("vertical_list_view") as IItemListWindow;
            this._horizontalList = _arg_2.createLayout("horizontal_list_view") as IItemListWindow;
            this._last = _arg_5;
            this._checkbox = _arg_3.createCheckboxView();
            this._checkbox.id = _arg_4.id;
            if ((_arg_4.text != null) && (_arg_4.text != ""))
            {
                this._textPreset = _arg_2.createText(_arg_4.text, new TextParam((_arg_4.extra1 != null) ? 0 : 1));
            }
            if ((_arg_4.iconAssetName != null) && (_arg_4.iconAssetName != ""))
            {
                this._iconPreset = _arg_2.createBitmapWrapperPreset(resolveAssetFullName(_arg_4.iconAssetName));
            }
            if (_arg_3.checkboxYOffset > 0)
            {
                if (this._textPreset != null)
                {
                    this._textPreset.window.y = _arg_3.checkboxYOffset;
                }
                if (this._iconPreset != null)
                {
                    this._iconPreset.window.y = _arg_3.checkboxYOffset;
                }
            }
            else if (_arg_3.checkboxYOffset < 0)
            {
                this._checkbox.y = -_arg_3.checkboxYOffset;
            }
            this._horizontalList.addListItem(this._checkbox);
            if (this._iconPreset != null)
            {
                this._horizontalList.addListItem(this._iconPreset.window);
            }
            if (this._textPreset != null)
            {
                this._horizontalList.addListItem(this._textPreset.window);
            }
            this._horizontalList.spacing = _arg_3.checkboxSpacing;
            if (_arg_4.extra1 != null)
            {
                this._extra1 = _arg_4.extra1;
                this._horizontalList.addListItem(this._extra1.window);
            }
            this._verticalList.addListItem(this._horizontalList);
            this._verticalList.spacing = _arg_3.optionExtraUnderSpacing;
            if (_arg_4.extra2 != null)
            {
                this._extra2 = _arg_4.extra2;
                this._verticalList.addListItem(this._extra2.window);
                this._extra2.window.x = _arg_3.optionExtraUnderLeftMargin;
            }
            if ((this._extra1 != null) || (this._extra2 != null))
            {
                this._checkbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSelect);
                this._checkbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onUnSelect);
                this.onUnSelect(null);
            }
            this._container.addChild(this._verticalList);
        }

        private function onSelect(_arg_1:WindowEvent):void
        {
            if (this._extra1 != null)
            {
                this._extra1.disabled = false;
            }
            if (this._extra2 != null)
            {
                this._extra2.disabled = false;
            }
        }

        private function onUnSelect(_arg_1:WindowEvent):void
        {
            if (this._extra1 != null)
            {
                this._extra1.disabled = true;
            }
            if (this._extra2 != null)
            {
                this._extra2.disabled = true;
            }
        }

        override public function set disabled(_arg_1:Boolean):void
        {
            super.disabled = _arg_1;
            if ((!_arg_1) && (!this.selected))
            {
                this.onUnSelect(null);
            }
        }

        public function set selected(_arg_1:Boolean):void
        {
            Util.select(this._checkbox, _arg_1);
        }

        public function get selected():Boolean
        {
            return this._checkbox.Selected;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            var _local_3:int;
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
            this._verticalList.width = _arg_1;
            this._horizontalList.width = _arg_1;
            if ((this._textPreset != null) && (!this._textPreset.canStretch) && (this._extra1 != null))
            {
                throw new Error("Illegal UI combination: could not determine width of text");
            }
            if ((this._textPreset != null) && (this._extra1 == null))
            {
                this._textPreset.resizeToWidth(_arg_1 - this._textPreset.window.x);
            }
            else if (this._textPreset != null)
            {
                this._textPreset.resizeToWidth(this._textPreset.width);
            }
            if (this._extra1 != null)
            {
                this._extra1.resizeToWidth(_arg_1 - this._extra1.window.x);
            }
            if (this._extra2 != null)
            {
                this._extra2.resizeToWidth(_arg_1 - this._extra2.window.x);
            }
            var _local_2:int = (this._checkbox.height + this._checkbox.y);
            if (this._textPreset != null)
            {
                _local_2 = Math.max(_local_2, (this._textPreset.window.height + this._textPreset.window.y));
            }
            if (this._iconPreset != null)
            {
                _local_2 = Math.max(_local_2, (this._iconPreset.window.height + this._iconPreset.window.y));
            }
            if ((this._extra1 != null) && (this._extra1.window.height > _local_2))
            {
                _local_3 = ((this._extra1.window.height - _local_2) / 2);
                this._checkbox.y = _local_3;
                if (this._textPreset != null)
                {
                    this._textPreset.window.y = (_local_3 + _style.checkboxYOffset);
                }
                if (this._iconPreset != null)
                {
                    this._iconPreset.window.y = (_local_3 + _style.checkboxYOffset);
                }
                _local_2 = this._extra1.window.height;
            }
            this._horizontalList.height = _local_2;
            if (!this._last)
            {
                this._container.height = Math.max((this._verticalList.height + _style.minimumOptionSpacing), _style.minimumOptionHeight);
            }
            else
            {
                this._container.height = this._verticalList.height;
            }
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        public function get checkbox():ICheckBoxWindow
        {
            return this._checkbox;
        }

        override protected function get childPresets():Array
        {
            var _local_1:Array = [];
            if (this._textPreset != null)
            {
                _local_1.push(this._textPreset);
            }
            if (this._iconPreset != null)
            {
                _local_1.push(this._iconPreset);
            }
            if (this._extra1 != null)
            {
                _local_1.push(this._extra1);
            }
            if (this._extra2 != null)
            {
                _local_1.push(this._extra2);
            }
            return _local_1;
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
            this._verticalList = null;
            this._horizontalList = null;
            this._textPreset = null;
            this._iconPreset = null;
            this._checkbox = null;
            this._extra1 = null;
            this._extra2 = null;
        }
    }
}
