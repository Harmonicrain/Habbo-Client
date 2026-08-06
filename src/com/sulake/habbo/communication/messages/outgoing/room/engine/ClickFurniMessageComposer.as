package com.sulake.habbo.communication.messages.outgoing.room.engine
{
    import com.sulake.core.communication.messages.IMessageComposer;

    /** July 2026 room-object single-click notification (official header 443). */
    public class ClickFurniMessageComposer implements IMessageComposer
    {
        private var _objectId:int;
        private var _param:int;

        public function ClickFurniMessageComposer(k:int, _arg_2:int=0)
        {
            this._objectId = k;
            this._param = _arg_2;
        }

        public function dispose():void
        {
        }

        public function getMessageArray():Array
        {
            return [this._objectId, this._param];
        }
    }
}
