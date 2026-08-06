package com.sulake.habbo.communication.messages.outgoing.room.engine
{
    import com.sulake.core.communication.messages.IMessageComposer;

    public class SaveAreaHideMessageComposer implements IMessageComposer
    {
        private var _data:Array;

        public function SaveAreaHideMessageComposer(k:int, rootX:int, rootY:int, width:int, length:int, invisibility:Boolean, wallItems:Boolean, invert:Boolean)
        {
            this._data = [k, rootX, rootY, width, length, invisibility, wallItems, invert];
        }

        public function dispose():void
        {
            this._data = null;
        }

        public function getMessageArray():Array
        {
            return this._data;
        }
    }
}
