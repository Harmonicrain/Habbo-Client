package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class WiredCapabilitiesMessageParser implements IMessageParser
    {
        private var _negotiatedRevision:int;
        private var _connectionCapabilityMask:int;
        private var _roomId:int;
        private var _roomCapabilityMask:int;

        public function flush():Boolean
        {
            this._negotiatedRevision = 0;
            this._connectionCapabilityMask = 0;
            this._roomId = 0;
            this._roomCapabilityMask = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            if (k.bytesAvailable != 16)
            {
                return false;
            }
            this._negotiatedRevision = k.readInteger();
            this._connectionCapabilityMask = k.readInteger();
            this._roomId = k.readInteger();
            this._roomCapabilityMask = k.readInteger();
            return true;
        }

        public function get negotiatedRevision():int
        {
            return this._negotiatedRevision;
        }

        public function get connectionCapabilityMask():int
        {
            return this._connectionCapabilityMask;
        }

        public function get roomId():int
        {
            return this._roomId;
        }

        public function get roomCapabilityMask():int
        {
            return this._roomCapabilityMask;
        }
    }
}
