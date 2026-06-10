package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

    public class TriggerOnceElement extends DefaultElement
    {
        private var _time:SliderSection;

        public function TriggerOnceElement()
        {
            super();
        }

        override public function get code():int
        {
            return WiredTriggerType.TRIGGER_ONCE;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._time = _arg_1.createSliderSection("wiredfurni.params.settime", "seconds", SliderSection.CONVERTER_PULSES, 1, 1200, 1);
            _arg_3.addElements(this._time);
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._time.value];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._time.value = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 1;
        }
    }
}
