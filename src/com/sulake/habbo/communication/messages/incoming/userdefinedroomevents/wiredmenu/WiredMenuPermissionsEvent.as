package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuPermissionsParser;
    public final class WiredMenuPermissionsEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMenuPermissionsEvent(callback:Function) { super(callback, WiredMenuPermissionsParser); }
        public function getParser():WiredMenuPermissionsParser { return _parser as WiredMenuPermissionsParser; }
    }
}
