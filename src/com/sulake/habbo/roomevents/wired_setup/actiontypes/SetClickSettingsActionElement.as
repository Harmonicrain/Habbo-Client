package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July action 54 (wf_act_click_conf): [userMode 0..2, furniMode 0..1]. */
    public class SetClickSettingsActionElement extends DefaultElement
    {
        private var _userMode:DropdownPreset;
        private var _furniMode:DropdownPreset;

        override public function get code():int
        {
            return ActionTypeCodes.SET_CLICK_SETTINGS;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._userMode = _arg_1.createDropdown(new DropdownParam("${wiredfurni.params.click_settings.user}", Vector.<ExpandableDropdownOption>([
                new ExpandableDropdownOption(0, "${wiredfurni.params.click_settings.user.0}"),
                new ExpandableDropdownOption(1, "${wiredfurni.params.click_settings.user.1}"),
                new ExpandableDropdownOption(2, "${wiredfurni.params.click_settings.user.2}")
            ])));
            this._furniMode = _arg_1.createDropdown(new DropdownParam("${wiredfurni.params.click_settings.furni}", Vector.<ExpandableDropdownOption>([
                new ExpandableDropdownOption(0, "${wiredfurni.params.click_settings.furni.0}"),
                new ExpandableDropdownOption(1, "${wiredfurni.params.click_settings.furni.1}")
            ])));
            _arg_3.addElements(
                _arg_1.createSection("${wiredfurni.params.click_settings.user}", this._userMode),
                _arg_1.createSection("${wiredfurni.params.click_settings.furni}", this._furniMode)
            );
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._userMode.selectedId, this._furniMode.selectedId];
        }

        override public function onEditStart(k:Triggerable):void
        {
            this._userMode.selectedId = k.intData.length > 0 ? k.intData[0] : 0;
            this._furniMode.selectedId = k.intData.length > 1 ? k.intData[1] : 0;
        }
    }
}
