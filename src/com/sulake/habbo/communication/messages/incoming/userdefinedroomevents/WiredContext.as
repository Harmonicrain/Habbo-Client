package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /** July Wired 2.0 unframed editor-context blocks. */
    public class WiredContext
    {
        private static const MAX_BLOCKS:int = 7;

        private var _roomVariablesList:AllVariablesInRoom;
        private var _furniVariableInfo:VariableInfoAndHolders;
        private var _userVariableInfo:VariableInfoAndHolders;
        private var _globalVariableInfo:VariableInfoAndValue;
        private var _referenceVariablesList:SharedVariableList;
        private var _rulesetVariables:VariableList;
        private var _referencePlaceholderList:SharedGlobalPlaceholderList;

        public function WiredContext(k:IMessageDataWrapper)
        {
            super();
            var blockCount:int = WiredMessageDataValidator.readCount(k, 8, MAX_BLOCKS,
                "WiredContext blocks");
            var seen:Object = {};
            for (var index:int = 0; index < blockCount; index++)
            {
                WiredMessageDataValidator.requireBytes(k, 4, "WiredContext block type");
                var blockType:int = k.readInteger();
                if (seen[blockType] === true)
                {
                    throw new Error("WiredContext: duplicate unframed block type " + blockType);
                }
                seen[blockType] = true;

                switch (blockType)
                {
                    case WiredContextBlockTypes.ALL_VARIABLES_IN_ROOM:
                        this._roomVariablesList = new AllVariablesInRoom(k);
                        break;
                    case WiredContextBlockTypes.FURNI_VARIABLE_INFO_AND_HOLDERS:
                        this._furniVariableInfo = new VariableInfoAndHolders(k);
                        break;
                    case WiredContextBlockTypes.USER_VARIABLE_INFO_AND_HOLDERS:
                        this._userVariableInfo = new VariableInfoAndHolders(k);
                        break;
                    case WiredContextBlockTypes.GLOBAL_VARIABLE_INFO_AND_VALUE:
                        this._globalVariableInfo = new VariableInfoAndValue(k);
                        break;
                    case WiredContextBlockTypes.SHARED_VARIABLE_LIST:
                        this._referenceVariablesList = new SharedVariableList(k);
                        break;
                    case WiredContextBlockTypes.RULESET_VARIABLE_LIST:
                        this._rulesetVariables = new VariableList(k);
                        break;
                    case WiredContextBlockTypes.SHARED_GLOBAL_PLACEHOLDER_LIST:
                        this._referencePlaceholderList = new SharedGlobalPlaceholderList(k);
                        break;
                    default:
                        throw new Error("WiredContext: unknown unframed block type " + blockType);
                }
            }
        }

        public function get roomVariablesList():AllVariablesInRoom { return this._roomVariablesList; }
        public function get furniVariableInfo():VariableInfoAndHolders { return this._furniVariableInfo; }
        public function get userVariableInfo():VariableInfoAndHolders { return this._userVariableInfo; }
        public function get globalVariableInfo():VariableInfoAndValue { return this._globalVariableInfo; }
        public function get referenceVariablesList():SharedVariableList { return this._referenceVariablesList; }
        public function get rulesetVariables():VariableList { return this._rulesetVariables; }
        public function get referencePlaceholderList():SharedGlobalPlaceholderList { return this._referencePlaceholderList; }
    }
}
