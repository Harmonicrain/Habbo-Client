package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class SetFurniStateToElement extends DefaultElement
    {
        private var _conditions:CheckboxGroupPreset;

        public function SetFurniStateToElement()
        {
            super();
        }

        override public function get code():int
        {
            return ActionTypeCodes.SET_FURNI_STATE;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function get hasStateSnapshot():Boolean
        {
            return true;
        }

        override public function get requiresFurniSelection():Boolean
        {
            return true;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._conditions = _arg_1.createCheckboxGroup([new CheckboxOptionParam(l("condition.state"), 0), new CheckboxOptionParam(l("condition.direction"), 1), new CheckboxOptionParam(l("condition.position"), 2), new CheckboxOptionParam(l("condition.altitude"), 3)]);
            _arg_3.addElements(_arg_1.createSection(l("conditions"), this._conditions));
        }

        override public function readIntParamsFromForm():Array
        {
            return [this.checked(0), this.checked(1), this.checked(2), this.checked(3)];
        }

        private function checked(_arg_1:int):int
        {
            return this._conditions.get(_arg_1).selected ? 1 : 0;
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._conditions.get(0).selected = _arg_1.getBoolean(0);
            this._conditions.get(1).selected = _arg_1.getBoolean(1);
            this._conditions.get(2).selected = _arg_1.getBoolean(2);
            this._conditions.get(3).selected = _arg_1.getBoolean(3);
        }
    }
}
