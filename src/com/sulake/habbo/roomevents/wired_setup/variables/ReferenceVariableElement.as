package com.sulake.habbo.roomevents.wired_setup.variables
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SharedVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SharedVariableList;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.utils.Dictionary;

    public class ReferenceVariableElement extends VariableElement
    {
        private var _variableName:VariableNameSection;
        private var _roomDropdown:DropdownPreset;
        private var _variableDropdown:DropdownPreset;
        private var _settings:CheckboxGroupPreset;
        private var _initialVariable:WiredVariable;
        private var _rooms:Array;
        private var _variablesByRoom:Dictionary;
        private var _variableIds:Array;
        private var _variables:Array;
        private var _selectedRoomId:int = -1;
        private var _ready:Boolean;

        override public function get code():int { return VariableCodes.REFERENCE_VARIABLE; }
        override public function get inputMode():int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._variableName = manager.createVariableNameSection();
            this._roomDropdown = manager.createDropdown(new DropdownParam(
                l("variables.room_selection.tooltip"), null, this.onRoomSelected));
            this._variableDropdown = manager.createDropdown(new DropdownParam(
                l("variables.variable_selection.tooltip"), null, this.onVariableSelected));
            this._settings = manager.createCheckboxGroup([
                new CheckboxOptionParam(l("variables.settings.read_only"))
            ]);
            builder.addElements(this._variableName,
                manager.createSection(l("variables.room_selection"), this._roomDropdown),
                manager.createSection(l("variables.variable_ref_selection"),
                    this._variableDropdown),
                manager.createSection(l("variables.settings"), this._settings));
        }

        override public function onEditStart(data:Triggerable):void
        {
            super.onEditStart(data);
            var selectedId:String = data.variableIds.length > 0
                ? String(data.variableIds[0]) : WiredVariable.NONE_ID;
            this._settings.get(0).selected = data.intData.length > 0 &&
                int(data.intData[0]) != 0;
            this._ready = false;
            var shared:SharedVariableList = data.wiredContext.referenceVariablesList;
            this.initRooms(selectedId, shared);
            this.refreshVariables(selectedId);
            this._initialVariable = this.findVariableById(selectedId);
            this.initialVariableName = data.stringData;
            this._ready = true;
            this.setEditable(shared != null);
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._settings.get(0).selected ? 1 : 0];
        }
        override public function readStringParamFromForm():String
        {
            return this._variableName.variableName;
        }
        override public function readVariableIdsFromForm():Array
        {
            var index:int = this._variableDropdown.selectedId;
            if (index < 0 || index >= this._variableIds.length)
            {
                return [WiredVariable.NONE_ID];
            }
            return [this._variableIds[index]];
        }

        private function setEditable(value:Boolean):void
        {
            this._variableName.disabled = !value;
            this._roomDropdown.disabled = !value;
            this._variableDropdown.disabled = !value;
            this._settings.disabled = !value;
        }

        private function initRooms(selectedId:String, list:SharedVariableList):void
        {
            this._variablesByRoom = new Dictionary();
            this._rooms = [];
            this._selectedRoomId = -1;
            var roomMap:Dictionary = new Dictionary();
            var selectedRoom:Object;
            if (list != null)
            {
                for each (var shared:SharedVariable in list.sharedVariables)
                {
                    var room:Object = roomMap[shared.roomId];
                    if (room == null)
                    {
                        room = {"id":shared.roomId, "name":shared.roomName};
                        roomMap[shared.roomId] = room;
                        this._rooms.push(room);
                        this._variablesByRoom[shared.roomId] = [];
                    }
                    this._variablesByRoom[shared.roomId].push(shared.wiredVariable);
                    if (shared.wiredVariable.variableId == selectedId) { selectedRoom = room; }
                }
                this._rooms.sortOn("name", Array.CASEINSENSITIVE);
            }
            if (selectedRoom != null) { this._selectedRoomId = int(selectedRoom.id); }
            var roomOptions:Vector.<ExpandableDropdownOption> =
                new Vector.<ExpandableDropdownOption>();
            for each (room in this._rooms)
            {
                roomOptions.push(new ExpandableDropdownOption(room.id, room.name));
            }
            this._roomDropdown.reinit(roomOptions, this._selectedRoomId);
        }

        private function refreshVariables(selectedId:String):void
        {
            this._variableIds = [];
            this._variables = [];
            var options:Vector.<ExpandableDropdownOption> =
                new Vector.<ExpandableDropdownOption>();
            var selectedIndex:int = -1;
            var roomVariables:Array = this._variablesByRoom[this._selectedRoomId] as Array;
            if (roomVariables != null)
            {
                for each (var variable:WiredVariable in roomVariables)
                {
                    var index:int = options.length;
                    options.push(new ExpandableDropdownOption(index, variable.variableName));
                    this._variableIds.push(variable.variableId);
                    this._variables.push(variable);
                    if (variable.variableId == selectedId) { selectedIndex = index; }
                }
            }
            this._variableDropdown.reinit(options, selectedIndex);
        }

        private function onRoomSelected(option:ExpandableDropdownOption):void
        {
            if (!this._ready || option == null || this._selectedRoomId == option.id) { return; }
            this._selectedRoomId = option.id;
            this.refreshVariables(WiredVariable.NONE_ID);
            this.onVariableSelected(null);
        }

        private function onVariableSelected(option:ExpandableDropdownOption):void
        {
            if (!this._ready) { return; }
            var index:int = option == null ? -1 : option.id;
            var selected:WiredVariable = index >= 0 && index < this._variables.length
                ? this._variables[index] : null;
            if (this._variableName.variableName.length == 0 ||
                this._initialVariable != null &&
                this._initialVariable.variableName == this._variableName.variableName)
            {
                this._variableName.variableName =
                    selected == null ? "" : selected.variableName;
            }
            this._initialVariable = selected;
        }

        private function findVariableById(id:String):WiredVariable
        {
            for each (var roomVariables:Array in this._variablesByRoom)
            {
                for each (var variable:WiredVariable in roomVariables)
                {
                    if (variable.variableId == id) { return variable; }
                }
            }
            return null;
        }
        override protected function get variableNameSection():VariableNameSection
        {
            return this._variableName;
        }
    }
}
