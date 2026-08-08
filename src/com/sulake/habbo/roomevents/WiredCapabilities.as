package com.sulake.habbo.roomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredCapabilitiesMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.RequestWiredCapabilitiesMessageComposer;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredCapabilitiesMessageParser;

    public class WiredCapabilities implements IDisposable
    {
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _messageEvent:IMessageEvent;
        private var _negotiatedRevision:int;
        private var _connectionCapabilityMask:int;
        private var _roomId:int;
        private var _roomCapabilityMask:int;

        public function WiredCapabilities(k:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = k;
            this._messageEvent = this._roomEvents.communication.addHabboConnectionMessageEvent(new WiredCapabilitiesMessageEvent(this.onCapabilities));
        }

        public function request(k:int):void
        {
            var _local_2:int = this.configuredClientMask;
            if ((_local_2 & WiredCapabilityCodes.PROTOCOL) == 0)
            {
                return;
            }
            this._roomEvents.send(new RequestWiredCapabilitiesMessageComposer(WiredCapabilityCodes.PROTOCOL_REVISION, _local_2, k));
        }

        private function onCapabilities(k:IMessageEvent):void
        {
            var _local_2:WiredCapabilitiesMessageParser = (k as WiredCapabilitiesMessageEvent).getParser();
            var _local_3:int = this.configuredClientMask;
            if ((_local_3 & WiredCapabilityCodes.PROTOCOL) == 0)
            {
                this.resetConnection();
                return;
            }
            if (((_local_2.negotiatedRevision == 0) && (_local_2.connectionCapabilityMask == 0) && (_local_2.roomCapabilityMask == 0)))
            {
                this.resetConnection();
                return;
            }
            if (_local_2.negotiatedRevision != WiredCapabilityCodes.PROTOCOL_REVISION)
            {
                return;
            }

            var _local_4:int = this.applyDependencies(_local_2.connectionCapabilityMask & _local_3 & WiredCapabilityCodes.ALL);
            if ((_local_4 & WiredCapabilityCodes.PROTOCOL) == 0)
            {
                this.resetConnection();
                return;
            }

            if (_local_2.roomId != 0)
            {
                if ((this._roomEvents.roomId <= 0) || (_local_2.roomId != this._roomEvents.roomId))
                {
                    return;
                }
                this._roomId = _local_2.roomId;
                this._roomCapabilityMask = this.applyDependencies(_local_2.roomCapabilityMask & _local_4 & WiredCapabilityCodes.ALL);
            }

            this._negotiatedRevision = _local_2.negotiatedRevision;
            this._connectionCapabilityMask = _local_4;
            this._roomEvents.refreshWiredUiConsumers();
        }

        private function get configuredClientMask():int
        {
            if (!this._roomEvents.getBoolean(WiredCapabilityCodes.PROTOCOL_ENABLED))
            {
                return 0;
            }

            var k:int = WiredCapabilityCodes.PROTOCOL;
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.ADDONS, WiredCapabilityCodes.ADDONS_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.VARIABLES, WiredCapabilityCodes.VARIABLES_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.VARIABLE_SYNC, WiredCapabilityCodes.VARIABLE_SYNC_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.SIGNALS, WiredCapabilityCodes.SIGNALS_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.REMOTE_SELECTOR, WiredCapabilityCodes.REMOTE_SELECTOR_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.WIRED_MENU, WiredCapabilityCodes.WIRED_MENU_ENABLED);
            k = this.addConfiguredMenuFeature(k, WiredCapabilityCodes.MENU_INSPECTION, WiredCapabilityCodes.MENU_INSPECTION_ENABLED);
            k = this.addConfiguredMenuFeature(k, WiredCapabilityCodes.MENU_LOGS, WiredCapabilityCodes.MENU_LOGS_ENABLED);
            k = this.addConfiguredMenuFeature(k, WiredCapabilityCodes.MENU_SETTINGS, WiredCapabilityCodes.MENU_SETTINGS_ENABLED);
            k = this.addConfiguredMenuFeature(k, WiredCapabilityCodes.MENU_VARIABLES, WiredCapabilityCodes.MENU_VARIABLES_ENABLED);
            k = this.addConfiguredMenuFeature(k, WiredCapabilityCodes.MENU_CHESTS, WiredCapabilityCodes.MENU_CHESTS_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.ENVIRONMENT_V2, WiredCapabilityCodes.ENVIRONMENT_V2_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.CLICK_SETTINGS_V2, WiredCapabilityCodes.CLICK_SETTINGS_V2_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.WIRED_MOVEMENTS, WiredCapabilityCodes.WIRED_MOVEMENTS_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.CREATOR_TOOLS, WiredCapabilityCodes.CREATOR_TOOLS_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.CHESTS, WiredCapabilityCodes.CHESTS_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.CHEST_WIRED, WiredCapabilityCodes.CHEST_WIRED_ENABLED);
            k = this.addConfiguredFeature(k, WiredCapabilityCodes.CONTRACTS, WiredCapabilityCodes.CONTRACTS_ENABLED);
            return this.applyDependencies(k & WiredCapabilityCodes.COMPILED_MASK & WiredCapabilityCodes.ALL);
        }

        private function applyDependencies(k:int):int
        {
            if ((k & WiredCapabilityCodes.VARIABLES) == 0)
            {
                k &= ~(WiredCapabilityCodes.VARIABLE_SYNC | WiredCapabilityCodes.MENU_VARIABLES);
            }
            if ((k & WiredCapabilityCodes.WIRED_MENU) == 0)
            {
                k &= ~(WiredCapabilityCodes.MENU_INSPECTION | WiredCapabilityCodes.MENU_LOGS | WiredCapabilityCodes.MENU_SETTINGS | WiredCapabilityCodes.MENU_VARIABLES | WiredCapabilityCodes.MENU_CHESTS);
            }
            if ((k & WiredCapabilityCodes.CHESTS) == 0)
            {
                k &= ~(WiredCapabilityCodes.MENU_CHESTS | WiredCapabilityCodes.CHEST_WIRED | WiredCapabilityCodes.CONTRACTS);
            }
            if ((k & WiredCapabilityCodes.CHEST_WIRED) == 0)
            {
                k &= ~WiredCapabilityCodes.CONTRACTS;
            }
            if ((k & WiredCapabilityCodes.ENVIRONMENT_V2) == 0)
            {
                k &= ~WiredCapabilityCodes.CLICK_SETTINGS_V2;
            }
            return k;
        }

        private function addConfiguredFeature(k:int, _arg_2:int, _arg_3:String):int
        {
            if (((WiredCapabilityCodes.COMPILED_MASK & _arg_2) != 0) && this._roomEvents.getBoolean(_arg_3))
            {
                return k | _arg_2;
            }
            return k;
        }

        private function addConfiguredMenuFeature(k:int, _arg_2:int, _arg_3:String):int
        {
            if (!this._roomEvents.getBoolean(WiredCapabilityCodes.WIRED_MENU_ENABLED))
            {
                return k;
            }
            return this.addConfiguredFeature(k, _arg_2, _arg_3);
        }

        public function isConnectionSupported(k:int):Boolean
        {
            return (this._negotiatedRevision == WiredCapabilityCodes.PROTOCOL_REVISION) && ((this._connectionCapabilityMask & k) == k);
        }

        public function isRoomEnabled(k:int, _arg_2:int):Boolean
        {
            return (_arg_2 > 0) && (this._roomId == _arg_2) && this.isConnectionSupported(k) && ((this._roomCapabilityMask & k) == k);
        }

        public function resetRoom():void
        {
            this._roomId = 0;
            this._roomCapabilityMask = 0;
            if (this._roomEvents != null)
            {
                this._roomEvents.refreshWiredUiConsumers();
            }
        }

        public function resetConnection():void
        {
            this._negotiatedRevision = 0;
            this._connectionCapabilityMask = 0;
            this.resetRoom();
        }

        public function dispose():void
        {
            if (this.disposed)
            {
                return;
            }
            if (this._messageEvent != null)
            {
                this._roomEvents.communication.removeHabboConnectionMessageEvent(this._messageEvent);
                this._messageEvent = null;
            }
            this.resetConnection();
            this._roomEvents = null;
        }

        public function get disposed():Boolean
        {
            return this._roomEvents == null;
        }
    }
}
