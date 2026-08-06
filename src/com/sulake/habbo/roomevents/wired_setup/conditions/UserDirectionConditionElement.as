package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    public class UserDirectionConditionElement extends DefaultElement
    {
        private var _directions:CheckboxGroupPreset;

        override public function get code():int { return ConditionCodes.USER_DIRECTION; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            var _local_1:Array = [];
            var _local_3:CheckboxOptionParam;
            for (var _local_2:int = 0; _local_2 < 8; _local_2++)
            {
                _local_3 = new CheckboxOptionParam(null);
                _local_3.iconAssetName = "move_" + _local_2;
                _local_1.push(_local_3);
            }
            this._directions = _arg_1.createCheckboxGroup(_local_1, null, 4);
            _arg_3.addElements(_arg_1.createSection(l("direction_selection"), this._directions));
        }

        override public function readIntParamsFromForm():Array
        {
            var _local_1:int = 0;
            for (var _local_2:int = 0; _local_2 < this._directions.numCheckboxes; _local_2++)
            {
                if (this._directions.get(_local_2).selected)
                {
                    _local_1 |= 1 << _local_2;
                }
            }
            return [_local_1];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            var _local_2:int = (_arg_1.intData.length > 0) ? int(_arg_1.intData[0]) : 0;
            for (var _local_3:int = 0; _local_3 < 8; _local_3++)
            {
                this._directions.get(_local_3).selected = (_local_2 & (1 << _local_3)) > 0;
            }
        }
    }
}
