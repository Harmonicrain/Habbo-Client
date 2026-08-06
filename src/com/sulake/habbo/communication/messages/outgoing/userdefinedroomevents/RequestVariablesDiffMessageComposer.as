package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;
    import flash.utils.Dictionary;

    /** July variable-diff request: count, then repeated variable-id/hash pairs. */
    public class RequestVariablesDiffMessageComposer implements IMessageComposer, IDisposable
    {
        private static const MAX_VARIABLES:int = 4096;

        private var _array:Array;

        public function RequestVariablesDiffMessageComposer(k:Dictionary)
        {
            this._array = [];
            var ids:Array = [];
            if (k != null)
            {
                for (var id:String in k)
                {
                    ids.push(id);
                }
            }
            if (ids.length > MAX_VARIABLES)
            {
                throw new Error("Variable diff request exceeds " + MAX_VARIABLES + " entries");
            }

            // July permits any map order. Sorting makes retries byte-stable.
            ids.sort(Array.CASEINSENSITIVE);
            this._array.push(ids.length);
            for each (id in ids)
            {
                this._array.push(id);
                this._array.push(int(k[id]));
            }
        }

        public function getMessageArray():Array
        {
            return this._array;
        }

        public function dispose():void
        {
            this._array = null;
        }

        public function get disposed():Boolean
        {
            return this._array == null;
        }
    }
}
