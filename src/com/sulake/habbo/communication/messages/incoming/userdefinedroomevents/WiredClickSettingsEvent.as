package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.WiredClickSettingsMessageParser;

    /** Client-side event for July's two-int click-settings update. */
    public class WiredClickSettingsEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredClickSettingsEvent(k:Function)
        {
            super(k, WiredClickSettingsMessageParser);
        }

        public function getParser():WiredClickSettingsMessageParser
        {
            return this._parser as WiredClickSettingsMessageParser;
        }
    }
}
