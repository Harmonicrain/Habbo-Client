package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    /**
     * July's inspection error response is a signed short:
     * 0 = selected holder disappeared/was invalid, 1/2 = rejected operation.
     */
    public final class WiredMenuErrorParser implements IMessageParser
    {
        private var _errorCode:int;

        public function flush():Boolean
        {
            this._errorCode = 0;
            return true;
        }

        public function parse(data:IMessageDataWrapper):Boolean
        {
            if (data.bytesAvailable != 2)
            {
                return false;
            }
            this._errorCode = data.readShort();
            return data.bytesAvailable == 0;
        }

        public function get errorCode():int
        {
            return this._errorCode;
        }
    }
}
