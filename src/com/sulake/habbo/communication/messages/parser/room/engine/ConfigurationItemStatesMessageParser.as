package com.sulake.habbo.communication.messages.parser.room.engine
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    public class ConfigurationItemStatesMessageParser implements IMessageParser
    {
        private var _isHanditemControlBlocked:Boolean;
        private var _chooserDisabled:Boolean;
        private var _freeFurniMovementsEnabled:Boolean;
        private var _invisibleFurni:Boolean;

        public function flush():Boolean
        {
            this._isHanditemControlBlocked = false;
            this._chooserDisabled = false;
            this._freeFurniMovementsEnabled = false;
            this._invisibleFurni = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            if (k == null)
            {
                return false;
            }
            this._isHanditemControlBlocked = k.readBoolean();
            if (k.bytesAvailable > 0) this._chooserDisabled = k.readBoolean();
            if (k.bytesAvailable > 0) this._freeFurniMovementsEnabled = k.readBoolean();
            this._invisibleFurni = ((k.bytesAvailable > 0) && k.readBoolean());
            return true;
        }

        public function get isHanditemControlBlocked():Boolean
        {
            return this._isHanditemControlBlocked;
        }

        public function get chooserDisabled():Boolean
        {
            return this._chooserDisabled;
        }

        public function get freeFurniMovementsEnabled():Boolean
        {
            return this._freeFurniMovementsEnabled;
        }

        public function get invisibleFurni():Boolean
        {
            return this._invisibleFurni;
        }
    }
}
