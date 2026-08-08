package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SelectorDefinition;

    public class WiredSelectorDataMessageParser implements IMessageParser
    {
        private var _definition:SelectorDefinition;

        public function flush():Boolean
        {
            this._definition = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            this._definition = new SelectorDefinition(k);
            return true;
        }

        public function get definition():SelectorDefinition
        {
            return this._definition;
        }
    }
}
