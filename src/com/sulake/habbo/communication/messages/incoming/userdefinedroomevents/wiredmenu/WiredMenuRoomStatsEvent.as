package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuRoomStatsParser;
    public final class WiredMenuRoomStatsEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMenuRoomStatsEvent(callback:Function) { super(callback, WiredMenuRoomStatsParser); }
        public function getParser():WiredMenuRoomStatsParser { return _parser as WiredMenuRoomStatsParser; }
    }
}
