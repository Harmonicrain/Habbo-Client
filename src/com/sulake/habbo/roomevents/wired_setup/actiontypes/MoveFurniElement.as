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

    public class MoveFurniElement extends DefaultElement
    {
        private var _move:RadioGroupPreset;
        private var _rotate:RadioGroupPreset;

        public function MoveFurniElement()
        {
            super();
        }

        override public function get code():int
        {
            return ActionTypeCodes.MOVE_FURNI;
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
            this._move = _arg_1.createRadioGroup([new RadioButtonParam(0, l("movefurni.0"), null, null, true), this.iconButton(4, "move_0"), this.iconButton(8, "move_1"), this.iconButton(5, "move_2"), this.iconButton(9, "move_3"), this.iconButton(6, "move_4"), this.iconButton(10, "move_5"), this.iconButton(7, "move_6"), this.iconButton(11, "move_7"), this.iconButton(2, "move_diag"), this.iconButton(3, "move_vrt"), new RadioButtonParam(1, l("movefurni.1"))], null, 4);
            this._rotate = _arg_1.createRadioGroup([new RadioButtonParam(0, l("rotatefurni.0")), this.iconButton(1, "rotate_cw"), this.iconButton(2, "rotate_ccw"), new RadioButtonParam(3, l("rotatefurni.3"))]);
            _arg_3.addElements(_arg_1.createSection(l("movefurni"), this._move), _arg_1.createSection(l("rotatefurni"), this._rotate));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._move.selected, this._rotate.selected];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._move.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
            this._rotate.selected = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 0;
        }

        private function iconButton(_arg_1:int, _arg_2:String):RadioButtonParam
        {
            var _local_3:RadioButtonParam = new RadioButtonParam(_arg_1, "");
            _local_3.iconAssetName = _arg_2;
            return _local_3;
        }
    }
}
