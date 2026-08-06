package com.sulake.habbo.communication.messages.parser.preferences
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class AccountPreferencesParser implements IMessageParser 
    {
        private var _traxVolume:int;
        private var _furniVolume:int;
        private var _uiVolume:int;
        private var _freeFlowChatDisabled:Boolean;
        private var _roomInvitesIgnored:Boolean;
        private var _roomCameraFollowDisabled:Boolean;
        private var _uiFlags:int;
        private var _preferedChatStyle:int;
        private var _chatSizePreference:int;
        private var _wiredMenuButton:Boolean;
        private var _wiredInspectButton:Boolean;
        private var _playTestMode:Boolean;
        private var _wiredWhisperDisabled:Boolean;
        private var _showAllNotifications:Boolean;
        private var _wiredUiStyle:String = "";


        public function get traxVolume():int
        {
            return this._traxVolume;
        }

        public function get furniVolume():int
        {
            return this._furniVolume;
        }

        public function get uiVolume():int
        {
            return this._uiVolume;
        }

        public function get freeFlowChatDisabled():Boolean
        {
            return this._freeFlowChatDisabled;
        }

        public function get roomInvitesIgnored():Boolean
        {
            return this._roomInvitesIgnored;
        }

        public function get roomCameraFollowDisabled():Boolean
        {
            return this._roomCameraFollowDisabled;
        }

        public function get uiFlags():int
        {
            return this._uiFlags;
        }

        public function get preferedChatStyle():int
        {
            return this._preferedChatStyle;
        }

        public function get chatSizePreference():int
        {
            return this._chatSizePreference;
        }

        public function get wiredMenuButton():Boolean { return _wiredMenuButton; }
        public function get wiredInspectButton():Boolean { return _wiredInspectButton; }
        public function get playTestMode():Boolean { return _playTestMode; }
        public function get wiredWhisperDisabled():Boolean { return _wiredWhisperDisabled; }
        public function get showAllNotifications():Boolean { return _showAllNotifications; }
        public function get wiredUiStyle():String { return _wiredUiStyle; }

        public function flush():Boolean
        {
            this._freeFlowChatDisabled = false;
            this._roomCameraFollowDisabled = false;
            this._uiFlags = 0;
            this._preferedChatStyle = 0;
            this._chatSizePreference = 0;
            this._wiredMenuButton = false;
            this._wiredInspectButton = false;
            this._playTestMode = false;
            this._wiredWhisperDisabled = false;
            this._showAllNotifications = false;
            this._wiredUiStyle = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            this._uiVolume = k.readInteger();
            this._furniVolume = k.readInteger();
            this._traxVolume = k.readInteger();
            this._freeFlowChatDisabled = k.readBoolean();
            this._roomInvitesIgnored = k.readBoolean();
            this._roomCameraFollowDisabled = k.readBoolean();
            this._uiFlags = k.readInteger();
            this._preferedChatStyle = k.readInteger();
            if (k.bytesAvailable >= 9)
            {
                this._wiredMenuButton = k.readBoolean();
                this._wiredInspectButton = k.readBoolean();
                this._playTestMode = k.readBoolean();
                k.readInteger();
                this._wiredWhisperDisabled = k.readBoolean();
                this._showAllNotifications = k.bytesAvailable > 0
                    ? k.readBoolean() : false;
                this._wiredUiStyle = k.bytesAvailable > 2 ? k.readString() : "";
            }
            this._chatSizePreference = k.bytesAvailable > 0 ? k.readInteger() : 0;
            return true;
        }
    }
}
