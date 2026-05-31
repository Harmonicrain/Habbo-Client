package com.sulake.habbo.room.object.visualization.room.publicroom
{
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.visualization.room.RoomVisualization;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.utils.IRoomGeometry;

    public class PublicRoomVisualization extends RoomVisualization
    {
        protected var _layerSpriteOffset:int = 0;
        private var _layoutInitialized:Boolean = false;

        public function PublicRoomVisualization()
        {
            super();
        }

        protected function get data():PublicRoomVisualizationData
        {
            return (this._data as PublicRoomVisualizationData);
        }

        override public function get floorRelativeDepth():Number
        {
            return 131;
        }

        override public function get wallRelativeDepth():Number
        {
            return 135;
        }

        override public function initialize(k:IRoomObjectVisualizationData):Boolean
        {
            if (!(k is PublicRoomVisualizationData))
            {
                return false;
            }
            return super.initialize(k);
        }

        override public function update(k:IRoomGeometry, _arg_2:int, _arg_3:Boolean, _arg_4:Boolean):void
        {
            super.update(k, _arg_2, _arg_3, _arg_4);
            var _local_5:IRoomObject = object;
            if (_local_5 == null)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            this.initializeLayout(k);
        }

        private function addSprites(k:int):void
        {
            createSprites((this._layerSpriteOffset + k));
        }

        private function initializeLayout(k:IRoomGeometry):void
        {
            var _local_2:IRoomObjectModel;
            var _local_3:String;
            var _local_4:int;
            if (this._layoutInitialized)
            {
                return;
            }
            if (this.data != null)
            {
                _local_2 = object.getModel();
                _local_3 = _local_2.getString(RoomObjectVariableEnum.ROOM_WORLD_TYPE);
                this.data.layoutRasterizer.layout = _local_3;
                this._layerSpriteOffset = spriteCount;
                this.addSprites(this.data.layoutRasterizer.elementCount());
                _local_4 = 0;
                while (_local_4 < this.data.layoutRasterizer.elementCount())
                {
                    this.data.layoutRasterizer.setElementToSprite(_local_4, getSprite((_local_4 + this._layerSpriteOffset)), k);
                    _local_4++;
                }
            }
            this._layoutInitialized = true;
        }
    }
}
