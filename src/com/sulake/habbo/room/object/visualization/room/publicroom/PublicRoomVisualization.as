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
        private var _managedSpriteCount:int = -1;

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
            if (((object == null) || (k == null)))
            {
                return;
            }
            this.ensureLayout(k, _arg_2);
        }

        private function addSprites(k:int):void
        {
            createSprites((this._layerSpriteOffset + k));
        }

        protected function ensureLayout(k:IRoomGeometry, _arg_2:int):void
        {
            var _local_4:int;
            if (this.data == null)
            {
                return;
            }
            var _local_2:String = object.getModel().getString(RoomObjectVariableEnum.ROOM_WORLD_TYPE);
            // The PublicRoomVisualizationData (and its layoutRasterizer) is cached per content type,
            // so park_a and park_b share one rasterizer. Keep it pointed at THIS object's world
            // before any render so the shared layout is always correct for the active room.
            this.data.layoutRasterizer.layout = _local_2;
            var _local_3:int = this.data.layoutRasterizer.elementCount();
            if (_local_3 <= 0)
            {
                return;
            }
            // SELF-HEAL: the base RoomVisualization re-runs createSprites(planeCount) on geometry /
            // cache changes (e.g. when another room sharing this content disposes and calls
            // _data.clearCache(), forcing a plane re-render). createSprites DISPOSES every sprite
            // above planeCount -> the public-room layout sprites get destroyed and the room goes
            // black (happens on a fast same-content transition like park -> infobus bus, never on a
            // fresh direct entry). Re-establish the layout sprites above the current sprite count
            // whenever the base has changed it.
            if (this._layoutInitialized && (spriteCount == this._managedSpriteCount))
            {
                if (((this.data.layoutRasterizer.hasAnimations) || (this.data.layoutRasterizer.graphicsChanged)))
                {
                    _local_4 = 0;
                    while (_local_4 < _local_3)
                    {
                        this.data.layoutRasterizer.setElementToSprite(_local_4, getSprite((this._layerSpriteOffset + _local_4)), k, _arg_2);
                        _local_4++;
                    }
                }
                return;
            }
            this._layerSpriteOffset = spriteCount;
            this.addSprites(_local_3);
            _local_4 = 0;
            while (_local_4 < _local_3)
            {
                this.data.layoutRasterizer.setElementToSprite(_local_4, getSprite((this._layerSpriteOffset + _local_4)), k, _arg_2);
                _local_4++;
            }
            this._layoutInitialized = true;
            this._managedSpriteCount = spriteCount;
        }
    }
}
