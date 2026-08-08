package com.sulake.habbo.communication.messages.parser.games
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class GameBoardUpdateMessageParser implements IMessageParser
    {
        private var _stationId:int = 0;
        private var _verb:String = "";
        private var _args:Array = null;

        public function get stationId():int
        {
            return this._stationId;
        }

        public function get verb():String
        {
            return this._verb;
        }

        public function get args():Array
        {
            return this._args;
        }

        public function flush():Boolean
        {
            this._stationId = 0;
            this._verb = "";
            this._args = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            if (k == null)
            {
                return false;
            }
            this._stationId = k.readInteger();
            this._verb = k.readString();
            this._args = [];
            var argCount:int = k.readInteger();
            for (var i:int = 0; i < argCount; i++)
            {
                this._args.push(k.readString());
            }
            return true;
        }
    }
}
