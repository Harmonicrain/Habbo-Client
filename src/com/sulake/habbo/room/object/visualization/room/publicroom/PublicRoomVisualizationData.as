package com.sulake.habbo.room.object.visualization.room.publicroom
{
    import com.sulake.habbo.room.object.visualization.room.RoomVisualizationData;
    import com.sulake.habbo.room.object.visualization.room.publicroom.rasterizer.LayoutRasterizer;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;

    public class PublicRoomVisualizationData extends RoomVisualizationData
    {
        private var _layoutRasterizer:LayoutRasterizer;

        public function PublicRoomVisualizationData()
        {
            super();
            this._layoutRasterizer = new LayoutRasterizer();
        }

        public function get layoutRasterizer():LayoutRasterizer
        {
            return this._layoutRasterizer;
        }

        override public function initialize(k:XML):Boolean
        {
            var _local_4:XML;
            if (!super.initialize(k))
            {
                return false;
            }
            if (k == null)
            {
                return false;
            }
            var _local_2:XMLList = k.layoutData;
            var _local_3:int;
            while (_local_3 < _local_2.length())
            {
                _local_4 = _local_2[_local_3];
                this._layoutRasterizer.initialize(_local_4);
                _local_3++;
            }
            return true;
        }

        override public function initializeAssetCollection(k:IGraphicAssetCollection):void
        {
            if (initialized)
            {
                return;
            }
            super.initializeAssetCollection(k);
            this._layoutRasterizer.initializeAssetCollection(k);
        }

        override protected function reset():void
        {
            super.reset();
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._layoutRasterizer != null)
            {
                this._layoutRasterizer.dispose();
                this._layoutRasterizer = null;
            }
        }
    }
}
