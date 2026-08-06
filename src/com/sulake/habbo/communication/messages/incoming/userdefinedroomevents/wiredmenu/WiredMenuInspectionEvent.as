package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuInspectionParser;
    public final class WiredMenuInspectionEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMenuInspectionEvent(callback:Function) { super(callback, WiredMenuInspectionParser); }
        public function getParser():WiredMenuInspectionParser { return _parser as WiredMenuInspectionParser; }
    }
}
