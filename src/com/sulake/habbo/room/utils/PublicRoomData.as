package com.sulake.habbo.room.utils
{
    import com.sulake.core.utils.Map;

    public class PublicRoomData
    {
        private var _type:String = "";
        private var _worlds:Map;

        public function PublicRoomData(k:String)
        {
            super();
            this._type = k;
            this._worlds = new Map();
        }

        public function get type():String
        {
            return this._type;
        }

        public function addWorld(k:String, _arg_2:Number, _arg_3:Number):Boolean
        {
            if (this._worlds.getValue(k) != null)
            {
                return false;
            }
            this._worlds.add(k, new PublicRoomWorldData(k, _arg_2, _arg_3));
            return true;
        }

        public function hasWorldType(k:String):Boolean
        {
            return (this._worlds.getValue(k) != null);
        }

        public function getWorldScale(k:String):Number
        {
            var _local_2:PublicRoomWorldData = (this._worlds.getValue(k) as PublicRoomWorldData);
            if (_local_2 != null)
            {
                return _local_2.scale;
            }
            return 1;
        }

        public function getWorldHeightScale(k:String):Number
        {
            var _local_2:PublicRoomWorldData = (this._worlds.getValue(k) as PublicRoomWorldData);
            if (_local_2 != null)
            {
                return _local_2.heightScale;
            }
            return 1;
        }
    }
}
