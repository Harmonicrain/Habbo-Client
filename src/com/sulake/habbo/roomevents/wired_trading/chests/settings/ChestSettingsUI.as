package com.sulake.habbo.roomevents.wired_trading.chests.settings
{
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestSettingsResultMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.SaveChestSettingsMessageComposer;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ContainerButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.StaticBitmapAssetWrapperPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.BorderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.wired_trading.AbstractUbuntuWiredUI;
    import com.sulake.habbo.roomevents.wired_trading.chests.ChestType;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import flash.system.Capabilities;
    import __AS3__.vec.Vector;

    public class ChestSettingsUI extends AbstractUbuntuWiredUI
    {
        private var _controller:WiredChestController;
        private var _access:CheckboxGroupPreset;
        private var _name:TextInputPreset;
        private var _description:TextAreaPreset;
        private var _state:DropdownPreset;
        private var _previewSection:SectionPreset;
        private var _preview:DropdownPreset;
        private var _previewAmountSection:SectionPreset;
        private var _previewAmount:DropdownPreset;
        private var _wiredUpgrade:ContainerButtonPreset;
        private var _wiredEnabledIcon:StaticBitmapAssetWrapperPreset;
        private var _wiredUpgradeConfirmation:
            WiredChestWiredUpdateConfirmationView;
        private var _resultEvent:ChestSettingsResultMessageEvent;
        private var _chestType:int;
        private var _chestId:int = -1;
        private var _chestItemType:int;
        private var _isStarter:Boolean;

        public function ChestSettingsUI(controller:WiredChestController, presets:PresetManager)
        {
            super(controller.roomEvents, presets);
            this._controller = controller;
            this._resultEvent = new ChestSettingsResultMessageEvent(this.onUpdateSuccess);
            controller.addMessageEvent(this._resultEvent);
            var style:WiredStyle = presets.wiredStyle;
            this._access = presets.createCheckboxGroup([
                new CheckboxOptionParam("${wiredchests.settings.access.open}"),
                new CheckboxOptionParam("${wiredchests.settings.access.donate}")]);
            var accessSection:BorderSection = presets.createBorderSection(
                "${wiredchests.settings.access}", this._access);
            this._name = presets.createTextInput(new TextInputParam("", 30));
            this._description = presets.createTextArea(
                new TextAreaParam(64, -1, 4, -1, 200, "", null, null, true, true));
            var nameSection:SectionPreset = presets.createSection(
                "${wiredchests.settings.info.name}", this._name);
            nameSection.splitterVisible = false;
            var descriptionSection:SectionPreset = presets.createSection(
                "${wiredchests.settings.info.desc}", this._description);
            var infoList:SimpleListViewPreset = presets.createSimpleListView(
                true, [nameSection, descriptionSection]);
            infoList.spacing = style.sectionSpacing;
            var infoSection:BorderSection = presets.createBorderSection(
                "${wiredchests.settings.info}", infoList);
            var states:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();
            var i:int;
            for (i = 0; i < 4; i++)
            {
                states.push(new ExpandableDropdownOption(i,
                    "${wiredchests.settings.appearance.state." + i + "}"));
            }
            var previews:Vector.<ExpandableDropdownOption> =
                new Vector.<ExpandableDropdownOption>();
            for (i = 0; i < 8; i++)
            {
                previews.push(new ExpandableDropdownOption(i,
                    "${wiredchests.settings.appearance.preview." + i + "}"));
            }
            var amounts:Vector.<ExpandableDropdownOption> =
                new Vector.<ExpandableDropdownOption>();
            for (i = 1; i <= 4; i++)
            {
                amounts.push(new ExpandableDropdownOption(i, String(i)));
            }
            this._state = presets.createDropdown(new DropdownParam(
                "${wiredchests.settings.appearance.state}", states));
            var stateSection:SectionPreset = presets.createSection(
                "${wiredchests.settings.appearance.state}", this._state);
            stateSection.splitterVisible = false;
            this._preview = presets.createDropdown(new DropdownParam(
                "${wiredchests.settings.appearance.preview}", previews,
                this.onChangePreview));
            this._previewSection = presets.createSection(
                "${wiredchests.settings.appearance.preview}",
                presets.createSimpleListView(true, [this._preview,
                    presets.createText("${wiredchests.settings.appearance.preview.note}")
                        .halfBlend()]));
            this._previewAmount = presets.createDropdown(new DropdownParam(
                "${wiredchests.settings.appearance.preview_amount}", amounts));
            this._previewAmountSection = presets.createSection(
                "${wiredchests.settings.appearance.preview_amount}", this._previewAmount);
            var appearanceList:SimpleListViewPreset = presets.createSimpleListView(
                true, [stateSection, this._previewSection, this._previewAmountSection]);
            appearanceList.spacing = style.sectionSpacing;
            var appearanceSection:BorderSection = presets.createBorderSection(
                "${wiredchests.settings.appearance}", appearanceList);
            var upgradeContent:SimpleListViewPreset = presets.createSimpleListView(false, [
                presets.createBitmapWrapperPreset("${image.library.url}catalogue/icon_80.png"),
                presets.createText("${wiredchests.settings.wired.upgrade}", new TextParam(0))
            ], true);
            this._wiredUpgrade = presets.createContainerButtonPreset(
                upgradeContent.alignCenter(), this.onClickUpgrade, false);
            this._wiredEnabledIcon = presets.createBitmapWrapperPreset("icon_checkmark_small");
            var wiredList:SimpleListViewPreset = presets.createSimpleListView(false,
                [this._wiredUpgrade, this._wiredEnabledIcon], true);
            var wiredSection:BorderSection = presets.createBorderSection(
                "${wiredchests.settings.wired}", wiredList);
            var scroll:ListScrollParams = new ListScrollParams(false, 420,
                Capabilities.screenResolutionY / 2.4, true);
            framePreset = presets.createFramePreset([accessSection, infoSection,
                appearanceSection, wiredSection, footerPreset], onCloseClicked,
                null, -1, false, false, scroll);
            framePreset.resizeToWidth(300);
        }
        private function onUpdateSuccess(event:ChestSettingsResultMessageEvent):void
        {
            if (event.getParser().chestId == this._chestId
                && !event.getParser().isNotificationPreferences)
            {
                this.hideFrame();
            }
        }
        override protected function hideFrame():void
        {
            super.hideFrame();
            if (this._wiredUpgradeConfirmation != null)
            {
                this._wiredUpgradeConfirmation.hide();
            }
        }
        private function onClickUpgrade():void
        {
            if (this._wiredUpgrade.disabled) { return; }
            if (this._wiredUpgradeConfirmation == null)
            {
                this._wiredUpgradeConfirmation =
                    new WiredChestWiredUpdateConfirmationView(this);
            }
            this._wiredUpgradeConfirmation.initialize(
                this._chestId, this._chestType,
                this._chestItemType, this._isStarter);
            this._wiredUpgradeConfirmation.show();
        }
        internal function confirmUpgrade():void
        {
            this._wiredUpgrade.disabled = true;
            this._wiredEnabledIcon.visible = true;
            this.onSaveClicked();
        }
        private function onChangePreview(option:ExpandableDropdownOption):void
        {
            this._previewAmountSection.disabled = option.id == 0;
        }
        public function onEdit(chestId:int, chestType:int, chestItemType:int,
            isStarter:Boolean, data:Map):void
        {
            this._chestId = chestId;
            this._chestType = chestType;
            this._chestItemType = chestItemType;
            this._isStarter = isStarter;
            this._previewSection.visible = chestType == ChestType.FURNI;
            this._previewAmountSection.visible = chestType == ChestType.FURNI;
            var typeName:String = localization.getLocalization("wiredchests."
                + (chestType == ChestType.FURNI ? "furni" : "coin") + "_chest");
            framePreset.title = localization.getLocalizationWithParams(
                "wiredchests.settings.title", "", "chest_type", typeName);
            this._access.get(0).selected = data.getValue("everyone_can_open") == "1";
            this._access.get(1).selected = data.getValue("everyone_can_donate") == "1";
            this._name.text = data.getValue("chest_name");
            this._description.text = data.getValue("chest_desc");
            this._state.selectedId = int(data.getValue("state_control_mode"));
            var wired:Boolean = data.getValue("is_wired_enabled") == "1";
            this._wiredUpgrade.disabled = wired;
            this._wiredEnabledIcon.visible = wired;
            if (chestType == ChestType.FURNI)
            {
                this._preview.selectedId = int(data.getValue("preview_mode"));
                this._previewAmount.selectedId = int(data.getValue("preview_amount"));
                this._previewAmountSection.disabled = this._preview.selectedId == 0;
            }
            this.showFrame();
        }
        override public function onSaveClicked():void
        {
            this._controller.send(new SaveChestSettingsMessageComposer(
                this._chestId, this._name.text, this._description.text,
                this._access.get(0).selected, this._access.get(1).selected,
                this._state.selectedId, this._preview.selectedId,
                this._previewAmount.selectedId, this._wiredUpgrade.disabled));
        }
        override public function dispose():void
        {
            if (disposed) { return; }
            if (this._wiredUpgradeConfirmation != null)
            {
                this._wiredUpgradeConfirmation.dispose();
                this._wiredUpgradeConfirmation = null;
            }
            this._controller.removeMessageEvent(this._resultEvent);
            this._resultEvent.dispose();
            this._resultEvent = null;
            this._controller = null;
            super.dispose();
        }

        public function get chestController():WiredChestController
        {
            return this._controller;
        }
    }
}
