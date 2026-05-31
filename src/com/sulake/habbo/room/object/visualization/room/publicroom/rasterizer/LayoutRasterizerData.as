package com.sulake.habbo.room.object.visualization.room.publicroom.rasterizer
{
    public class LayoutRasterizerData
    {
        private var _elementList:XMLList;

        public function LayoutRasterizerData(k:XML)
        {
            super();
            this._elementList = k.elements.element;
        }

        public function get elementList():XMLList
        {
            return this._elementList;
        }

        public function dispose():void
        {
            this._elementList = null;
        }
    }
}
