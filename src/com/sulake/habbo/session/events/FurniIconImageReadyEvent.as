package com.sulake.habbo.session.events
{
    import flash.display.BitmapData;
    import flash.events.Event;

    public class FurniIconImageReadyEvent extends Event
    {
        public static const ICON_READY:String = "FIIRE_ICON_READY";

        private var _assetName:String;
        private var _wallItem:Boolean;
        private var _typeId:int;
        private var _extra:String;
        private var _furniIconImage:BitmapData;
        private var _success:Boolean;

        public function FurniIconImageReadyEvent(assetName:String, wallItem:Boolean, typeId:int, extra:String, furniIconImage:BitmapData, success:Boolean=true, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(ICON_READY, bubbles, cancelable);
            this._assetName = assetName == null ? "" : assetName;
            this._wallItem = wallItem;
            this._typeId = typeId;
            this._extra = extra == null ? "" : extra;
            this._furniIconImage = furniIconImage;
            this._success = success;
        }

        public function get assetName():String
        {
            return this._assetName;
        }

        public function get wallItem():Boolean
        {
            return this._wallItem;
        }

        public function get typeId():int
        {
            return this._typeId;
        }

        public function get extra():String
        {
            return this._extra;
        }

        public function get furniIconImage():BitmapData
        {
            return this._furniIconImage;
        }

        public function get success():Boolean
        {
            return this._success;
        }

        override public function clone():Event
        {
            return new FurniIconImageReadyEvent(this._assetName, this._wallItem, this._typeId, this._extra, this._furniIconImage, this._success, bubbles, cancelable);
        }
    }
}
