package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.VariableDefinition;

    public class WiredVariableDataMessageParser implements IMessageParser
    {
        private var _definition:VariableDefinition;

        public function flush():Boolean
        {
            this._definition = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            var _local_2:uint = k.bytesAvailable;
            if (!WiredDefinitionParserValidator.canParse(k))
            {
                return false;
            }
            try
            {
                this._definition = new VariableDefinition(k);
            }
            catch (error:Error)
            {
                this._definition = null;
                return false;
            }
            if (!WiredDefinitionParserValidator.isComplete(k, this._definition, _local_2))
            {
                this._definition = null;
                return false;
            }
            return true;
        }

        public function get definition():VariableDefinition
        {
            return this._definition;
        }
    }
}
