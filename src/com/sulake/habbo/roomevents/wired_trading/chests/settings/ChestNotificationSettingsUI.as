package com.sulake.habbo.roomevents.wired_trading.chests.settings
{
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestSettingsResultMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.SaveChestNotificationsMessageComposer;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.BorderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.UsageInfoSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.wired_trading.AbstractUbuntuWiredUI;
    import com.sulake.habbo.roomevents.wired_trading.chests.ChestType;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import flash.system.Capabilities;
    import __AS3__.vec.Vector;

    public class ChestNotificationSettingsUI extends AbstractUbuntuWiredUI
    {
        private var _controller:WiredChestController;
        private var _generic:CheckboxGroupPreset;
        private var _wiredSection:SectionPreset;
        private var _wired:CheckboxGroupPreset;
        private var _mode:DropdownPreset;
        private var _resultEvent:ChestSettingsResultMessageEvent;
        private var _chestId:int = -1;

        public function ChestNotificationSettingsUI(controller:WiredChestController,
            presets:PresetManager)
        {
            super(controller.roomEvents, presets);
            this._controller = controller;
            this._resultEvent = new ChestSettingsResultMessageEvent(this.onUpdateSuccess);
            controller.addMessageEvent(this._resultEvent);
            var style:WiredStyle = presets.wiredStyle;
            var info:UsageInfoSection = presets.createUsageInfoSection(
                "${wiredchests.notification_settings.notification_info.desc}", true,
                "${wiredchests.notification_settings.notification_info}");
            this._generic = presets.createCheckboxGroup([
                new CheckboxOptionParam(
                    "${wiredchests.notification_settings.enable_notifications.generic.0}", 0),
                new CheckboxOptionParam(
                    "${wiredchests.notification_settings.enable_notifications.generic.1}", 1)]);
            this._wired = presets.createCheckboxGroup([
                new CheckboxOptionParam(
                    "${wiredchests.notification_settings.enable_notifications.wired.0}", 0),
                new CheckboxOptionParam(
                    "${wiredchests.notification_settings.enable_notifications.wired.1}", 1),
                new CheckboxOptionParam(
                    "${wiredchests.notification_settings.enable_notifications.wired.2}", 2)]);
            var genericSection:SectionPreset = presets.createSection(
                "${wiredchests.notification_settings.enable_notifications.generic}",
                this._generic);
            genericSection.splitterVisible = false;
            this._wiredSection = presets.createSection(
                "${wiredchests.notification_settings.enable_notifications.wired}",
                this._wired);
            var notificationList:SimpleListViewPreset = presets.createSimpleListView(
                true, [genericSection, this._wiredSection]);
            notificationList.spacing = style.sectionSpacing;
            var notificationSection:BorderSection = presets.createBorderSection(
                "${wiredchests.notification_settings.enable_notifications}",
                notificationList);
            var modes:Vector.<ExpandableDropdownOption> =
                new Vector.<ExpandableDropdownOption>();
            modes.push(new ExpandableDropdownOption(0,
                "${wiredchests.notification_settings.notification_mode.when.0}"));
            modes.push(new ExpandableDropdownOption(1,
                "${wiredchests.notification_settings.notification_mode.when.1}"));
            this._mode = presets.createDropdown(new DropdownParam(
                "${wiredchests.notification_settings.notification_mode.when}", modes));
            var modeSection:SectionPreset = presets.createSection(
                "${wiredchests.notification_settings.notification_mode.when}", this._mode);
            modeSection.splitterVisible = false;
            var modeBorder:BorderSection = presets.createBorderSection(
                "${wiredchests.notification_settings.notification_mode}", modeSection);
            var scroll:ListScrollParams = new ListScrollParams(false, 320,
                Capabilities.screenResolutionY / 2.4, true);
            framePreset = presets.createFramePreset([info, notificationSection,
                modeBorder, footerPreset], onCloseClicked, null, -1, false, false, scroll);
            framePreset.resizeToWidth(350);
        }
        private function onUpdateSuccess(event:ChestSettingsResultMessageEvent):void
        {
            if (event.getParser().chestId == this._chestId
                && event.getParser().isNotificationPreferences)
            {
                this.hideFrame();
            }
        }
        public function onEdit(chestId:int, chestType:int, data:Map):void
        {
            this._chestId = chestId;
            var typeName:String = localization.getLocalization("wiredchests."
                + (chestType == ChestType.FURNI ? "furni" : "coin") + "_chest");
            framePreset.title = localization.getLocalizationWithParams(
                "wiredchests.notification_settings.title", "", "chest_type", typeName);
            this._generic.get(0).selected =
                data.getValue("notification_chest_full") == "1";
            this._generic.get(1).selected =
                data.getValue("notification_donation") == "1";
            this._wired.get(0).selected =
                data.getValue("notification_someone_withdraws") == "1";
            this._wired.get(1).selected =
                data.getValue("notification_chest_empty") == "1";
            this._wired.get(2).selected =
                data.getValue("notification_wired_transaction") == "1";
            this._mode.selectedId = int(data.getValue("notify_mode"));
            this._wiredSection.disabled = data.getValue("is_wired_enabled") != "1";
            this.showFrame();
        }
        override public function onSaveClicked():void
        {
            this._controller.send(new SaveChestNotificationsMessageComposer(
                this._chestId, this._mode.selectedId,
                this._generic.get(0).selected, this._generic.get(1).selected,
                this._wired.get(0).selected, this._wired.get(1).selected,
                this._wired.get(2).selected));
        }
        override public function dispose():void
        {
            if (disposed) { return; }
            this._controller.removeMessageEvent(this._resultEvent);
            this._resultEvent.dispose();
            this._resultEvent = null;
            this._controller = null;
            super.dispose();
        }
    }
}
