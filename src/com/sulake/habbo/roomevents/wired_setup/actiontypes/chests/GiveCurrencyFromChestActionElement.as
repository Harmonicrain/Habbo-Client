package com.sulake.habbo.roomevents.wired_setup.actiontypes.chests
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July action 45: give credits or diamonds from a selected coin chest. */
    public class GiveCurrencyFromChestActionElement extends GiveFromChestActionElement
    {
        private var _category:DropdownPreset;
        private var _categorySection:SectionPreset;

        override public function get code():int { return ActionTypeCodes.GIVE_CURRENCY_FROM_CHEST; }

        override public function readIntParamsFromForm():Array
        {
            var values:Array = super.readIntParamsFromForm();
            values.push(this._category.selectedId);
            return values;
        }

        override public function onEditStart(definition:Triggerable):void
        {
            super.onEditStart(definition);
            this._category.selectedId = definition.intData.length > 5 ?
                int(definition.intData[5]) : 11;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            var options:Vector.<ExpandableDropdownOption> = new <ExpandableDropdownOption>[
                new ExpandableDropdownOption(11, "${wiredfurni.params.earnings_category.11}"),
                new ExpandableDropdownOption(13, "${wiredfurni.params.earnings_category.13}")
            ];
            this._category = manager.createDropdown(
                new DropdownParam("${wiredfurni.params.earnings_category}", options));
            this._categorySection = manager.createSection(
                "${wiredfurni.params.earnings_category}", this._category, SectionParam.COLLAPSED);
            super.buildInputs(manager, style, builder);
        }

        override protected function finalizeBuilding(builder:WiredUIBuilder):void
        {
            super.finalizeBuilding(builder);
            builder.addElements(this._categorySection);
        }
    }
}
