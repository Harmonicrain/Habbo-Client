package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;

    /** July wired-trading chest item type. */
    public class ChestItemType
    {
        private var _isWallItem:Boolean;
        private var _typeId:int;
        private var _legacyPosterId:String;
        public function ChestItemType(isWallItem:Boolean, typeId:int, legacyPosterId:String)
        { this._isWallItem=isWallItem; this._typeId=typeId; this._legacyPosterId=legacyPosterId; }
        public static function readFromMessage(data:IMessageDataWrapper):ChestItemType
        { WiredMessageDataValidator.requireBytes(data, 6, "ChestItemType"); var wall:Boolean=data.readBoolean(); var type:int=data.readInteger(); var poster:String=data.readString(); return new ChestItemType(wall, type, poster==""?null:poster); }
        public function get isWallItem():Boolean{return this._isWallItem;} public function get typeId():int{return this._typeId;} public function get legacyPosterId():String{return this._legacyPosterId==null?"":this._legacyPosterId;}
        public function addToComposer(out:Array):void{out.push(this._isWallItem,this._typeId,this.legacyPosterId);}
    }
}
