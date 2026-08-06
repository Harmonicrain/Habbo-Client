package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuErrorsParser;
    public final class WiredMenuErrorsEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMenuErrorsEvent(callback:Function) { super(callback, WiredMenuErrorsParser); }
        public function getParser():WiredMenuErrorsParser { return _parser as WiredMenuErrorsParser; }
    }
}
