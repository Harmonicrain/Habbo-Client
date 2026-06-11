package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class FreezeUserActionElement extends DefaultElement
    {
        private var _effect:DropdownPreset;
        private var _cancel:CheckboxGroupPreset;

        override public function get code():int { return ActionTypeCodes.FREEZE_USER; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            var _local_1:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();
            for (var _local_2:int = 0; _local_2 <= 4; _local_2++) { _local_1.push(new ExpandableDropdownOption(_local_2, l("freeze.effect." + _local_2))); }
            this._effect = _arg_1.createDropdown(new DropdownParam("${wiredfurni.params.freeze.effect_selection}", _local_1));
            this._cancel = _arg_1.createCheckboxGroup([new CheckboxOptionParam(l("freeze.cancel_on_teleport"), 0)]);
            _arg_3.addElements(_arg_1.createSection("${wiredfurni.params.freeze.effect_selection}", _arg_1.createSimpleListView(true, [this._effect, this._cancel])));
        }

        override public function readIntParamsFromForm():Array { return [this._effect.selectedId, this._cancel.get(0).selected ? 1 : 0]; }
        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._effect.selectedId = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
            this._cancel.get(0).selected = (_arg_1.intData.length > 1) && (_arg_1.intData[1] == 1);
        }
    }
}
