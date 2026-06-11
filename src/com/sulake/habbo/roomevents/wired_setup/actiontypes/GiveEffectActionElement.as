package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class GiveEffectActionElement extends DefaultElement
    {
        private var _effectId:NumberInputPreset;
        private var _priority:NumberInputPreset;
        private var _type:RadioGroupPreset;

        override public function get code():int
        {
            return ActionTypeCodes.GIVE_EFFECT;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._effectId = _arg_1.createNumberInput(new NumberInputParam(13, 0, 10000));
            this._priority = _arg_1.createNumberInput(new NumberInputParam(2, 0, 2));
            this._type = _arg_1.createRadioGroup([
                new RadioButtonParam(0, "${wiredfurni.params.give_effect.type.0}"),
                new RadioButtonParam(1, "${wiredfurni.params.give_effect.type.1}")
            ], null, 2);
            _arg_3.addElements(
                _arg_1.createSection("${wiredfurni.params.give_effect.id}", this._effectId),
                _arg_1.createSection("${wiredfurni.params.give_effect.priority}", this._priority),
                _arg_1.createSection("${wiredfurni.params.give_effect.type}", this._type)
            );
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._effectId.value, this._priority.value, this._type.selected];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._effectId.value = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 13;
            this._priority.value = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 2;
            this._type.selected = (_arg_1.intData.length > 2 && _arg_1.intData[2] != 0) ? 1 : 0;
        }
    }
}
