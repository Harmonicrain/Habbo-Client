package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class RewardRowPreset extends WiredUIPreset
    {
        private var _row:SimpleListViewPreset;
        private var _container:IWindowContainer;
        private var _badgeCheckbox:ICheckBoxWindow;
        private var _codeInput:TextInputPreset;
        private var _probabilityInput:TextInputPreset;
        private var _rowSpacing:int;
        private var _probabilityEnabled:Boolean = true;

        public function RewardRowPreset(roomEvents:HabboUserDefinedRoomEvents,
                                        presetManager:PresetManager,
                                        style:WiredStyle)
        {
            super(roomEvents, presetManager, style);
            this._badgeCheckbox = style.createCheckboxView();
            this._codeInput = presetManager.createTextInput(new TextInputParam(
                "", 100, null, -1, null, true, "Product code or badge code"));
            this._probabilityInput = presetManager.createTextInput(new TextInputParam(
                "", 3, null, 50, "0-9", true,
                "Chance to get this reward. Value should be a number between 1 and 100"));
            this._rowSpacing = style.genericHorizontalSpacing;
            this._probabilityInput.disabled = !this._probabilityEnabled;
            this._row = presetManager.createSimpleListView(false, [
                wrapWindow(this._badgeCheckbox, true),
                this._codeInput,
                this._probabilityInput
            ]);
            this._row.spacing = this._rowSpacing;
            this._container = presetManager.createLayout("container_view") as IWindowContainer;
            this._container.addChild(this._row.window);
        }

        public function get code():String
        {
            return this._codeInput.text;
        }

        public function set code(value:String):void
        {
            this._codeInput.text = value == null ? "" : value;
        }

        public function get probabilityText():String
        {
            return this._probabilityInput.text;
        }

        public function set probabilityText(value:String):void
        {
            this._probabilityInput.text = value == null ? "" : value;
        }

        public function get isBadge():Boolean
        {
            return this._badgeCheckbox.Selected;
        }

        public function set isBadge(value:Boolean):void
        {
            Util.select(this._badgeCheckbox, value);
        }

        public function clear():void
        {
            this.code = "";
            this.probabilityText = "";
            this.isBadge = false;
        }

        public function setProbabilityEnabled(value:Boolean):void
        {
            this._probabilityEnabled = value;
            this._probabilityInput.disabled = !value;
        }

        override public function resizeToWidth(width:int):void
        {
            super.resizeToWidth(width);
            this._container.width = width;
            this._row.resizeToWidth(width);
            this._container.height = this._row.window.height;
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override protected function get childPresets():Array
        {
            return [this._row];
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
            this._row = null;
            this._badgeCheckbox = null;
            this._codeInput = null;
            this._probabilityInput = null;
        }
    }
}
