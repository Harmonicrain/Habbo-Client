package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    public class SharedGlobalPlaceholderList
    {
        private static const MAX_PLACEHOLDERS:int = 16384;
        private var _sharedPlaceholders:Array;

        public function SharedGlobalPlaceholderList(k:IMessageDataWrapper)
        {
            this._sharedPlaceholders = [];
            var count:int = WiredMessageDataValidator.readCount(k, 8, MAX_PLACEHOLDERS,
                "SharedGlobalPlaceholderList entries");
            for (var index:int = 0; index < count; index++)
            {
                this._sharedPlaceholders.push(new SharedGlobalPlaceholder(k));
            }
        }

        public function get sharedPlaceholders():Array { return this._sharedPlaceholders; }
    }
}
