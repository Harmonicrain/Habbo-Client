package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
{
    public final class UpdateWiredPreferencesComposer extends WiredMenuComposer
    {
        public function UpdateWiredPreferencesComposer(toolbar:Boolean, inspect:Boolean,
            playtest:Boolean, whisperDisabled:Boolean, allNotifications:Boolean,
            style:String)
        {
            super([toolbar, inspect, playtest, 0, whisperDisabled,
                allNotifications, style]);
        }
    }
}
