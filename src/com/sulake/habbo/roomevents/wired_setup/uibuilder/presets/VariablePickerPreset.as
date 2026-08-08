package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July searchable, target-aware variable picker. */
    public class VariablePickerPreset extends WiredUIPreset
    {
        private var _picker:NewVariablePicker;

        public function VariablePickerPreset(roomEvents:HabboUserDefinedRoomEvents,
                                             presetManager:PresetManager,
                                             style:WiredStyle,
                                             filter:Function = null,
                                             onSelected:Function = null)
        {
            super(roomEvents, presetManager, style);
            this._picker = new NewVariablePicker(roomEvents,
                presetManager.createLayout("search_tree_dropdown") as IWindowContainer,
                filter, onSelected, style);
        }

        public function init(variables:AllVariablesInRoom, selectedId:String, variableTarget:int):void
        {
            this._picker.init(variables, selectedId, variableTarget);
        }

        public function set variableTarget(value:int):void { this._picker.variableTarget = value; }
        public function get selected():WiredVariable { return this._picker.selected; }

        public function get finalizeSelection():String
        {
            var value:WiredVariable = this.selected;
            this._picker.finalize();
            // July uses optional chaining here. Its newer wire encoder preserves
            // the null slot, while the 2016 Eva encoder silently omits null array
            // entries and corrupts every following field. Use July's explicit
            // no-variable id so the declared variableIds count remains truthful.
            return value == null ? WiredVariable.NONE_ID : value.variableId;
        }

        override public function resizeToWidth(value:int):void
        {
            super.resizeToWidth(value);
            this._picker.width = value;
        }

        override public function get window():IWindow { return this._picker.window; }

        override public function dispose():void
        {
            if (disposed) { return; }
            super.dispose();
            this._picker.dispose();
            this._picker = null;
        }
    }
}
