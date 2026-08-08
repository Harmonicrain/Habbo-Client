package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations
{
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class NamedDropdownPreset extends WiredUIPreset
    {
        private var _container:IWindowContainer;
        private var _listPreset:SimpleListViewPreset;
        private var _textPreset:TextPreset;
        private var _dropdownPreset:DropdownPreset;

        public function NamedDropdownPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:DropdownParam, _arg_5:String, _arg_6:Boolean = false)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("growing_container_view") as IWindowContainer;
            this._textPreset = _arg_2.createText(_arg_5, new TextParam(0, _arg_6));
            this._dropdownPreset = _arg_2.createDropdown(_arg_4);
            this._textPreset.window.y = _arg_3.namedDropdownOffset;
            this._listPreset = _arg_2.createSimpleListView(false, [this._textPreset, this._dropdownPreset], true);
            this._container.addChild(this._listPreset.window);
        }

        public function get selectedId():int
        {
            return this._dropdownPreset.selectedId;
        }

        public function set selectedId(_arg_1:int):void
        {
            this._dropdownPreset.selectedId = _arg_1;
        }

        public function get selected():ExpandableDropdownOption
        {
            return this._dropdownPreset.selected;
        }

        public function reinit(_arg_1:Vector.<ExpandableDropdownOption>, _arg_2:int):void
        {
            this._dropdownPreset.reinit(_arg_1, _arg_2);
        }

        public function reset():void
        {
            this._dropdownPreset.reset();
        }

        override public function hasStaticWidth():Boolean
        {
            return this._dropdownPreset.hasStaticWidth();
        }

        override public function get staticWidth():int
        {
            if (hasStaticWidth())
            {
                return this._container.width;
            }
            throw new Exception("Named dropdown has no static width");
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
            this._listPreset.dispose();
            this._listPreset = null;
            this._textPreset = null;
            this._dropdownPreset = null;
        }
    }
}
