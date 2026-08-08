package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdown;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class DropdownPreset extends WiredUIPreset
    {
        private var _container:IDropMenuWindow;
        private var _dropdown:ExpandableDropdown;

        public function DropdownPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:DropdownParam)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_3.createDropdown();
            this._container.caption = _arg_4.caption;
            this._dropdown = new ExpandableDropdown(this._container, _arg_4.showMoreLocalization, _arg_4.onChangeCallback);
            this._dropdown.init((_arg_4.options == null) ? Vector.<ExpandableDropdownOption>([]) : _arg_4.options, -1);
        }

        public function get selectedId():int
        {
            return this._dropdown.selectedOptionId;
        }

        public function get selected():ExpandableDropdownOption
        {
            return this._dropdown.selectedOption;
        }

        public function set selectedId(_arg_1:int):void
        {
            this._dropdown.selectedOptionId = _arg_1;
        }

        public function reinit(_arg_1:Vector.<ExpandableDropdownOption>, _arg_2:int):void
        {
            this._dropdown.init(_arg_1, _arg_2);
        }

        public function reset():void
        {
            this.reinit(Vector.<ExpandableDropdownOption>([]), -1);
        }

        public function get dropdownOptions():Vector.<ExpandableDropdownOption>
        {
            return this._dropdown.dropdownOptions;
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
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
            this._dropdown.dispose();
        }
    }
}
