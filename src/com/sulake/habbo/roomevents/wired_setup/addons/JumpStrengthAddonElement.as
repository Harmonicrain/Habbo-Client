package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 22: numeric or variable-driven movement curve. */
    public class JumpStrengthAddonElement extends DefaultElement
    {
        private var _strength:ValueOrVariableSection;
        override public function get code():int { return AddonCodes.JUMP_STRENGTH; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC; }
        override public function buildInputs(m:PresetManager, s:WiredStyle, b:WiredUIBuilder):void
        {
            this._strength = m.createValueOrVariableSection(0, this.mergedSourceOptions(0), this.l("jump_strength"), -1000, 1000);
            b.addElements(this._strength);
        }
        override public function onEditStart(d:Triggerable):void
        {
            var v:Array=d.intData; var id:String=d.variableIds.length>0?String(d.variableIds[0]):null;
            var option:int=v.length>0?int(v[0]):0; var value:int=v.length>1?int(v[1]):80; var target:int=v.length>2?int(v[2]):0;
            if(option==0) id=WiredVariable.NONE_ID; else value=80;
            this._strength.init(d.wiredContext.roomVariablesList,id,target,option,value);
        }
        override public function onEditInitialized():void { this._strength.onEditInitialized(); }
        override public function readIntParamsFromForm():Array { return [this._strength.option,this._strength.numberValue,this._strength.target]; }
        override public function readVariableIdsFromForm():Array { return [this._strength.finalizeSelection]; }
        override public function isInputSourceDisabled(t:int,i:int):Boolean { return t==WiredInputSourcePicker.MERGED_SOURCE && this._strength.isSourcePickingDisabled(); }
        override public function mergedSelectionTitle(i:int):String { return "wiredfurni.params.sources.merged.title.variables_reference"; }
        override public function mergedSelections():Array { return [[0,0]]; }
        override public function setMergedType(i:int,v:int):void { this._strength.target=v; }
        override public function getMergedType(i:int):int { return this._strength.target; }
        override public function getCustomSourcesForMergedType(i:int):Array { return [VariableExtraSourceTypes.GLOBAL_SOURCE,VariableExtraSourceTypes.CONTEXT_SOURCE]; }
        override public function hasCustomTypePicker(i:int):Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
