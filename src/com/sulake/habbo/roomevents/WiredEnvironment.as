package com.sulake.habbo.roomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredClickSettingsEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredClickUserResponseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredEnvironmentEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredClickSettingsMessageParser;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredClickUserResponseMessageParser;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredEnvironmentMessageParser;
    import com.sulake.habbo.room.IRoomEngineServices;
    import com.sulake.habbo.roomevents.events.WiredAchievementsUpdatedEvent;
    import com.sulake.habbo.roomevents.events.WiredUserClickHandledEvent;
    import __AS3__.vec.Vector;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    /**
     * Owns July's room-scoped Wired environment state. Achievement identifiers
     * remain protocol data without exposing Creator Tools authoring.
     */
    public class WiredEnvironment implements IDisposable
    {
        public static const CLICK_USER_DEFAULT:int = 0;
        public static const CLICK_USER_WALK_BEHIND:int = 1;
        public static const CLICK_USER_PASS_THROUGH:int = 2;
        public static const CLICK_FURNI_DEFAULT:int = 0;
        public static const CLICK_FURNI_PASS_THROUGH:int = 1;

        private static const CLICK_SETTINGS_OWNER:String = "wired_env";
        private static const CLICK_SETTINGS_NOTIFICATION_ID:String = "wired_click_settings_toggle";

        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _messageEvents:Array = [];
        private var _hasClickUserWired:Boolean;
        private var _achievements:Vector.<String> = new Vector.<String>();
        private var _clickUserOption:int;
        private var _clickFurniOption:int;
        private var _ignored:Boolean;
        private var _hideTimeout:uint = uint.MAX_VALUE;
        private var _disposed:Boolean;

        public function WiredEnvironment(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this.addMessageEvent(new WiredEnvironmentEvent(this.onEnvironment));
            this.addMessageEvent(new WiredClickUserResponseEvent(this.onClickUserResponse));
            this.addMessageEvent(new WiredClickSettingsEvent(this.onClickSettings));
        }

        private function addMessageEvent(event:IMessageEvent):void
        {
            this._messageEvents.push(
                this._roomEvents.communication.addHabboConnectionMessageEvent(event));
        }

        private function onEnvironment(event:IMessageEvent):void
        {
            var parser:WiredEnvironmentMessageParser =
                (event as WiredEnvironmentEvent).getParser();
            this._hasClickUserWired = parser.hasClickUserWired;
            this._achievements = parser.enabledAchievements != null
                ? parser.enabledAchievements.concat()
                : new Vector.<String>();
            this._roomEvents.events.dispatchEvent(new WiredAchievementsUpdatedEvent(
                WiredAchievementsUpdatedEvent.WIRED_ACHIEVEMENTS_UPDATED,
                this._achievements));
        }

        private function onClickUserResponse(event:IMessageEvent):void
        {
            var parser:WiredClickUserResponseMessageParser =
                (event as WiredClickUserResponseEvent).getParser();
            this._roomEvents.events.dispatchEvent(new WiredUserClickHandledEvent(
                WiredUserClickHandledEvent.WIRED_USER_CLICK_HANDLED,
                parser.index, parser.openMenu));
        }

        private function onClickSettings(event:IMessageEvent):void
        {
            var parser:WiredClickSettingsMessageParser =
                (event as WiredClickSettingsEvent).getParser();
            var userOption:int = this.normalizeUserOption(parser.userOption);
            var furniOption:int = this.normalizeFurniOption(parser.furniOption);
            var changed:Boolean = userOption != this._clickUserOption
                || furniOption != this._clickFurniOption;

            if (this._ignored && !this._roomEvents.hasWiredMenuWritePermission)
            {
                this._ignored = false;
                changed = true;
                this.removeClickSettingsNotification();
            }
            if (!changed)
            {
                return;
            }

            this._clickUserOption = userOption;
            this._clickFurniOption = furniOption;
            if (!this.hasActiveClickSettings())
            {
                clearTimeout(this._hideTimeout);
                this._hideTimeout = setTimeout(this.hideNotificationIfInactive, 3000);
            }

            if (this._ignored)
            {
                var ignoredMessage:String = this._roomEvents.localization.getLocalization(
                    "notification.click_settings_ignored", "Wired click settings are ignored");
                if (this.hasActiveClickSettings())
                {
                    ignoredMessage += " " + this._roomEvents.localization.getLocalization(
                        "notification.click_settings", "Wired click settings changed");
                }
                this._roomEvents.notifications.addItem(ignoredMessage, "wired");
                return;
            }

            this.applyClickSettings(this._clickUserOption, this._clickFurniOption);
            var message:String = this._roomEvents.localization.getLocalization(
                "notification.click_settings", "Wired click settings changed");
            if (this._roomEvents.hasWiredMenuWritePermission && this.hasActiveClickSettings())
            {
                var extraData:Object = {};
                extraData["id"] = CLICK_SETTINGS_NOTIFICATION_ID;
                extraData["stay"] = true;
                extraData["toggle_callback"] = this.onToggleClickSettings;
                this._roomEvents.notifications.addItem(message, "wired", null, null, extraData);
            }
            else
            {
                this._roomEvents.notifications.addItem(message, "wired");
            }
        }

        private function onToggleClickSettings(ignored:Boolean):void
        {
            this._ignored = ignored;
            if (ignored)
            {
                this.applyClickSettings(CLICK_USER_DEFAULT, CLICK_FURNI_DEFAULT);
            }
            else
            {
                this.applyClickSettings(this._clickUserOption, this._clickFurniOption);
            }
        }

        private function hideNotificationIfInactive():void
        {
            if (!this.hasActiveClickSettings())
            {
                this._ignored = false;
                this.removeClickSettingsNotification();
            }
        }

        private function removeClickSettingsNotification():void
        {
            if (this._roomEvents != null && this._roomEvents.notifications != null)
            {
                this._roomEvents.notifications.removeNotificationById(
                    CLICK_SETTINGS_NOTIFICATION_ID);
            }
        }

        private function applyClickSettings(userOption:int, furniOption:int):void
        {
            if (this._roomEvents.roomEngine != null)
            {
                (this._roomEvents.roomEngine as IRoomEngineServices).setClickSettings(
                    CLICK_SETTINGS_OWNER,
                    userOption == CLICK_USER_PASS_THROUGH,
                    furniOption == CLICK_FURNI_PASS_THROUGH);
            }
        }

        private function normalizeUserOption(value:int):int
        {
            return value >= CLICK_USER_DEFAULT && value <= CLICK_USER_PASS_THROUGH
                ? value : CLICK_USER_DEFAULT;
        }

        private function normalizeFurniOption(value:int):int
        {
            return value >= CLICK_FURNI_DEFAULT && value <= CLICK_FURNI_PASS_THROUGH
                ? value : CLICK_FURNI_DEFAULT;
        }

        private function hasActiveClickSettings():Boolean
        {
            return this._clickUserOption != CLICK_USER_DEFAULT
                || this._clickFurniOption != CLICK_FURNI_DEFAULT;
        }

        public function leaveRoom():void
        {
            this.removeClickSettingsNotification();
            clearTimeout(this._hideTimeout);
            this._hideTimeout = uint.MAX_VALUE;
            this._hasClickUserWired = false;
            this._achievements = new Vector.<String>();
            this._ignored = false;
            this._clickUserOption = CLICK_USER_DEFAULT;
            this._clickFurniOption = CLICK_FURNI_DEFAULT;
            this.applyClickSettings(CLICK_USER_DEFAULT, CLICK_FURNI_DEFAULT);
            if (this._roomEvents != null)
            {
                this._roomEvents.events.dispatchEvent(new WiredAchievementsUpdatedEvent(
                    WiredAchievementsUpdatedEvent.WIRED_ACHIEVEMENTS_UPDATED,
                    this._achievements));
            }
        }

        public function get hasClickUserWired():Boolean
        {
            return this._hasClickUserWired;
        }

        public function get achievements():Vector.<String>
        {
            return this._achievements.concat();
        }

        public function get clickUserOption():int
        {
            return this._ignored ? CLICK_USER_DEFAULT : this._clickUserOption;
        }

        public function get clickFurniOption():int
        {
            return this._ignored ? CLICK_FURNI_DEFAULT : this._clickFurniOption;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this.leaveRoom();
            if (this._roomEvents != null && this._roomEvents.communication != null)
            {
                for each (var event:IMessageEvent in this._messageEvents)
                {
                    this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
                }
            }
            this._messageEvents = null;
            this._roomEvents = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }
    }
}
