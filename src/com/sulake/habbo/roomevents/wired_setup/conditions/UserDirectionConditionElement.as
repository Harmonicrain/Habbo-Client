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

    public class UserDirectionConditionElement extends DefaultElement
    {
        private var _direction:RadioGroupPreset;

        override public function get code():int { return ConditionCodes.USER_DIRECTION; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            var _local_1:Array = [];
            for (var _local_2:int = 0; _local_2 < 8; _local_2++) { _local_1.push(this.iconButton(_local_2, "move_" + _local_2)); }
            this._direction = _arg_1.createRadioGroup(_local_1, null, 4);
            _arg_3.addElements(_arg_1.createSection(l("direction"), this._direction));
        }

        override public function readIntParamsFromForm():Array { return [this._direction.selected]; }
        override public function onEditStart(_arg_1:Triggerable):void { this._direction.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0; }

        private function iconButton(_arg_1:int, _arg_2:String):RadioButtonParam
        {
            var _local_3:RadioButtonParam = new RadioButtonParam(_arg_1, "");
            _local_3.iconAssetName = _arg_2;
            return _local_3;
        }
    }
}
