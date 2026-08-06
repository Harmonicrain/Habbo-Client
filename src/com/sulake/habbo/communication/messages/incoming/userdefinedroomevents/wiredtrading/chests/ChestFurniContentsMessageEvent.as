package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestFurniContentsMessageParser;

    public class ChestFurniContentsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function ChestFurniContentsMessageEvent(callback:Function)
        {
            super(callback, ChestFurniContentsMessageParser);
        }
        public function getParser():ChestFurniContentsMessageParser
        {
            return this._parser as ChestFurniContentsMessageParser;
        }
    }
}
