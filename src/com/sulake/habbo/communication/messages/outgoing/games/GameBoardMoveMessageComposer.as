package com.sulake.habbo.communication.messages.outgoing.games
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class GameBoardMoveMessageComposer implements IMessageComposer
    {
        private var _stationId:int;
        private var _command:String;
        private var _args:Array;

        public function GameBoardMoveMessageComposer(stationId:int, command:String, args:Array)
        {
            this._stationId = stationId;
            this._command = command;
            this._args = (args == null ? [] : args);
        }

        public function getMessageArray():Array
        {
            var encodedArgs:Array = [];
            for each (var arg:Object in this._args)
            {
                encodedArgs.push(arg == null ? "" : String(arg));
            }
            return [this._stationId, this._command, encodedArgs.length].concat(encodedArgs);
        }

        public function dispose():void
        {
        }
    }
}
