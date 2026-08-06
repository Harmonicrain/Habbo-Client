package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredValidationErrorParameter;

    public class WiredValidationErrorParser implements IMessageParser
    {
        private static const MAX_PARAMETERS:int = 128;

        private var _localizationKey:String;
        private var _parameters:Array;


        public function flush():Boolean
        {
            this._localizationKey = null;
            this._parameters = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            try
            {
                WiredMessageDataValidator.requireBytes(k, 6, "Wired validation error");
                this._localizationKey = k.readString();
                this._parameters = [];
                var count:int = WiredMessageDataValidator.readCount(k, 4,
                    MAX_PARAMETERS, "Wired validation error parameters");
                for (var index:int = 0; index < count; index++)
                {
                    this._parameters.push(new WiredValidationErrorParameter(k));
                }
                return k.bytesAvailable == 0;
            }
            catch (error:Error)
            {
                this.flush();
                return false;
            }
            return false;
        }

        public function get localizationKey():String
        {
            return this._localizationKey;
        }

        public function get parameters():Array
        {
            return this._parameters;
        }
    }
}
