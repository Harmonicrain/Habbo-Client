package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class WiredClickUserResponseMessageParser implements IMessageParser
    {
        private var _index:int;
        private var _openMenu:Boolean;

        public function flush():Boolean
        {
            this._index = 0;
            this._openMenu = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            this._index = k.readInteger();
            this._openMenu = k.readBoolean();
            return true;
        }

        public function get index():int
        {
            return this._index;
        }

        public function get openMenu():Boolean
        {
            return this._openMenu;
        }
    }
}
