package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuPermanentVariablesParser;
    public final class WiredMenuPermanentVariablesEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMenuPermanentVariablesEvent(callback:Function){super(callback,WiredMenuPermanentVariablesParser);}
        public function getParser():WiredMenuPermanentVariablesParser{return _parser as WiredMenuPermanentVariablesParser;}
    }
}
