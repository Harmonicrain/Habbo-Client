package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class ButtonRowPreset extends WiredUIPreset
    {
        private var _container:IWindowContainer;
        private var _listPreset:SimpleListViewPreset;

        public function ButtonRowPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Array)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("growing_container_view") as IWindowContainer;
            this._listPreset = _arg_2.createSimpleListView(false, _arg_4);
            this._listPreset.spacing = _arg_3.buttonRowSpacing;
            this._container.addChild(this._listPreset.window);
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._listPreset.resizeToWidth(_arg_1);
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
