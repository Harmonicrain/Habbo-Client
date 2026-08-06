package com.sulake.habbo.roomevents.wired_setup.common
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.common.utils.WiredUserAction;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Shared May 2026 action editor used by the action trigger, condition and selector. */
    public class UserActionElement extends DefaultElement
    {
        private var _code:int;
        private var _negativeCode:int;
        private var _actionDropdown:DropdownPreset;
        private var _signCheckbox:CheckboxGroupPreset;
        private var _danceCheckbox:CheckboxGroupPreset;
        private var _signDropdown:DropdownPreset;
        private var _danceDropdown:DropdownPreset;
        private var _signSection:SectionPreset;
        private var _danceSection:SectionPreset;

        public function UserActionElement(code:int, negativeCode:int = -1)
        {
            super();
            this._code = code;
            this._negativeCode = negativeCode;
        }

        override public function get code():int
        {
            return this._code;
        }

        override public function get negativeCode():int
        {
            return this._negativeCode;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(presets:PresetManager, style:WiredStyle, builder:WiredUIBuilder):void
        {
            this._actionDropdown = presets.createDropdown(new DropdownParam(loc("wiredfurni.tooltip.action"), this.buildActionOptions(), this.onActionSelected));
            var actionSection:SectionPreset = presets.createSection(l("action_selection"), this._actionDropdown);

            this._signDropdown = presets.createDropdown(new DropdownParam(loc("wiredfurni.tooltip.sign"), this.buildSignOptions()));
            var signParam:CheckboxOptionParam = new CheckboxOptionParam(l("sign_filter"), 0);
            signParam.extra2 = this._signDropdown;
            this._signCheckbox = presets.createCheckboxGroup([signParam]);
            this._signSection = presets.createSection(l("sign_selection"), this._signCheckbox);

            this._danceDropdown = presets.createDropdown(new DropdownParam(loc("wiredfurni.tooltip.dance"), this.buildDanceOptions()));
            var danceParam:CheckboxOptionParam = new CheckboxOptionParam(l("dance_filter"), 0);
            danceParam.extra2 = this._danceDropdown;
            this._danceCheckbox = presets.createCheckboxGroup([danceParam]);
            this._danceSection = presets.createSection(l("dance_selection"), this._danceCheckbox);

            this._signSection.visible = false;
            this._danceSection.visible = false;
            builder.addElements(actionSection, this._signSection, this._danceSection);
        }

        override public function onEditStart(triggerable:Triggerable):void
        {
            this._actionDropdown.selectedId = triggerable.intData.length > 0 ? triggerable.intData[0] : 0;
            this.updateExtraSections(triggerable.stringData);
        }

        override public function readIntParamsFromForm():Array
        {
            var action:WiredUserAction = this.selectedAction;
            return [action != null ? action.code : 0];
        }

        override public function readStringParamFromForm():String
        {
            var action:WiredUserAction = this.selectedAction;
            if (action == null || !action.hasExtra)
            {
                return "";
            }

            var extraCode:int = this.selectedExtraCode(action.code);
            return extraCode == -1 ? "" : action.convertCodeToExtraString(extraCode);
        }

        private function onActionSelected(option:ExpandableDropdownOption):void
        {
            this.updateExtraSections();
        }

        private function updateExtraSections(extra:String = ""):void
        {
            var action:WiredUserAction = this.selectedAction;
            if (action == null || !action.hasExtra)
            {
                this._signSection.visible = false;
                this._danceSection.visible = false;
                return;
            }

            var isSign:Boolean = action.code == WiredUserAction.SIGN_ACTION_CODE;
            var isDance:Boolean = action.code == WiredUserAction.DANCE_ACTION_CODE;
            this._signSection.visible = isSign;
            this._danceSection.visible = isDance;

            if (isSign)
            {
                this._signCheckbox.get(0).selected = extra != "";
                this._signDropdown.selectedId = extra == "" ? -1 : action.convertExtraStringToCode(extra);
            }
            if (isDance)
            {
                this._danceCheckbox.get(0).selected = extra != "";
                this._danceDropdown.selectedId = extra == "" ? -1 : action.convertExtraStringToCode(extra);
            }
        }

        private function get selectedAction():WiredUserAction
        {
            return WiredUserAction.getByCode(this._actionDropdown.selectedId);
        }

        private function selectedExtraCode(actionCode:int):int
        {
            if (actionCode == WiredUserAction.SIGN_ACTION_CODE)
            {
                return this._signCheckbox.get(0).selected ? this._signDropdown.selectedId : -1;
            }
            if (actionCode == WiredUserAction.DANCE_ACTION_CODE)
            {
                return this._danceCheckbox.get(0).selected ? this._danceDropdown.selectedId : -1;
            }
            return -1;
        }

        private function buildActionOptions():Vector.<ExpandableDropdownOption>
        {
            var options:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();
            for each (var action:WiredUserAction in WiredUserAction.allWiredUserActions)
            {
                options.push(new ExpandableDropdownOption(action.code, l("action." + action.code)));
            }
            return options;
        }

        private function buildSignOptions():Vector.<ExpandableDropdownOption>
        {
            var options:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();
            for (var i:int = 0; i <= 17; i++)
            {
                options.push(new ExpandableDropdownOption(i, l("action.sign." + i)));
            }
            return options;
        }

        private function buildDanceOptions():Vector.<ExpandableDropdownOption>
        {
            var options:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();
            for (var i:int = 1; i <= 4; i++)
            {
                options.push(new ExpandableDropdownOption(i, l("action.dance." + i)));
            }
            return options;
        }
    }
}
