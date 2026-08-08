package com.sulake.habbo.roomevents.wired_setup.triggerconfs
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class UserClicksUserElement extends DefaultElement
    {
        private var _options:CheckboxGroupPreset;

        override public function get code():int
        {
            return WiredTriggerType.USER_CLICKS_USER;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._options = _arg_1.createCheckboxGroup([
                new CheckboxOptionParam(loc("wiredfurni.params.click_user.block_menu_open")),
                new CheckboxOptionParam(loc("wiredfurni.params.click_user.do_not_rotate"))
            ]);
            _arg_3.addElements(_arg_1.createSection(loc("wiredfurni.params.click_user.settings"), this._options));
        }

        override public function readIntParamsFromForm():Array
        {
            return [
                this._options.get(0).selected ? 1 : 0,
                this._options.get(1).selected ? 1 : 0
            ];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._options.get(0).selected = (_arg_1.intData.length > 0) && (_arg_1.intData[0] != 0);
            this._options.get(1).selected = (_arg_1.intData.length > 1) && (_arg_1.intData[1] != 0);
        }
    }
}
