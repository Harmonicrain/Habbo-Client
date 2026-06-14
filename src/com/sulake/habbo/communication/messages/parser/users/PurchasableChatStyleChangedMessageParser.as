package com.sulake.habbo.communication.messages.parser.users
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class PurchasableChatStyleChangedMessageParser implements IMessageParser
    {
        private var _styleId:int;
        private var _owned:Boolean;

        public function get styleId():int
        {
            return this._styleId;
        }

        public function get owned():Boolean
        {
            return this._owned;
        }

        public function flush():Boolean
        {
            this._styleId = 0;
            this._owned = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            this._styleId = k.readInteger();
            this._owned = k.readBoolean();
            return true;
        }
    }
}
