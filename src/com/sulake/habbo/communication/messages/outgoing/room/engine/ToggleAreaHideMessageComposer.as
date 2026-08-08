package com.sulake.habbo.communication.messages.outgoing.room.engine
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class ToggleAreaHideMessageComposer implements IMessageComposer
    {
        private var _furniId:int;

        public function ToggleAreaHideMessageComposer(k:int)
        {
            this._furniId = k;
        }

        public function dispose():void
        {
        }

        public function getMessageArray():Array
        {
            return [this._furniId, 0];
        }
    }
}
