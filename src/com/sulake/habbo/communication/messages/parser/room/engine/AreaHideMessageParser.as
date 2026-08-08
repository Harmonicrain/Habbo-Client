package com.sulake.habbo.communication.messages.parser.room.engine
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.AreaHideMessageData;

    public class AreaHideMessageParser implements IMessageParser
    {
        private var _areaHideMessageData:AreaHideMessageData;

        public function flush():Boolean
        {
            this._areaHideMessageData = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            if (k == null)
            {
                return false;
            }
            this._areaHideMessageData = new AreaHideMessageData(k);
            return true;
        }

        public function get areaHideMessageData():AreaHideMessageData
        {
            return this._areaHideMessageData;
        }
    }
}
