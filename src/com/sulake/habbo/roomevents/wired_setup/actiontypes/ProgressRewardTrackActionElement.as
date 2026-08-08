package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxOptionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedTextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class ProgressRewardTrackActionElement extends DefaultElement
    {
        private var _trackId:NamedTextInputPreset;
        private var _taskId:NamedTextInputPreset;
        private var _addToExisting:CheckboxOptionPreset;
        private var _score:ValueOrVariableSection;

        override public function get code():int { return ActionTypeCodes.PROGRESS_REWARD_TRACK; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._trackId = manager.createNamedTextInput(
                new TextInputParam("", 100, null, -1, "a-zA-Z0-9_"),
                "${wiredfurni.params.reward_track.track_id}");
            this._taskId = manager.createNamedTextInput(
                new TextInputParam("", 100, null, -1, "a-zA-Z0-9_"),
                "${wiredfurni.params.reward_track.task_id}");
            var identifiers:SimpleListViewPreset = manager.createSimpleListView(
                true, [this._trackId, this._taskId]);
            var identifiersSection:SectionPreset = manager.createSection(
                "${wiredfurni.params.reward_track.progress.ids}", identifiers);
            this._addToExisting = manager.createCheckboxOption(
                new CheckboxOptionParam(
                    "${wiredfurni.params.reward_track.add_to_existing_score}"));
            var modeSection:SectionPreset = manager.createSection(
                "${wiredfurni.params.reward_track.progress.mode}", this._addToExisting);
            this._score = manager.createValueOrVariableSection(
                0, mergedSourceOptions(0),
                "${wiredfurni.params.reward_track.score}", 1, int.MAX_VALUE);
            builder.addElements(identifiersSection, modeSection, this._score);
        }

        override public function onEditStart(data:Triggerable):void
        {
            var parts:Array = data.stringData != null ? data.stringData.split("\t") : [];
            this._trackId.text = parts.length > 0 ? String(parts[0]) : "";
            this._taskId.text = parts.length > 1 ? String(parts[1]) : "";
            this._addToExisting.selected = data.intData.length > 0 &&
                int(data.intData[0]) != 0;
            var variableId:String = data.variableIds.length > 0
                ? String(data.variableIds[0]) : WiredVariable.NONE_ID;
            var option:int = data.intData.length > 1 ? int(data.intData[1]) : 0;
            var value:int = data.intData.length > 2 ? int(data.intData[2]) : 1;
            var target:int = data.intData.length > 3 ? int(data.intData[3]) : 0;
            if (option == 0) { variableId = WiredVariable.NONE_ID; }
            this._score.init(data.wiredContext.roomVariablesList,
                variableId, target, option, value);
        }

        override public function onEditInitialized():void { this._score.onEditInitialized(); }
        override public function readIntParamsFromForm():Array
        {
            return [this._addToExisting.selected ? 1 : 0, this._score.option,
                this._score.numberValue, this._score.target];
        }
        override public function readStringParamFromForm():String
        {
            return this._trackId.text + "\t" + this._taskId.text;
        }
        override public function readVariableIdsFromForm():Array
        {
            return [this._score.finalizeSelection];
        }
        override public function mergedSelections():Array { return [[0, 1]]; }
        override public function mergedSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function setMergedType(index:int, value:int):void
        {
            this._score.target = value;
        }
        override public function getMergedType(index:int):int { return this._score.target; }
        override public function getCustomSourcesForMergedType(index:int):Array
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE,
                VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function isInputSourceDisabled(index:int, type:int):Boolean
        {
            return type == WiredInputSourcePicker.MERGED_SOURCE &&
                this._score.isSourcePickingDisabled();
        }
        override public function hasCustomTypePicker(index:int):Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
