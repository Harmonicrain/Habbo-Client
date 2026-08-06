package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class VariableInfoAndHolders
    {
        private static const MAX_HOLDERS:int = 65535;

        private var _variable:WiredVariable;
        private var _holders:Array;

        public function VariableInfoAndHolders(k:IMessageDataWrapper)
        {
            WiredMessageDataValidator.requireBytes(k, 29, "VariableInfoAndHolders");
            this._variable = new WiredVariable(k);
            this._holders = [];
            var count:int = WiredMessageDataValidator.readCount(k, 8, MAX_HOLDERS,
                "VariableInfoAndHolders holders");
            for (var index:int = 0; index < count; index++)
            {
                this._holders.push(new ObjectIdAndValuePair(k));
            }
        }

        public function get variable():WiredVariable { return this._variable; }
        public function get holders():Array { return this._holders; }
    }
}
