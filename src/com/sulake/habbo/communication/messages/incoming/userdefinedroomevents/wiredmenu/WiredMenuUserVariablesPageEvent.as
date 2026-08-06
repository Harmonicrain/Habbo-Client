package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuUserVariablesPageParser;
    public final class WiredMenuUserVariablesPageEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMenuUserVariablesPageEvent(callback:Function){super(callback,WiredMenuUserVariablesPageParser);}
        public function getParser():WiredMenuUserVariablesPageParser{return _parser as WiredMenuUserVariablesPageParser;}
    }
}
