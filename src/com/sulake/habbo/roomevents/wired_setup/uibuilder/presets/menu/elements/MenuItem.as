package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.elements
{
    public class MenuItem implements IMenuElement
    {
        private var _name:String;
        private var _onClick:Function;
        private var _tooltip:String;
        private var _hasCheckbox:Boolean;
        private var _selectedChange:Function;

        public function MenuItem(name:String, onClick:Function, tooltip:String = "",
            hasCheckbox:Boolean = false, selectedChange:Function = null)
        {
            this._name = name;
            this._onClick = onClick;
            this._tooltip = tooltip;
            this._hasCheckbox = hasCheckbox;
            this._selectedChange = selectedChange;
        }

        public function get name():String { return this._name; }
        public function get onClick():Function { return this._onClick; }
        public function get tooltip():String { return this._tooltip; }
        public function get hasCheckbox():Boolean { return this._hasCheckbox; }
        public function get selectedChange():Function { return this._selectedChange; }
    }
}
