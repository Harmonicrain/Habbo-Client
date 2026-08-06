package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class UserCountInConditionElement extends DefaultElement
    {
        private var _min:SliderSection;
        private var _max:SliderSection;

        public function UserCountInConditionElement()
        {
            super();
        }

        override public function get code():int
        {
            return ConditionCodes.USER_COUNT_IN;
        }

        override public function get negativeCode():int
        {
            return ConditionCodes.NOT_USER_COUNT_IN;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._min = _arg_1.createSliderSection("wiredfurni.params.usercountmin", "value", new SliderValueEcho(), 0, 125, 1, false);
            this._max = _arg_1.createSliderSection("wiredfurni.params.usercountmax", "value", new SliderValueEcho(), 0, 125, 1, false);
            _arg_3.addElements(this._min, this._max);
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._min.value, this._max.value];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._min.value = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 1;
            this._max.value = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 1;
        }
    }
}
