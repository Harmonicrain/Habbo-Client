package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuVariableHoldersParser;
    public final class WiredMenuVariableHoldersEvent extends MessageEvent implements IMessageEvent
    {
        public function WiredMenuVariableHoldersEvent(callback:Function) { super(callback, WiredMenuVariableHoldersParser); }
        public function getParser():WiredMenuVariableHoldersParser { return _parser as WiredMenuVariableHoldersParser; }
    }
}
