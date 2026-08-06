package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestOpenInstructionMessageParser;

    public class ChestOpenInstructionMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function ChestOpenInstructionMessageEvent(callback:Function)
        {
            super(callback, ChestOpenInstructionMessageParser);
        }
        public function getParser():ChestOpenInstructionMessageParser
        {
            return this._parser as ChestOpenInstructionMessageParser;
        }
    }
}
