package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class PerformingActionConditionElement extends DefaultElement
    {
        private var _action:RadioGroupPreset;

        override public function get code():int { return ConditionCodes.PERFORMING_ACTION; }
        override public function get negativeCode():int { return ConditionCodes.NOT_PERFORMING_ACTION; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._action = _arg_1.createRadioGroup([new RadioButtonParam(0, l("action.0")), new RadioButtonParam(1, l("action.1")), new RadioButtonParam(2, l("action.2")), new RadioButtonParam(3, l("action.3"))]);
            _arg_3.addElements(_arg_1.createSection(l("action"), this._action));
        }

        override public function readIntParamsFromForm():Array { return [this._action.selected]; }
        override public function onEditStart(_arg_1:Triggerable):void { this._action.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0; }
    }
}
