package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableTypes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ChooseVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.wired_setup.variables.VariableTargets;

    /** July ordinary Place Furni editor. Wire payload is the July ten-int/two-variable contract. */
    public class PlaceFurniActionElement extends DefaultElement
    {
        private var _location:RadioGroupPreset;
        private var _altitude:RadioGroupPreset;
        private var _offsets:CheckboxGroupPreset;
        private var _x:NumberInputPreset;
        private var _y:NumberInputPreset;
        private var _z:NumberInputPreset;
        private var _spawn:CheckboxGroupPreset;
        private var _spawnSection:SectionPreset;
        private var _spawnVariable:ChooseVariableSection;
        private var _reference:ValueOrVariableSection;
        private var _targetIsUser:Boolean;

        override public function get code():int { return ActionTypeCodes.PLACE_FURNI; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get hasStateSnapshot():Boolean { return true; }

        private function filterSpawnVariable(value:WiredVariable):Boolean
        {
            return value != null && value.variableTarget == VariableTargets.FURNI &&
                value.canCreateAndDelete && value.variableType == WiredVariableTypes.USER_CREATED;
        }

        override public function buildInputs(m:PresetManager, style:WiredStyle, b:WiredUIBuilder):void
        {
            var soft:TextParam = new TextParam(1);
            soft.textColor = style.softTextColor;
            this._location = m.createRadioGroup([
                new RadioButtonParam(0, l("place_furni.target_location.0"), null,
                    m.createText(l("place_furni.target_location.0.info"), soft)),
                new RadioButtonParam(1, l("place_furni.target_location.1"))], this.onLocation);
            this._altitude = m.createRadioGroup([
                new RadioButtonParam(0, l("place_furni.target_altitude.0")),
                new RadioButtonParam(1, l("place_furni.target_altitude.1")),
                new RadioButtonParam(2, l("place_furni.target_altitude.2"))], this.onAltitude);
            this._x = m.createNumberInput(new NumberInputParam(0, -64, 64));
            this._y = m.createNumberInput(new NumberInputParam(0, -64, 64));
            this._z = m.createNumberInput(new NumberInputParam(0, -8000, 8000));
            this._offsets = m.createCheckboxGroup([
                new CheckboxOptionParam(l("place_furni.offsets.x"), 0, this._x),
                new CheckboxOptionParam(l("place_furni.offsets.y"), 1, this._y),
                new CheckboxOptionParam(l("place_furni.offsets.altitude"), 2, this._z)]);
            this._spawnVariable = m.createChooseVariableSection(-1, null, this.filterSpawnVariable, this.onSpawnVariable);
            this._reference = m.createValueOrVariableSection(1, this.mergedSourceOptions(1),
                l("place_furni.spawn_with_value"), -2147483648, 2147483647);
            this._spawn = m.createCheckboxGroup([new CheckboxOptionParam(
                l("place_furni.spawn_with_variable"), 0, null,
                m.createSimpleListView(true, [this._spawnVariable, this._reference]))], this.onSpawn);
            this._spawnSection = m.createSection(l("place_furni.spawn_with_variable"),
                this._spawn, SectionParam.COLLAPSED);
            b.addElements(m.createUsageInfoSection(l("place_furni.usage_info")),
                m.createSection(l("place_furni.target_location"), this._location, SectionParam.EXPANDED_WITH_TOGGLE),
                m.createSection(l("place_furni.target_altitude"), this._altitude, SectionParam.EXPANDED_WITH_TOGGLE),
                m.createSection(l("place_furni.offsets"), this._offsets, SectionParam.COLLAPSED),
                this._spawnSection);
            this.updateReference();
        }

        override public function onEditStart(d:Triggerable):void
        {
            var a:Array = d.intData;
            this._targetIsUser = a.length > 0 && a[0] == 1;
            this._location.selected = a.length > 1 ? a[1] : 0;
            this._altitude.selected = a.length > 2 ? a[2] : 0;
            this.setOffset(0, this._x, a.length > 3 ? a[3] : 0);
            this.setOffset(1, this._y, a.length > 4 ? a[4] : 0);
            this.setOffset(2, this._z, a.length > 5 ? a[5] : 0);
            this._spawn.get(0).selected = a.length > 6 && a[6] == 1;
            this._spawnVariable.init(d.wiredContext.roomVariablesList,
                d.variableIds.length > 0 ? d.variableIds[0] : WiredVariable.NONE_ID, VariableTargets.FURNI);
            this._reference.init(d.wiredContext.roomVariablesList,
                d.variableIds.length > 1 ? d.variableIds[1] : WiredVariable.NONE_ID,
                a.length > 9 ? a[9] : 0, a.length > 7 ? a[7] : 0, a.length > 8 ? a[8] : 0);
            this.updateReference();
            this._spawnSection.updateDisabledState();
        }

        override public function onEditInitialized():void
        {
            this._spawnVariable.onEditInitialized();
            this._reference.onEditInitialized();
        }

        override public function readIntParamsFromForm():Array
        {
            var enabled:Boolean = this._spawn.get(0).selected && !this._reference.disabled;
            return [this._targetIsUser ? 1 : 0, this._location.selected, this._altitude.selected,
                this.offset(0, this._x), this.offset(1, this._y), this.offset(2, this._z),
                this._spawn.get(0).selected ? 1 : 0, enabled ? this._reference.option : 0,
                enabled ? this._reference.numberValue : 0, this._reference.target];
        }

        override public function readVariableIdsFromForm():Array
        {
            var enabled:Boolean = this._spawn.get(0).selected && !this._reference.disabled;
            return [this._spawn.get(0).selected ? this._spawnVariable.finalizeSelection : WiredVariable.NONE_ID,
                enabled && this._reference.option == 1 ? this._reference.finalizeSelection : WiredVariable.NONE_ID];
        }

        override public function mergedSelections():Array { return [[1, 0], [2, 1]]; }
        override public function setMergedType(i:int, value:int):void
        {
            if (i == 0) this._targetIsUser = value == WiredInputSourcePicker.USER_SOURCE;
            else this._reference.target = value;
        }
        override public function getMergedType(i:int):int
        {
            return i == 0 ? (this._targetIsUser ? WiredInputSourcePicker.USER_SOURCE : WiredInputSourcePicker.FURNI_SOURCE) : this._reference.target;
        }
        override public function isInputSourceDisabled(i:int, type:int):Boolean
        {
            if (type != WiredInputSourcePicker.MERGED_SOURCE) return false;
            return i == 0 ? !(this._location.selected == 1 || this._altitude.selected == 2) :
                !this._spawn.get(0).selected || this._reference.disabled || this._reference.isSourcePickingDisabled();
        }
        override public function hasCustomTypePicker(i:int):Boolean { return i == 1; }
        override public function getCustomSourcesForMergedType(i:int):Array
        {
            return i == 1 ? [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE] : [];
        }
        override public function furniSelectionTitle(i:int):String { return "wiredfurni.params.sources.furni.title.place_furni"; }
        override public function mergedSelectionTitle(i:int):String
        {
            return i == 0 ? "wiredfurni.params.sources.merged.title.custom_target" :
                "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
        override public function get widthModifier():Number { return 1.2; }

        private function offset(i:int, input:NumberInputPreset):int { return this._offsets.get(i).selected ? input.value : 0; }
        private function setOffset(i:int, input:NumberInputPreset, value:int):void
        {
            input.value = value; this._offsets.get(i).selected = value != 0;
        }
        private function onLocation(value:int):void { this.updateSources(); }
        private function onAltitude(value:int):void { this.updateSources(); }
        private function onSpawn(i:int, selected:Boolean):void { this.updateReference(); }
        private function onSpawnVariable(value:WiredVariable):void { this.updateReference(); }
        private function updateSources():void { roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 0); }
        private function updateReference():void
        {
            var selected:WiredVariable = this._spawnVariable.selected;
            this._reference.disabled = !this._spawn.get(0).selected || selected == null || !selected.hasValue;
            roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 1);
        }
    }
}
