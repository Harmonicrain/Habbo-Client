package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class ProgressAchievementActionElement extends DefaultElement
    {
        private var _achievement:DropdownPreset;
        private var _mode:RadioGroupPreset;
        private var _value:ValueOrVariableSection;
        override public function get code():int { return ActionTypeCodes.PROGRESS_ACHIEVEMENT; }
        override public function get negativeCode():int { return ActionTypeCodes.PROGRESS_ACHIEVEMENT; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function buildInputs(m:PresetManager,s:WiredStyle,b:WiredUIBuilder):void
        {
            this._achievement=m.createDropdown(new DropdownParam(this.l("progress_achievement.name")));
            this._mode=m.createRadioGroup([new RadioButtonParam(1,this.l("progress_achievement.mode.1")),new RadioButtonParam(0,this.l("progress_achievement.mode.0"))]);
            this._value=m.createValueOrVariableSection(0,this.mergedSourceOptions(0),this.l("progress_achievement.score"),0,2147483647);
            b.addElements(m.createSection(this.l("progress_achievement.name"),this._achievement),m.createSection(this.l("progress_achievement.mode"),this._mode),this._value);
        }
        override public function onEditStart(d:Triggerable):void
        {
            var options:Vector.<ExpandableDropdownOption>=new Vector.<ExpandableDropdownOption>();
            for each(var name:String in this.roomEvents.achievementsInRoom) options.push(new ExpandableDropdownOption(options.length,name));
            this._achievement.reinit(options,-1);
            for each(var option:ExpandableDropdownOption in options) if(option.displayString==d.stringData)this._achievement.selectedId=option.id;
            this._mode.selected=d.intData.length>0?int(d.intData[0]):1;
            this._value.init(d.wiredContext.roomVariablesList,d.variableIds.length>0?String(d.variableIds[0]):null,d.intData.length>3?int(d.intData[3]):0,d.intData.length>1?int(d.intData[1]):0,d.intData.length>2?int(d.intData[2]):0);
        }
        override public function onEditInitialized():void { this._value.onEditInitialized(); }
        override public function readIntParamsFromForm():Array{return [this._mode.selected,this._value.option,this._value.numberValue,this._value.target];}
        override public function readStringParamFromForm():String{return this._achievement.selected==null?"":this._achievement.selected.displayString;}
        override public function readVariableIdsFromForm():Array{return [this._value.finalizeSelection];}
        override public function mergedSelections():Array{return [[0,1]];}
        override public function setMergedType(i:int,v:int):void{this._value.target=v;}
        override public function getMergedType(i:int):int{return this._value.target;}
        override public function getCustomSourcesForMergedType(i:int):Array{return [VariableExtraSourceTypes.GLOBAL_SOURCE,VariableExtraSourceTypes.CONTEXT_SOURCE];}
        override public function isInputSourceDisabled(i:int,t:int):Boolean{return t==WiredInputSourcePicker.MERGED_SOURCE&&this._value.isSourcePickingDisabled();}
        override public function hasCustomTypePicker(i:int):Boolean{return true;}
        override public function get forceHidePickFurniInstructions():Boolean{return true;}
    }
}
