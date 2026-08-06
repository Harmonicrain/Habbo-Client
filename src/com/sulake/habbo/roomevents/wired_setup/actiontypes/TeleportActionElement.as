package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** May/July AIR editor for the classic Teleport effect (action code 8). */
    public class TeleportActionElement extends DefaultElement
    {
        private var _options:CheckboxGroupPreset;

        override public function get code():int
        {
            return ActionTypeCodes.TELEPORT;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._options = _arg_1.createCheckboxGroup([
                new CheckboxOptionParam(loc("wiredfurni.params.teleport.options.0"))
            ]);
            _arg_3.addElements(_arg_1.createSection(
                loc("wiredfurni.params.teleport.options"),
                this._options
            ));
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._options.get(0).selected = _arg_1.intData.length > 0 && _arg_1.getBoolean(0);
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._options.get(0).selected ? 1 : 0];
        }
    }
}
