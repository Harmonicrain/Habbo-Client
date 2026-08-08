package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.IWiredTypeHolder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class HeaderPreset extends WiredUIPreset
    {
        public static const BUTTON_MODE_NONE:int = 0;
        public static const BUTTON_MODE_APPLY_SNAPSHOT:int = 1;
        public static const BUTTON_MODE_VARIABLE_MENU:int = 2;
        public static const BUTTON_MODE_VIEW_LOGS:int = 3;

        private var _buttonMode:int;
        private var _container:IWindowContainer;
        private var _listPreset:SimpleListViewPreset;
        private var _button:WiredUIPreset;
        protected var _width:int;

        public function HeaderPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:IWiredTypeHolder, _arg_6:int, _arg_7:Function, _arg_8:Function, _arg_9:Function)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._buttonMode = _arg_6;
            this._container = _arg_2.createLayout("container_view") as IWindowContainer;
            var _local_10:Array = [];
            var _local_11:WiredUIPreset = this.createTopHeaderElement(_arg_4, _arg_5);
            _local_10.push(_local_11);
            this._button = null;
            if (_arg_6 == BUTTON_MODE_APPLY_SNAPSHOT)
            {
                this._button = _arg_2.createTextualButtonPreset(loc("wiredfurni.applysnapshot"), _arg_7);
            }
            else if (_arg_6 == BUTTON_MODE_VARIABLE_MENU)
            {
                this._button = _arg_2.createTextualButtonPreset(loc("wiredfurni.view_in_menu"), _arg_8);
            }
            else if (_arg_6 == BUTTON_MODE_VIEW_LOGS)
            {
                this._button = _arg_2.createTextualButtonPreset(loc("wiredfurni.params.write_to_logs.view"), _arg_9);
            }
            if (this._button != null)
            {
                this._button = this._button.alignCenter();
                _local_10.push(this._button);
            }
            this._listPreset = _arg_2.createSimpleListView(true, _local_10);
            this._container.addChild(this._listPreset.window);
            this._listPreset.window.x = _style.headerMargin;
            this._listPreset.window.y = _style.headerMargin;
        }

        protected function createTopHeaderElement(_arg_1:String, _arg_2:IWiredTypeHolder):WiredUIPreset
        {
            return null;
        }

        public function updateName(_arg_1:String):void
        {
        }

        public function set buttonVisible(_arg_1:Boolean):void
        {
            if (this._button.visible != _arg_1)
            {
                this._button.visible = _arg_1;
                this.resizeToWidth(this._width);
            }
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._width = _arg_1;
            var _local_2:int = (_style.headerMargin + (((this._button == null) || (!this._button.visible)) ? _style.headerMargin : _style.headerBottomMarginWithLink));
            this._listPreset.resizeToWidth(_arg_1 - (_style.headerMargin * 2));
            this._container.width = _arg_1;
            this._container.height = (Util.getLowestPointList(this._listPreset.window as IItemListWindow) + _local_2);
        }

        override protected function get childPresets():Array
        {
            return [this._listPreset];
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
            this._listPreset = null;
        }
    }
}
