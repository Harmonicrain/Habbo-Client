package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuMutationResultParser;
    public final class WiredMenuMutationResultEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMenuMutationResultEvent(callback:Function) { super(callback, WiredMenuMutationResultParser); }
        public function getParser():WiredMenuMutationResultParser { return _parser as WiredMenuMutationResultParser; }
    }
}
