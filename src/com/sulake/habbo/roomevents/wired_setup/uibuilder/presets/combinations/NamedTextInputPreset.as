package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations
{
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class NamedTextInputPreset extends WiredUIPreset
    {
        private var _container:IItemListWindow;
        private var _textPreset:TextPreset;
        private var _textInputPreset:TextInputPreset;

        public function NamedTextInputPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:TextInputParam, _arg_5:String, _arg_6:Boolean = false)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("horizontal_list_view") as IItemListWindow;
            this._textPreset = _arg_2.createText(_arg_5, new TextParam(0, _arg_6));
            this._textPreset.window.y = _arg_3.namedTextYOffset;
            this._textInputPreset = _arg_2.createTextInput(_arg_4);
            this._textPreset.window.y = _arg_3.namedInputOffset;
            this._container.spacing = _arg_3.genericHorizontalSpacing;
            this._container.addListItem(this._textPreset.window);
            this._container.addListItem(this._textInputPreset.window);
            this._container.height = Math.max(this._textPreset.window.height, this._textInputPreset.window.height);
        }

        public function get text():String
        {
            return this._textInputPreset.text;
        }

        public function set text(_arg_1:String):void
        {
            this._textInputPreset.text = _arg_1;
        }

        public function addEventListener(_arg_1:String, _arg_2:Function):void
        {
            this._textInputPreset.addEventListener(_arg_1, _arg_2);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function):void
        {
            this._textInputPreset.removeEventListener(_arg_1, _arg_2);
        }

        override public function hasStaticWidth():Boolean
        {
            return this._textInputPreset.hasStaticWidth();
        }

        override public function get staticWidth():int
        {
            if (hasStaticWidth())
            {
                return this._container.width;
            }
            throw new Exception("Text input has no static width");
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._textPreset.resizeToWidth(this._textPreset.width);
            this._textInputPreset.resizeToWidth(_arg_1 - this._textInputPreset.window.x);
        }

        override protected function get childPresets():Array
        {
            return [this._textPreset, this._textInputPreset];
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
            this._textPreset = null;
            this._textInputPreset = null;
        }
    }
}
