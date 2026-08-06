package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextualButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July trigger 26: a selected contract transaction failed. */
    public class TransactionFailedTriggerElement extends DefaultElement
    {
        override public function get code():int { return WiredTriggerType.TRANSACTION_FAILED; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int
        {
            return WiredCapabilityCodes.CHESTS | WiredCapabilityCodes.CHEST_WIRED |
                WiredCapabilityCodes.CONTRACTS | WiredCapabilityCodes.VARIABLES;
        }
        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            var button:TextualButtonPreset = manager.createTextualButtonPreset(
                this.loc("wiredfurni.view_in_menu"), this.viewInMenu);
            builder.addElements(manager.createUsageInfoSection(
                "${wiredfurni.params.transaction_failed.usage_info}"), button.alignCenter());
        }
        private function viewInMenu():void
        {
            this.roomEvents.context.createLinkEvent(
                "wiredmenu/open/variable_overview/@event.transaction_failed.reason");
        }
    }
}
