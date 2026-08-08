package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class ChestSettingsResultMessageParser implements IMessageParser
    {
        private var _chestId:int;
        private var _notificationPreferences:Boolean;
        public function flush():Boolean
        {
            this._chestId = 0; this._notificationPreferences = false; return true;
        }
        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable != 5) { return false; }
            this._chestId = data.readInteger();
            this._notificationPreferences = data.readBoolean();
            return true;
        }
        public function get chestId():int { return this._chestId; }
        public function get isNotificationPreferences():Boolean
        {
            return this._notificationPreferences;
        }
    }
}
