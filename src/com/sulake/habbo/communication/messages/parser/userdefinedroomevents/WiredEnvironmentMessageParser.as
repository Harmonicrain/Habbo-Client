package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
    import __AS3__.vec.Vector;

    public class WiredEnvironmentMessageParser implements IMessageParser
    {
        private static const MAX_ACHIEVEMENTS:int = 4096;

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
            try
            {
                WiredMessageDataValidator.requireBytes(k, 1, "Wired environment");
                this._hasClickUserWired = k.readBoolean();
                this._enabledAchievements = new Vector.<String>();
                if (k.bytesAvailable > 0)
                {
                    var count:int = WiredMessageDataValidator.readCount(k, 2,
                        MAX_ACHIEVEMENTS, "Wired environment achievements");
                    for (var i:int = 0; i < count; i++)
                    {
                        this._enabledAchievements.push(k.readString());
                    }
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
