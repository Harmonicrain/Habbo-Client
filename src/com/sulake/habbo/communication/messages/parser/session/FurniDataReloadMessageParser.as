package com.sulake.habbo.communication.messages.parser.session
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class FurniDataReloadMessageParser implements IMessageParser
    {
        private var _reloadToken:String;

        public function flush():Boolean
        {
            this._reloadToken = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            this._reloadToken = k.readString();
            return true;
        }

        public function get reloadToken():String
        {
            return this._reloadToken;
        }
    }
}
