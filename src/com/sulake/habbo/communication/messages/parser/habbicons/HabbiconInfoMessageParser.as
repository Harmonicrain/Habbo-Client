package com.sulake.habbo.communication.messages.parser.habbicons
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.catalog.habbicons.HabbiconShopItem;

    public class HabbiconInfoMessageParser implements IMessageParser
    {
        private var _habbicon:HabbiconShopItem;

        public function get habbicon():HabbiconShopItem
        {
            return this._habbicon;
        }

        public function flush():Boolean
        {
            this._habbicon = null;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Boolean
        {
            this._habbicon = HabbiconWireParsers.readShopItem(wrapper);
            return true;
        }
    }
}
