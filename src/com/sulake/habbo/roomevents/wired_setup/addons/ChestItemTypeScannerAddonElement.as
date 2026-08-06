package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ChooseVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 18: write an opened chest's item type into a context variable. */
    public class ChestItemTypeScannerAddonElement extends DefaultElement
    {
        private var _variable:ChooseVariableSection;
        private var _mode:RadioGroupPreset;

        override public function get code():int { return AddonCodes.CHEST_ITEM_TYPE_SCANNER; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.CHESTS |
                WiredCapabilityCodes.CHEST_WIRED | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        private function variableSelectionFilter(value:WiredVariable):Boolean
        {
            return value != null && value.hasValue && value.canCreateAndDelete && value.canWriteValue;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._variable = manager.createChooseVariableSection(0, null,
                this.variableSelectionFilter, null);
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("chest_item_type_scanner.0")),
                new RadioButtonParam(1, this.l("chest_item_type_scanner.1"))
            ]);
            builder.addElements(manager.createUsageInfoSection(this.l("chest_item_type_scanner.info")),
                this._variable, manager.createSection(this.l("chest_item_type_scanner"), this._mode));
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var variableId:String = definition.variableIds.length > 0 ? String(definition.variableIds[0]) : null;
            this._variable.init(definition.wiredContext.roomVariablesList, variableId,
                VariableExtraSourceTypes.CONTEXT_SOURCE);
            this._mode.selected = definition.intData.length > 0 ? int(definition.intData[0]) : 0;
        }

        override public function onEditInitialized():void { this._variable.onEditInitialized(); }
        override public function readVariableIdsFromForm():Array { return [this._variable.finalizeSelection]; }
        override public function readIntParamsFromForm():Array { return [this._mode.selected]; }
        override public function furniSelectionTitle(index:int):String
        {
            return index == 0 ? "wiredfurni.params.sources.furni.title.item_types" :
                "wiredfurni.params.sources.furni.title.chests";
        }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
        override public function advancedAlwaysVisible():Boolean { return true; }
    }
}
