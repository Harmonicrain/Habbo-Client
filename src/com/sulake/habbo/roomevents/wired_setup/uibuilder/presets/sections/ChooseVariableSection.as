package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July target-aware variable picker section, optionally linked to a merged source slot. */
    public class ChooseVariableSection extends AbstractSectionPreset implements ISourceTypeListener
    {
        private var _picker:VariablePickerPreset;
        private var _mergedSelectionId:int;
        private var _target:int;

        public function ChooseVariableSection(roomEvents:HabboUserDefinedRoomEvents,
                                              manager:PresetManager, style:WiredStyle,
                                              mergedSelectionId:int, sourceOptions:Array,
                                              filter:Function, onSelected:Function,
                                              title:String = null)
        {
            super(roomEvents, manager, style);
            this._mergedSelectionId = mergedSelectionId;
            var sectionParam:SectionParam = sourceOptions == null ? null :
                new SectionParam(new SourceTypeSelectorParam(sourceOptions, this));
            this._picker = manager.createVariablePicker(filter, onSelected);
            this.initializeSection(title == null ? this.l("variables.variable_selection") : title,
                this._picker, sectionParam);
        }

        public function init(variables:AllVariablesInRoom, selectedId:String, target:int):void
        {
            this._picker.init(variables, selectedId, target);
            this._target = target;
        }

        public function onEditInitialized():void
        {
            var selector:* = this.getSourceTypeSelector();
            if (selector != null) { selector.select(this._target); }
        }

        public function set target(value:int):void
        {
            this._target = value;
            this._picker.variableTarget = value;
        }
        public function get target():int { return this._target; }
        public function get finalizeSelection():String { return this._picker.finalizeSelection; }
        public function get selected():WiredVariable { return this._picker.selected; }

        public function set sourceType(value:int):void
        {
            if (this._mergedSelectionId != -1)
            {
                this._roomEvents.wiredCtrl.setMergedSourceType(this._mergedSelectionId, value);
            }
            else
            {
                this.target = value;
            }
        }
    }
}
