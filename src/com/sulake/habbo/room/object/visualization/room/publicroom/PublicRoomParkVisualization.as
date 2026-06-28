package com.sulake.habbo.room.object.visualization.room.publicroom
{
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.utils.IRoomGeometry;

    public class PublicRoomParkVisualization extends PublicRoomVisualization
    {
        private var _busDoorOpen:Boolean = false;

        public function PublicRoomParkVisualization()
        {
            super();
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
            if (this.data == null)
            {
                return;
            }
            var _local_6:IRoomObjectModel = _local_5.getModel();
            var _local_7:Number = _local_6.getNumber(RoomObjectVariableEnum.ROOM_PUBLIC_PARK_BUS_DOOR_STATUS);
            var _local_9:String = _local_6.getString(RoomObjectVariableEnum.ROOM_WORLD_TYPE);
            if (_local_9 != "park_a")
            {
                return;
            }
            var _local_8:Boolean = ((!isNaN(_local_7)) && (_local_7 != 0));
            if (this._busDoorOpen != _local_8)
            {
                if (_local_8)
                {
                    this.data.layoutRasterizer.changeElementAlpha("bus", 0);
                    this.data.layoutRasterizer.changeElementAlpha("bus_oviopen_hidden", 255);
                }
                else
                {
                    this.data.layoutRasterizer.changeElementAlpha("bus", 255);
                    this.data.layoutRasterizer.changeElementAlpha("bus_oviopen_hidden", 0);
                }
                this._busDoorOpen = _local_8;
            }
            if (this.data.layoutRasterizer.graphicsChanged)
            {
                var _local_10:int = 0;
                while (_local_10 < this.data.layoutRasterizer.elementCount())
                {
                    this.data.layoutRasterizer.setElementToSprite(_local_10, getSprite((_local_10 + this._layerSpriteOffset)), k);
                    _local_10++;
                }
            }
        }
    }
}
