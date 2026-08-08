package com.sulake.habbo.communication.messages.incoming.room.engine
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.room.IAreaHideInfo;

    public class AreaHideMessageData implements IAreaHideInfo
    {
        private var _furniId:int;
        private var _on:Boolean;
        private var _rootX:int;
        private var _rootY:int;
        private var _width:int;
        private var _length:int;
        private var _invert:Boolean;

        public function AreaHideMessageData(k:IMessageDataWrapper)
        {
            this._furniId = k.readInteger();
            this._on = k.readBoolean();
            this._rootX = k.readInteger();
            this._rootY = k.readInteger();
            this._width = k.readInteger();
            this._length = k.readInteger();
            this._invert = k.readBoolean();
        }

        public function get furniId():int { return this._furniId; }
        public function get on():Boolean { return this._on; }
        public function get rootX():int { return this._rootX; }
        public function get rootY():int { return this._rootY; }
        public function get width():int { return this._width; }
        public function get length():int { return this._length; }
        public function get invert():Boolean { return this._invert; }
    }
}
