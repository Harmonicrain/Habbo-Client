package com.sulake.habbo.communication.messages.parser.room.publicroom
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class BusDoorMessageParser implements IMessageParser
    {
        private var _open:Boolean = false;

        public function get open():Boolean
        {
            return this._open;
        }

        public function flush():Boolean
        {
            this._open = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            if (k == null)
            {
                return false;
            }
            this._open = k.readBoolean();
            return true;
        }
    }
}
