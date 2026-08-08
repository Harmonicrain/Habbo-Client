package com.sulake.habbo.communication.messages.parser.habbicons
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class HabbiconShopDataMessageParser implements IMessageParser
    {
        private var _collections:Array = [];

        public function get collections():Array
        {
            return this._collections;
        }

        public function flush():Boolean
        {
            this._collections = [];
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            var count:int = wrapper.readInteger();
            this._collections = [];
            for (var index:int = 0; index < count; index++)
            {
                this._collections.push(HabbiconWireParsers.readCollection(wrapper));
            }
            return true;
        }
    }
}
