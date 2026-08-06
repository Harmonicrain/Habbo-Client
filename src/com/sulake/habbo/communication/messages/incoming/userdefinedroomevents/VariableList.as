package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class VariableList
    {
        private static const MAX_VARIABLES:int = 16384;
        private var _variables:Array;

        public function VariableList(k:IMessageDataWrapper)
        {
            this._variables = [];
            var count:int = WiredMessageDataValidator.readCount(k, 25, MAX_VARIABLES,
                "VariableList entries");
            for (var index:int = 0; index < count; index++)
            {
                this._variables.push(new WiredVariable(k));
            }
        }

        public function get variables():Array { return this._variables; }
    }
}
