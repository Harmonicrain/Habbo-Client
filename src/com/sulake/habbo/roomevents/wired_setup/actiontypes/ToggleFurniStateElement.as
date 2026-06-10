package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class ToggleFurniStateElement extends DefaultElement
    {
        private var _mode:RadioGroupPreset;

        override public function get code():int
        {
            return ActionTypeCodes.TOGGLE_FURNI_STATE;
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
            this._mode = _arg_1.createRadioGroup([new RadioButtonParam(0, l("togglefurni.0")), new RadioButtonParam(1, l("togglefurni.1"))]);
            _arg_3.addElements(_arg_1.createSection(l("togglefurni"), this._mode));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._mode.selected];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._mode.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
        }
    }
}
