package com.sulake.habbo.communication.messages.parser.habbicons
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class OwnedHabbiconsMessageParser implements IMessageParser
    {
        private var _habbicons:Array = [];
        private var _recentHabbiconIds:Array = [];

        public function get habbicons():Array
        {
            return this._habbicons;
        }

        public function get recentHabbiconIds():Array
        {
            return this._recentHabbiconIds;
        }

        public function flush():Boolean
        {
            this._habbicons = [];
            this._recentHabbiconIds = [];
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            var count:int;
            var index:int;
            this._habbicons = [];
            this._recentHabbiconIds = [];
            count = wrapper.readInteger();
            for (index = 0; index < count; index++)
            {
                this._habbicons.push(HabbiconWireParsers.readOwnedItem(wrapper));
            }
            count = wrapper.readInteger();
            for (index = 0; index < count; index++)
            {
                this._recentHabbiconIds.push(wrapper.readInteger());
            }
            return true;
        }
    }
}
