package com.sulake.habbo.room.object.visualization.room.publicroom.rasterizer
{
    public class LayoutRasterizerData
    {
        private var _elementList:XMLList;
        private var _hasAnimations:Boolean;

        public function LayoutRasterizerData(k:XML)
        {
            var _local_2:XML;
            var _local_3:XMLList;
            super();
            this._elementList = k.elements.element;
            this._hasAnimations = false;
            for each (_local_2 in this._elementList)
            {
                _local_3 = _local_2.visualization.visualizationLayer;
                if (((_local_3.length() > 0) && (String(_local_3[0].@frames).length > 0)))
                {
                    this._hasAnimations = true;
                    break;
                }
            }
        }

        public function get elementList():XMLList
        {
            return this._elementList;
        }

        public function get hasAnimations():Boolean
        {
            return this._hasAnimations;
        }

        public function dispose():void
        {
            this._elementList = null;
        }
    }
}
