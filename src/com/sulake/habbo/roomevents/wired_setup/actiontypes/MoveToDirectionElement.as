package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class MoveToDirectionElement extends DefaultElement
    {
        private var _startDirection:RadioGroupPreset;
        private var _turn:RadioGroupPreset;
        private var _blockOnCollision:CheckboxGroupPreset;

        public function MoveToDirectionElement()
        {
            super();
        }

        override public function get code():int
        {
            return ActionTypeCodes.MOVE_TO_DIRECTION;
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
            this._startDirection = _arg_1.createRadioGroup([this.iconButton(0, "move_0"), this.iconButton(1, "move_1"), this.iconButton(2, "move_2"), this.iconButton(3, "move_3"), this.iconButton(4, "move_4"), this.iconButton(5, "move_5"), this.iconButton(6, "move_6"), this.iconButton(7, "move_7")], null, 4);
            this._turn = _arg_1.createRadioGroup([new RadioButtonParam(0, l("turn.0")), new RadioButtonParam(1, l("turn.1")), new RadioButtonParam(2, l("turn.2")), new RadioButtonParam(3, l("turn.3")), new RadioButtonParam(4, l("turn.4")), new RadioButtonParam(5, l("turn.5")), new RadioButtonParam(6, l("turn.6"))]);
            this._blockOnCollision = _arg_1.createCheckboxGroup([new CheckboxOptionParam(l("user_collide.0"), 0)]);
            _arg_3.addElements(_arg_1.createSection(l("startdir"), this._startDirection), _arg_1.createSection(l("turn"), this._turn), _arg_1.createSection(l("user_collide"), this._blockOnCollision));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._startDirection.selected, this._turn.selected, this._blockOnCollision.get(0).selected ? 1 : 0];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._startDirection.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
            this._turn.selected = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 0;
            this._blockOnCollision.get(0).selected = (_arg_1.intData.length > 2) && (_arg_1.intData[2] != 0);
        }

        private function iconButton(_arg_1:int, _arg_2:String):RadioButtonParam
        {
            var _local_3:RadioButtonParam = new RadioButtonParam(_arg_1, "");
            _local_3.iconAssetName = _arg_2;
            return _local_3;
        }
    }
}
