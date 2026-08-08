package com.sulake.habbo.ui.widget.furniture.areahide
{
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.SaveAreaHideMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.ToggleAreaHideMessageComposer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.room.IRoomAreaSelectionManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureAreaHideWidgetHandler;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.window.IHabboWindowManager;

    public class AreaHideFurniWidget extends RoomWidgetBase
    {
        private static const AUTO_SAVE:Boolean = true;
        private static const TEXT_NAMES:Array = ["hidearea_info", "areaselection_title", "areaselection_info", "options_title", "invisibility_txt", "invisibility_info", "wallitems_txt", "invert_txt", "invert_info"];

        private var _selection:IRoomAreaSelectionManager;
        private var _window:IFrameWindow;
        private var _furniId:int = -1;
        private var _on:Boolean;
        private var _rootX:int;
        private var _rootY:int;
        private var _width:int;
        private var _length:int;
        private var _changed:Boolean;
        private var _selecting:Boolean;
        private var _selectionActive:Boolean;

        public function AreaHideFurniWidget(k:IRoomWidgetHandler, windowManager:IHabboWindowManager, assets:IAssetLibrary, localizations:IHabboLocalizationManager, roomEngine:IRoomEngine)
        {
            super(k, windowManager, assets, localizations);
            this.handler.widget = this;
            this._selection = roomEngine.areaSelectionManager;
        }

        public function get handler():FurnitureAreaHideWidgetHandler
        {
            return _handler as FurnitureAreaHideWidgetHandler;
        }

        override public function dispose():void
        {
            this.destroyWindow();
            super.dispose();
        }

        public function open(k:int, on:Boolean, rootX:int, rootY:int, width:int, length:int, invisibility:Boolean, wallItems:Boolean, invert:Boolean):void
        {
            this._furniId = k;
            this._on = on;
            this._rootX = rootX;
            this._rootY = rootY;
            this._width = width;
            this._length = length;
            this.createWindow();
            this.invisibilityCheckbox.Selected = invisibility;
            this.wallItemsCheckbox.Selected = wallItems;
            this.invertCheckbox.Selected = invert;
            this._changed = false;
            this._selecting = false;
            this.updateAreaSelecting();
            this.refreshUI();
        }

        public function updateStatus(k:int, on:Boolean):void
        {
            if (((this._window != null) && (this._window.visible) && (k == this._furniId) && (on != this._on)))
            {
                this._on = on;
                this.updateAreaSelecting();
                this.refreshUI();
            }
        }

        private function createWindow():void
        {
            if (this._window == null)
            {
                this._window = IFrameWindow(windowManager.buildFromXML(assets.getAssetByName("area_hide_ui_xml").content as XML));
                this._window.procedure = this.windowProcedure;
                this.invisibilityCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSettingsChanged);
                this.invisibilityCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onSettingsChanged);
                this.wallItemsCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSettingsChanged);
                this.wallItemsCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onSettingsChanged);
                this.invertCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSettingsChanged);
                this.invertCheckbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED, this.onSettingsChanged);
                this.applyButton.visible = !AUTO_SAVE;
                this._window.center();
            }
            else
            {
                this._window.visible = true;
            }
        }

        private function hideWindow():void
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
            if (this._selectionActive)
            {
                this._selection.deactivate();
                this._selectionActive = false;
            }
            this._furniId = -1;
        }

        private function destroyWindow():void
        {
            this.hideWindow();
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        private function updateAreaSelecting():void
        {
            if (!this._on)
            {
                if (!this._selectionActive)
                {
                    this._selectionActive = this._selection.activate(this.onAreaSelected, "highlight_darken");
                }
                if (this._selectionActive)
                {
                    this._selection.setHighlight(this._rootX, this._rootY, this._width, this._length);
                }
            }
            else if (this._selectionActive)
            {
                this._selection.deactivate();
                this._selectionActive = false;
            }
        }

        private function refreshUI():void
        {
            if (this._on)
            {
                this.onOffButton.caption = localizations.getLocalization("widget.areahide.button.off");
                this.disableContents(true);
            }
            else
            {
                this.onOffButton.caption = localizations.getLocalization("widget.areahide.button.on");
                this.disableContents(false);
                this.setDisabled(!this._changed, this.applyButton);
                this.setDisabled((this._selecting || !this._selectionActive), this.selectButton);
                this.setDisabled(!this._selectionActive, this.clearButton);
            }
        }

        private function disableContents(k:Boolean):void
        {
            this.setDisabled(k, this.selectButton);
            this.setDisabled(k, this.clearButton);
            this.setDisabled(k, this.applyButton);
            this.setDisabled(k, this.invisibilityCheckbox);
            this.setDisabled(k, this.wallItemsCheckbox);
            this.setDisabled(k, this.invertCheckbox);
            this.invisibilityCheckbox.blend = ((k) ? 0.5 : 1);
            this.wallItemsCheckbox.blend = ((k) ? 0.5 : 1);
            this.invertCheckbox.blend = ((k) ? 0.5 : 1);
            for each (var name:String in TEXT_NAMES)
            {
                ITextWindow(this._window.findChildByName(name)).blend = ((k) ? 0.5 : 1);
            }
        }

        private function setDisabled(k:Boolean, window:IWindow):void
        {
            if (k)
            {
                window.disable();
            }
            else
            {
                window.enable();
            }
        }

        private function onAreaSelected(k:int, y:int, width:int, length:int):void
        {
            this._rootX = k;
            this._rootY = y;
            this._width = width;
            this._length = length;
            this._selecting = false;
            this.onSettingsChanged(null);
        }

        private function onSettingsChanged(k:WindowEvent):void
        {
            this._changed = true;
            if (AUTO_SAVE)
            {
                this.updateData();
            }
            this.refreshUI();
        }

        private function updateData():void
        {
            this.handler.container.connection.send(new SaveAreaHideMessageComposer(this._furniId, this._rootX, this._rootY, this._width, this._length, this.invisibilityCheckbox.Selected, this.wallItemsCheckbox.Selected, this.invertCheckbox.Selected));
            this._changed = false;
        }

        private function windowProcedure(k:WindowEvent, window:IWindow):void
        {
            if (((window != null) && (k.type == WindowMouseEvent.CLICK)))
            {
                switch (window.name)
                {
                    case "apply_button":
                        if (this._changed && !AUTO_SAVE)
                        {
                            this.updateData();
                        }
                        return;
                    case "on_off_button":
                        this.handler.container.connection.send(new ToggleAreaHideMessageComposer(this._furniId));
                        return;
                    case "select_button":
                        this._selecting = true;
                        this._selection.startSelecting();
                        this.refreshUI();
                        return;
                    case "clear_button":
                        this._selection.clearHighlight();
                        return;
                    case "header_button_close":
                        this.hideWindow();
                        return;
                }
            }
        }

        private function get selectButton():IButtonWindow { return this._window.findChildByName("select_button") as IButtonWindow; }
        private function get clearButton():IButtonWindow { return this._window.findChildByName("clear_button") as IButtonWindow; }
        private function get applyButton():IButtonWindow { return this._window.findChildByName("apply_button") as IButtonWindow; }
        private function get onOffButton():IButtonWindow { return this._window.findChildByName("on_off_button") as IButtonWindow; }
        private function get invisibilityCheckbox():ICheckBoxWindow { return this._window.findChildByName("invisiblity_checkbox") as ICheckBoxWindow; }
        private function get wallItemsCheckbox():ICheckBoxWindow { return this._window.findChildByName("wallitems_checkbox") as ICheckBoxWindow; }
        private function get invertCheckbox():ICheckBoxWindow { return this._window.findChildByName("invert_checkbox") as ICheckBoxWindow; }
    }
}
