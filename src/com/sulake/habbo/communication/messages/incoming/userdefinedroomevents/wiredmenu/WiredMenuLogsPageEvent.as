package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuLogsPageParser;
    public final class WiredMenuLogsPageEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMenuLogsPageEvent(callback:Function){super(callback,WiredMenuLogsPageParser);}
        public function getParser():WiredMenuLogsPageParser{return _parser as WiredMenuLogsPageParser;}
    }
}
