package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

    /**
     * July AIR trigger 20: fires for every state, or only when the furni
     * changes to the state captured when this Wired was saved.
     */
    public class StateChangeTriggerElement extends DefaultElement
    {
        private var _stateMode:RadioGroupPreset;

        override public function get code():int
        {
            return WiredTriggerType.STATE_CHANGE;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function get hasStateSnapshot():Boolean
        {
            return true;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._stateMode = manager.createRadioGroup([
                new RadioButtonParam(1, l("state_trigger.1")),
                new RadioButtonParam(0, l("state_trigger.0"))
            ]);
            builder.addElements(manager.createSection(l("select_options"), this._stateMode));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._stateMode.selected];
        }

        override public function onEditStart(definition:Triggerable):void
        {
            this._stateMode.selected = definition.intData.length > 0
                ? int(definition.intData[0])
                : 1;
        }
    }
}
