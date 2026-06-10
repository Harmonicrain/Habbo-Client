package com.sulake.habbo.roomevents.wired_setup.conditions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupEntryData;
    import com.sulake.habbo.communication.messages.outgoing.users.GetGuildMembershipsMessageComposer;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    /**
     * Condition codes 10/21 (actor is / is not group member) — May 2026 payload.
     *
     * stringParam = specific group id, or "" meaning the room's own group. The
     * group dropdown is populated from a GetGuildMemberships round-trip routed
     * through the controller's onGuildMemberships hook (May §_-8j§ behavior).
     */
    public class ActorIsInGroupConditionElement extends DefaultElement
    {
        private static var REQUEST_TIMEOUT:int = 5;

        private var _guilds:Array;
        private var _selectedGroupId:int = -1;
        private var _lastRequestTime:Number = 0;
        private var _groupType:RadioGroupPreset;
        private var _groupDropdown:DropdownPreset;

        override public function get code():int
        {
            return ConditionCodes.ACTOR_IS_GROUP_MEMBER;
        }

        override public function get negativeCode():int
        {
            return ConditionCodes.NOT_ACTOR_IN_GROUP;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            this._groupDropdown = _arg_1.createDropdown(new DropdownParam(loc("wiredfurni.tooltip.group"), new Vector.<ExpandableDropdownOption>()));
            this._groupType = _arg_1.createRadioGroup([new RadioButtonParam(0, l("grouptype.0")), new RadioButtonParam(1, l("grouptype.1"), null, this._groupDropdown)]);
            _arg_3.addElements(_arg_1.createSection(l("groupselection"), this._groupType));
        }

        override public function readStringParamFromForm():String
        {
            if (this._groupType.selected != 1)
            {
                return "";
            }
            var _local_1:ExpandableDropdownOption = this._groupDropdown.selected;
            if (_local_1 == null)
            {
                return "";
            }
            return _local_1.id.toString();
        }

        override public function onEditStart(_arg_1:Triggerable):void
        {
            this._selectedGroupId = (_arg_1.stringData == "") ? -1 : int(_arg_1.stringData);
            this.initGuilds((this._guilds == null) ? [] : this._guilds);
            this.maybeGetGuildMemberships();
            this._groupType.selected = (_arg_1.stringData != "") ? 1 : 0;
        }

        private function maybeGetGuildMemberships():void
        {
            var _local_1:Number = new Date().time;
            if (_local_1 > (this._lastRequestTime + (1000 * REQUEST_TIMEOUT)))
            {
                this._lastRequestTime = _local_1;
                roomEvents.send(new GetGuildMembershipsMessageComposer());
            }
        }

        private function initGuilds(_arg_1:Array):void
        {
            var _local_2:HabboGroupEntryData;
            var _local_3:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();
            this._guilds = _arg_1;
            var _local_4:int = 0;
            while (_local_4 < this._guilds.length)
            {
                _local_2 = this._guilds[_local_4];
                _local_3.push(new ExpandableDropdownOption(_local_2.groupId, _local_2.groupName));
                _local_4++;
            }
            this._groupDropdown.reinit(_local_3, this._selectedGroupId);
        }

        override public function onGuildMemberships(_arg_1:Array):void
        {
            this.initGuilds(_arg_1);
        }
    }
}
