package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuRoomSettingsParser;
    public final class WiredMenuRoomSettingsEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMenuRoomSettingsEvent(callback:Function) { super(callback, WiredMenuRoomSettingsParser); }
        public function getParser():WiredMenuRoomSettingsParser { return _parser as WiredMenuRoomSettingsParser; }
    }
}
