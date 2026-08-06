package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class SharedVariableList
    {
        private static const MAX_SHARED_VARIABLES:int = 16384;

        private var _sharedVariables:Array;
        private var _variables:Array;

        public function SharedVariableList(k:IMessageDataWrapper)
        {
            this._sharedVariables = [];
            this._variables = [];
            var count:int = WiredMessageDataValidator.readCount(k, 31, MAX_SHARED_VARIABLES,
                "SharedVariableList entries");
            for (var index:int = 0; index < count; index++)
            {
                var shared:SharedVariable = new SharedVariable(k);
                this._sharedVariables.push(shared);
                this._variables.push(shared.wiredVariable);
            }
        }

        public function get variables():Array { return this._variables; }
        public function get sharedVariables():Array { return this._sharedVariables; }
    }
}
