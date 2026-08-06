package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.views
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.MenuPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.elements.MenuItem;

    public class MenuItemView implements IDisposable
    {
        private var _disposed:Boolean = false;
        private var _window:IRegionWindow;
        private var _menu:MenuPreset;
        private var _item:MenuItem;
        private var _hovered:Boolean = false;
        private var _checkboxHovered:Boolean = false;
        private var _disabled:Boolean = false;
        private var _ignoreEvents:Boolean = false;

        public function MenuItemView(menu:MenuPreset, item:MenuItem)
        {
            this._menu = menu;
            this._item = item;
            this._window = menu.menuItemTemplate.clone() as IRegionWindow;
            this.textWindow.text = item.name;
            this.checkboxWindow.visible = item.hasCheckbox;
            if (item.tooltip != null && item.tooltip.length > 0)
            {
                this._window.toolTipCaption = item.tooltip;
            }
            this._window.addEventListener(WindowMouseEvent.OVER, this.onHover);
            this._window.addEventListener(WindowMouseEvent.OUT, this.onHoverEnd);
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this.checkboxWindow.addEventListener(WindowMouseEvent.OVER, this.onCheckboxHover);
            this.checkboxWindow.addEventListener(WindowMouseEvent.OUT, this.onCheckboxHoverEnd);
            this.checkboxWindow.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSelectedChange);
            this.checkboxWindow.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onSelectedChange);
            this.updateUI();
        }

        private function onSelectedChange(event:WindowEvent):void
        {
            if (!this._ignoreEvents && this._item.selectedChange != null)
            {
                this._item.selectedChange(this.checkboxWindow.Selected);
            }
        }

        private function onClick(event:WindowMouseEvent):void
        {
            if (this._disabled) { return; }
            if (this._item.hasCheckbox) { this.selected = !this.selected; }
            if (this._item.onClick != null) { this._item.onClick(); }
            if (!this._item.hasCheckbox) { this._menu.requestClose(); }
        }

        private function onHover(event:WindowMouseEvent):void { this._hovered = true; this.updateUI(); }
        private function onHoverEnd(event:WindowMouseEvent):void { this._hovered = false; this.updateUI(); }
        private function onCheckboxHover(event:WindowMouseEvent):void { this._checkboxHovered = true; this.updateUI(); }
        private function onCheckboxHoverEnd(event:WindowMouseEvent):void { this._checkboxHovered = false; this.updateUI(); }

        private function updateUI():void
        {
            this._window.background = (this._hovered || this._checkboxHovered) && !this._disabled;
            Util.disableSection(this._window, this._disabled);
        }

        public function get selected():Boolean
        {
            return this._item.hasCheckbox && this.checkboxWindow.Selected;
        }

        public function set selected(value:Boolean):void
        {
            if (!this._item.hasCheckbox || this.checkboxWindow.Selected == value) { return; }
            this._ignoreEvents = true;
            if (value) { this.checkboxWindow.select(); } else { this.checkboxWindow.unselect(); }
            this._ignoreEvents = false;
            if (this._item.selectedChange != null) { this._item.selectedChange(value); }
        }

        public function get disabled():Boolean { return this._disabled; }
        public function set disabled(value:Boolean):void { this._disabled = value; this.updateUI(); }
        public function get requestedMinWidth():int { return this.textWindow.x + this.textWindow.width; }
        public function get window():IRegionWindow { return this._window; }

        private function get textWindow():ITextWindow { return this._window.findChildByName("text") as ITextWindow; }
        private function get checkboxWindow():ICheckBoxWindow { return this._window.findChildByName("checkbox") as ICheckBoxWindow; }

        public function dispose():void
        {
            if (this._disposed) { return; }
            this._window = null;
            this._menu = null;
            this._item = null;
            this._disposed = true;
        }

        public function get disposed():Boolean { return this._disposed; }
    }
}
