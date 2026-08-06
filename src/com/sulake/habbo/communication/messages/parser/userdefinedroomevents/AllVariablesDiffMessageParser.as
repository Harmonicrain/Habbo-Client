package com.sulake.habbo.communication.messages.parser.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import flash.utils.Dictionary;

    /** Bounded July variable-diff chunk parser. */
    public class AllVariablesDiffMessageParser implements IMessageParser
    {
        private static const MAX_VARIABLES_PER_CHUNK:int = 4096;

        private var _allVariablesHash:int;
        private var _isLastChunk:Boolean;
        private var _removedVariables:Vector.<String>;
        private var _addedOrUpdated:Dictionary;

        public function flush():Boolean
        {
            this._allVariablesHash = 0;
            this._isLastChunk = false;
            this._removedVariables = null;
            this._addedOrUpdated = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            try
            {
                WiredMessageDataValidator.requireBytes(k, 13, "Variable diff chunk");
                this._allVariablesHash = k.readInteger();
                this._isLastChunk = k.readBoolean();

                var count:int = WiredMessageDataValidator.readCount(k, 2,
                    MAX_VARIABLES_PER_CHUNK, "Removed variables");
                this._removedVariables = new Vector.<String>();
                var removedIds:Object = {};
                for (var index:int = 0; index < count; index++)
                {
                    var removedId:String = k.readString();
                    if (removedIds[removedId] === true)
                    {
                        throw new Error("Variable diff chunk: duplicate removed variable " + removedId);
                    }
                    removedIds[removedId] = true;
                    this._removedVariables.push(removedId);
                }

                count = WiredMessageDataValidator.readCount(k, 29,
                    MAX_VARIABLES_PER_CHUNK, "Updated variables");
                this._addedOrUpdated = new Dictionary();
                var updatedIds:Object = {};
                for (index = 0; index < count; index++)
                {
                    var variableHash:int = k.readInteger();
                    var variable:WiredVariable = new WiredVariable(k);
                    if (removedIds[variable.variableId] === true ||
                        updatedIds[variable.variableId] === true)
                    {
                        throw new Error("Variable diff chunk: conflicting variable " + variable.variableId);
                    }
                    updatedIds[variable.variableId] = true;
                    this._addedOrUpdated[variable] = variableHash;
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

        public function get allVariablesHash():int { return this._allVariablesHash; }
        public function get isLastChunk():Boolean { return this._isLastChunk; }
        public function get removedVariables():Vector.<String> { return this._removedVariables; }
        public function get addedOrUpdated():Dictionary { return this._addedOrUpdated; }
    }
}
