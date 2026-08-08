package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    /** July Wired click-settings update: [userOption:int, furniOption:int]. */
    public class WiredClickSettingsMessageParser implements IMessageParser
    {
        private var _userOption:int;
        private var _furniOption:int;

        public function flush():Boolean
        {
            this._userOption = 0;
            this._furniOption = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            if (k.bytesAvailable != 8)
            {
                return false;
            }
            this._userOption = k.readInteger();
            this._furniOption = k.readInteger();
            return true;
        }

        public function get userOption():int
        {
            return this._userOption;
        }

        public function get furniOption():int
        {
            return this._furniOption;
        }
    }
}
