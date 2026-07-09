package com.sulake.habbo.communication.messages.parser.habbicons
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class HabbiconStatusChangedMessageParser implements IMessageParser
    {
        private var _habbiconId:int;
        private var _habbiconState:int;

        public function get habbiconId():int
        {
            return this._habbiconId;
        }

        public function get habbiconState():int
        {
            return this._habbiconState;
        }

        public function flush():Boolean
        {
            this._habbiconId = 0;
            this._habbiconState = 0;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            this._habbiconId = wrapper.readInteger();
            this._habbiconState = wrapper.readInteger();
            return true;
        }
    }
}
