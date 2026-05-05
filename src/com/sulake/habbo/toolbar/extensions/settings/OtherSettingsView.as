package com.sulake.habbo.toolbar.extensions.settings
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.habbo.phonenumber.PhoneNumberStatusEnum;
    import com.sulake.habbo.phonenumber.ClientPhoneVerificationStatusEnum;
    import com.sulake.habbo.communication.messages.outgoing.preferences.SetIgnoreRoomInvitesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.preferences.SetRoomCameraPreferencesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.gifts.ResetPhoneNumberStateMessageComposer;
    import com.sulake.habbo.session.events.PerksUpdatedEvent;
    import com.sulake.habbo.communication.enum.perk.PerkEnum;

    public class OtherSettingsView 
    {
        private var _window:IWindowContainer;
        private var _toolbar:HabboToolbar;
        private var _reopenNavigatorOnPerksUpdated:Boolean;
        private var _reopenNavigatorUseNew:Boolean;

        public function OtherSettingsView(k:HabboToolbar)
        {
            this._toolbar = k;
            this.createWindow();
        }

        public function dispose():void
        {
            if (this._window == null)
            {
                return;
            }
            this._toolbar.sessionDataManager.events.removeEventListener(PerksUpdatedEvent.PERKS_UPDATED, this.onPerksUpdated);
            this._reopenNavigatorOnPerksUpdated = false;
            this._reopenNavigatorUseNew = false;
            this._window.dispose();
            this._window = null;
        }

        private function createWindow():void
        {
            var k:XmlAsset = (this._toolbar.assets.getAssetByName("me_menu_other_settings_xml") as XmlAsset);
            this._window = (this._toolbar.windowManager.buildFromXML((k.content as XML)) as IWindowContainer);
            var _local_2:int;
            var _local_3:IWindow;
            while (_local_2 < this._window.numChildren)
            {
                _local_3 = this._window.getChildAt(_local_2);
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                _local_2++;
            }
            ICheckBoxWindow(this._window.findChildByName("prefer_old_chat_checkbox")).Selected = this._toolbar.freeFlowChat.isDisabledInPreferences;
            ICheckBoxWindow(this._window.findChildByName("ignore_room_invites_checkbox")).Selected = this._toolbar.messenger.getRoomInvitesIgnored();
            ICheckBoxWindow(this._window.findChildByName("use_new_navigator_checkbox")).Selected = this._toolbar.sessionDataManager.isNavigatorPhaseTwo;
            this._window.findChildByName("disable_room_camera_follow_checkbox").visible = (this._window.findChildByName("disable_room_camera_follow_label").visible = this._toolbar.getBoolean("room.camera.follow_user"));
            if (this._toolbar.getBoolean("room.camera.follow_user"))
            {
                ICheckBoxWindow(this._window.findChildByName("disable_room_camera_follow_checkbox")).Selected = this._toolbar.sessionDataManager.isRoomCameraFollowDisabled;
            }
            var _local_4:Boolean = this._toolbar.getBoolean("sms.identity.verification.enabled");
            var _local_5:* = (this._toolbar.getInteger("phone.verification.status", PhoneNumberStatusEnum.NON_EXISTING) == PhoneNumberStatusEnum.VERIFIED);
            var _local_6:* = (this._toolbar.getInteger("phone.collection.status", ClientPhoneVerificationStatusEnum.NON_EXISTING) == ClientPhoneVerificationStatusEnum.NEVER_AGAIN);
            var _local_7:Boolean = this._toolbar.getBoolean("sms.identity.verification.button.enabled");
            var _local_8:* = (this._toolbar.getInteger("phone.collection.status", ClientPhoneVerificationStatusEnum.NON_EXISTING) == ClientPhoneVerificationStatusEnum.NON_EXISTING);
            var _local_9:Boolean = (((_local_4) && (!(_local_5))) && ((_local_6) || ((_local_7) && (_local_8))));
            this._window.findChildByName("btn_reset_phone_number_collection").visible = _local_9;
        }

        private function onButtonClicked(k:WindowMouseEvent):void
        {
            var _local_5:Boolean;
            var _local_4:Boolean;
            var _local_2:IWindow = (k.target as IWindow);
            var _local_3:String = _local_2.name;
            switch (_local_3)
            {
                case "back_btn":
                    this.dispose();
                    return;
                case "prefer_old_chat_checkbox":
                    this._toolbar.freeFlowChat.isDisabledInPreferences = ICheckBoxWindow(this._window.findChildByName("prefer_old_chat_checkbox")).Selected;
                    if (!this._toolbar.freeFlowChat.isDisabledInPreferences)
                    {
                        if (((!(this._toolbar._Str_12052.chatContainer == null)) && (!(this._toolbar.freeFlowChat.displayObject == null))))
                        {
                            this._toolbar._Str_12052.chatContainer.setDisplayObject(this._toolbar.freeFlowChat.displayObject);
                        }
                    }
                    else
                    {
                        this._toolbar.freeFlowChat.clear();
                    }
                    return;
                case "ignore_room_invites_checkbox":
                    this._toolbar.messenger.setRoomInvitesIgnored(ICheckBoxWindow(this._window.findChildByName("ignore_room_invites_checkbox")).Selected);
                    this._toolbar.connection.send(new SetIgnoreRoomInvitesMessageComposer(this._toolbar.messenger.getRoomInvitesIgnored()));
                    return;
                case "use_new_navigator_checkbox":
                    _local_4 = ICheckBoxWindow(this._window.findChildByName("use_new_navigator_checkbox")).Selected;
                    this._toolbar.sessionDataManager.events.removeEventListener(PerksUpdatedEvent.PERKS_UPDATED, this.onPerksUpdated);
                    this._reopenNavigatorOnPerksUpdated = false;
                    _local_5 = this._toolbar.sessionDataManager.setNavigatorPhaseTwo(_local_4);
                    if (_local_5)
                    {
                        this._reopenNavigatorOnPerksUpdated = true;
                        this._reopenNavigatorUseNew = _local_4;
                        this._toolbar.sessionDataManager.events.addEventListener(PerksUpdatedEvent.PERKS_UPDATED, this.onPerksUpdated);
                    }
                    return;
                case "disable_room_camera_follow_checkbox":
                    _local_4 = ICheckBoxWindow(this._window.findChildByName("disable_room_camera_follow_checkbox")).Selected;
                    this._toolbar.connection.send(new SetRoomCameraPreferencesMessageComposer(_local_4));
                    this._toolbar.sessionDataManager.setRoomCameraFollowDisabled(_local_4);
                    return;
                case "btn_reset_phone_number_collection":
                    this._window.findChildByName("btn_reset_phone_number_collection").visible = false;
                    this._toolbar.connection.send(new ResetPhoneNumberStateMessageComposer());
                    return;
            }
        }

        private function onPerksUpdated(k:PerksUpdatedEvent):void
        {
            this._toolbar.sessionDataManager.events.removeEventListener(PerksUpdatedEvent.PERKS_UPDATED, this.onPerksUpdated);
            if (!this._reopenNavigatorOnPerksUpdated)
            {
                return;
            }
            this._reopenNavigatorOnPerksUpdated = false;
            if (this._reopenNavigatorUseNew)
            {
                if (this._toolbar.sessionDataManager.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
                {
                    this._toolbar.openNewNavigator();
                }
                return;
            }
            if (!this._toolbar.sessionDataManager.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
            {
                this._toolbar.navigator.openNavigator();
            }
        }

        public function get window():IWindowContainer
        {
            return this._window;
        }
    }
}



