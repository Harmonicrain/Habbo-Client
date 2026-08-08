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

    public class FurnisHaveAvatarsConditionElement extends DefaultElement
    {
        private var _quantifier:RadioGroupPreset;

        override public function get code():int
        {
            return ConditionCodes.FURNIS_HAVE_AVATARS;
        }

        override public function get negativeCode():int
        {
            return ConditionCodes.FURNI_NOT_HAVE_HABBO;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function get requiresFurniSelection():Boolean
        {
            return true;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._quantifier = _arg_1.createRadioGroup([new RadioButtonParam(0, l("requireall.0")), new RadioButtonParam(1, l("requireall.1"))]);
            _arg_3.addElements(_arg_1.createSection(l("requireall"), this._quantifier));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._quantifier.selected];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._quantifier.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
        }
    }
}
