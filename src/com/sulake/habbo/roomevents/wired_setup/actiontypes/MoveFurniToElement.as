package com.sulake.habbo.roomevents.wired_setup.actiontypes
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
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class MoveFurniToElement extends DefaultElement
    {
        private var _direction:RadioGroupPreset;
        private var _tiles:SliderSection;

        public function MoveFurniToElement()
        {
            super();
        }

        override public function get code():int
        {
            return ActionTypeCodes.MOVE_FURNI_TO;
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
            this._tiles = _arg_1.createSliderSection("wiredfurni.params.emptytiles", "tiles", new SliderValueEcho(), 1, 5, 1);
            this._direction = _arg_1.createRadioGroup([this.iconButton(0, "move_0"), this.iconButton(2, "move_2"), this.iconButton(4, "move_4"), this.iconButton(6, "move_6")], null, 4);
            _arg_3.addElements(this._tiles, _arg_1.createSection(l("placetodirection"), this._direction));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._direction.selected, this._tiles.value];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._direction.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
            this._tiles.value = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 1;
        }

        private function iconButton(_arg_1:int, _arg_2:String):RadioButtonParam
        {
            var _local_3:RadioButtonParam = new RadioButtonParam(_arg_1, "");
            _local_3.iconAssetName = _arg_2;
            return _local_3;
        }
    }
}
