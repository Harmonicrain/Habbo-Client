package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;

    public class WiredDefinitionParserValidator
    {
        // Empty July-format definitions consume 68 bytes. The upper bound prevents
        // category packets from turning an invalid count into unbounded work.
        private static const MIN_DEFINITION_BYTES:uint = 68;
        private static const MAX_DEFINITION_BYTES:uint = 1024 * 1024;

        public static function canParse(k:IMessageDataWrapper):Boolean
        {
            return k.bytesAvailable >= MIN_DEFINITION_BYTES && k.bytesAvailable <= MAX_DEFINITION_BYTES;
        }

        public static function isComplete(k:IMessageDataWrapper, _arg_2:Triggerable, _arg_3:uint):Boolean
        {
            if ((_arg_2 == null) || (k.bytesAvailable != 0))
            {
                return false;
            }

            // Collection counts are validated before allocation/iteration by
            // Triggerable, InputSourcesConf, and WiredContext. Completion only
            // needs to reject trailing or partially consumed bytes.
            return _arg_2.inputSourcesConf != null;
        }
    }
}
