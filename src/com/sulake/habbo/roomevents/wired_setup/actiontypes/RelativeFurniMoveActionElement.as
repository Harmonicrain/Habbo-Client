package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class RelativeFurniMoveActionElement extends DefaultElement
    {
        private var _x:NamedNumberInputPreset;
        private var _y:NamedNumberInputPreset;

        override public function get code():int { return ActionTypeCodes.RELATIVE_FURNI_MOVE; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiresFurniSelection():Boolean { return true; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._x = _arg_1.createNamedNumberInput(new NumberInputParam(0, -20, 20), l("movement.horizontal.distance"));
            this._y = _arg_1.createNamedNumberInput(new NumberInputParam(0, -20, 20), l("movement.vertical.distance"));
            _arg_3.addElements(_arg_1.createSection(l("movement.relative"), _arg_1.createSimpleListView(true, [this._x, this._y])));
        }

        override public function readIntParamsFromForm():Array { return [this._x.value, this._y.value]; }
        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._x.value = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
            this._y.value = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 0;
        }
    }
}
