package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypePicker;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.newpicker.NewSourceTypePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class SourceTypeSelectorPreset extends WiredUIPreset
    {
        private var _window:IItemListWindow;
        private var _picker:ISourceTypePicker;

        public function SourceTypeSelectorPreset(k:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:SourceTypeSelectorParam)
        {
            super(k, _arg_2, _arg_3);
            this._window = _arg_3.createSourceTypeSelector();
            this._picker = new NewSourceTypePicker(k, this._window, _arg_4.listener as ISourceTypeListener);
            this._picker.initialize(_arg_4.ids, _arg_4.currentSelection);
        }

        public function select(k:int):void
        {
            this._picker.select(k);
        }

        override public function hasStaticWidth():Boolean
        {
            return true;
        }

        override public function get staticWidth():int
        {
            return this._window.width;
        }

        override public function get window():IWindow
        {
            return this._window;
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._window.dispose();
            this._window = null;
            this._picker.dispose();
            this._picker = null;
        }
    }
}
