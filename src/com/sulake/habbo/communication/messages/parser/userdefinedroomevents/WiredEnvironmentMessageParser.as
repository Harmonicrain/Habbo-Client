package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import __AS3__.vec.Vector;

    public class WiredEnvironmentMessageParser implements IMessageParser
    {
        private var _hasClickUserWired:Boolean;
        private var _enabledAchievements:Vector.<String>;

        public function flush():Boolean
        {
            this._hasClickUserWired = false;
            this._enabledAchievements = new Vector.<String>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            var count:int;
            var i:int;
            this._hasClickUserWired = k.readBoolean();
            this._enabledAchievements = new Vector.<String>();
            if (k.bytesAvailable > 0)
            {
                count = k.readInteger();
                i = 0;
                while (i < count)
                {
                    this._enabledAchievements.push(k.readString());
                    i++;
                }
            }
            return true;
        }

        public function get hasClickUserWired():Boolean
        {
            return this._hasClickUserWired;
        }

        public function get enabledAchievements():Vector.<String>
        {
            return this._enabledAchievements;
        }
    }
}
