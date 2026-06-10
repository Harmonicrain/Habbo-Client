package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

    public class ShowMessageActionElement extends DefaultElement
    {
        private static const NOTIFICATION_STYLES:Array = [34, 200, 201, 202, 210, 211, 212, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 250, 251, 252];

        private var _message:TextAreaPreset;
        private var _visibility:RadioGroupPreset;
        private var _style:DropdownPreset;

        override public function get code():int
        {
            return ActionTypeCodes.CHAT;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            var _local_2:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();
            for each (var _local_3:int in NOTIFICATION_STYLES)
            {
                _local_2.push(new ExpandableDropdownOption(_local_3, "${wiredfurni.params.show_message.style_selection." + _local_3 + "}"));
            }

            this._message = _arg_1.createTextArea(new TextAreaParam(40, -1, 8, -1, 200));
            this._visibility = _arg_1.createRadioGroup([new RadioButtonParam(0, "${wiredfurni.params.show_message.visibility_selection.0}"), new RadioButtonParam(1, "${wiredfurni.params.show_message.visibility_selection.1}")]);
            this._style = _arg_1.createDropdown(new DropdownParam("${wiredfurni.params.show_message.style_selection.title}", _local_2));

            _arg_3.addElements(
                _arg_1.createUsageInfoSection("${wiredfurni.params.show_message.usage_info}", true),
                _arg_1.createSection("${wiredfurni.params.message}", this._message),
                _arg_1.createSection("${wiredfurni.params.show_message.visibility_selection.title}", this._visibility, SectionParam.COLLAPSED),
                _arg_1.createSection("${wiredfurni.params.show_message.style_selection.title}", this._style, SectionParam.COLLAPSED)
            );
        }

        override public function readStringParamFromForm():String
        {
            return this._message.text;
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._visibility.selected, this._style.selectedId];
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._message.text = _arg_1.stringData;
            this._visibility.selected = (_arg_1.intData.length > 0) ? _arg_1.intData[0] : 0;
            this._style.selectedId = (_arg_1.intData.length > 1) ? _arg_1.intData[1] : 34;
        }

        override public function validate():String
        {
            if (this._message.text.length > 200)
            {
                return loc("wiredfurni.chatmsgtoolong");
            }
            return null;
        }
    }
}
