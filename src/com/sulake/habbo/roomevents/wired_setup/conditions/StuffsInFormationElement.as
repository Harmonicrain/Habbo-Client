package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class StuffsInFormationElement extends DefaultElement
    {
        private var _size:SliderSection;
        private var _formation:RadioGroupPreset;

        public function StuffsInFormationElement()
        {
            super();
        }

        override public function get code():int
        {
            return ConditionCodes.STUFFS_IN_FORMATION;
        }

        override public function get negativeCode():int
        {
            return ConditionCodes.NOT_STUFFS_IN_FORMATION;
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
            this._size = _arg_1.createSliderSection("wiredfurni.params.requiredformationsize", "furnis", new SliderValueEcho(), 2, 10, 3);
            this._formation = _arg_1.createRadioGroup([new RadioButtonParam(0, l("formation.0")), new RadioButtonParam(1, l("formation.1"))], null, 2);
            _arg_3.addElements(this._size, _arg_1.createSection(l("formation"), this._formation));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._size.value, this._formation.selected];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._size.value = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 3;
            this._formation.selected = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 0;
        }
    }
}
