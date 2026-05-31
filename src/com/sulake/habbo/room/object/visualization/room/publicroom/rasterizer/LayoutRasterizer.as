package com.sulake.habbo.room.object.visualization.room.publicroom.rasterizer
{
    import com.sulake.core.utils.Map;
    import com.sulake.room.object.enum.AlphaTolerance;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.geom.Point;

    public class LayoutRasterizer
    {
        private var _layouts:Map;
        private var _anchor:Vector3d;
        private var _currentLayout:String;
        private var _assetCollection:IGraphicAssetCollection;

        public function LayoutRasterizer()
        {
            super();
            this._layouts = new Map();
            this._anchor = new Vector3d(-0.5, 0.5, 0);
            this._currentLayout = "";
        }

        public function initialize(k:XML):void
        {
            var _local_2:String = String(k.@name);
            this._layouts.add(_local_2, new LayoutRasterizerData(k));
        }

        public function set layout(k:String):void
        {
            this._currentLayout = k;
        }

        public function initializeAssetCollection(k:IGraphicAssetCollection):void
        {
            this._assetCollection = k;
        }

        public function elementCount():int
        {
            var k:LayoutRasterizerData = (this._layouts.getValue(this._currentLayout) as LayoutRasterizerData);
            if (k == null)
            {
                return 0;
            }
            var _local_2:XMLList = k.elementList;
            if (_local_2 == null)
            {
                return 0;
            }
            return _local_2.length();
        }

        public function setElementToSprite(k:int, _arg_2:IRoomObjectSprite, _arg_3:IRoomGeometry):void
        {
            if (((this._assetCollection == null) || (_arg_2 == null)) || (_arg_3 == null))
            {
                return;
            }
            var _local_4:LayoutRasterizerData = (this._layouts.getValue(this._currentLayout) as LayoutRasterizerData);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5:XMLList = _local_4.elementList;
            if (_local_5 == null)
            {
                return;
            }
            if (((k < 0) || (k >= _local_5.length())))
            {
                return;
            }
            var _local_6:XML = _local_5[k];
            if (_local_6 == null)
            {
                return;
            }
            var _local_7:XMLList = _local_6.visualization;
            if (((_local_7.length() == 0) || (_local_7.visualizationLayer.length() == 0)))
            {
                return;
            }
            var _local_8:XML = _local_7.visualizationLayer[0];
            var _local_9:IGraphicAsset = this._assetCollection.getAsset(_local_8.@asset);
            if (_local_9 == null)
            {
                return;
            }
            var _local_10:Point = _arg_3.getScreenPoint(new Vector3d(0, 0, 0));
            var _local_11:Point = _arg_3.getScreenPoint(this._anchor);
            _local_11.x = Math.round((_local_11.x - _local_10.x));
            _local_11.y = Math.round((_local_11.y - _local_10.y));
            _arg_2.asset = (_local_9.asset.content as BitmapData);
            _arg_2.assetName = String(_local_8.@asset);
            _arg_2.offsetX = ((int(_local_8.@x) + _local_9.offsetX) + _local_11.x);
            _arg_2.offsetY = ((int(_local_8.@y) + _local_9.offsetY) + _local_11.y);
            _arg_2.blendMode = this.getBlendMode(String(_local_8.@ink));
            _arg_2.clickHandling = false;
            _arg_2.tag = "";
            _arg_2.alphaTolerance = AlphaTolerance.MATCH_NOTHING;
            if (parseInt(_local_8.@capturesMouse) > 0)
            {
                _arg_2.clickHandling = true;
                _arg_2.alphaTolerance = AlphaTolerance.MATCH_OPAQUE_PIXELS;
                _arg_2.tag = String(_local_6.@id);
            }
            if (String(_local_8.@z) != "")
            {
                _arg_2.relativeDepth = ((-(Number(_local_8.@z)) / Math.sqrt(2)) - (0.00001 * k));
            }
            else
            {
                _arg_2.relativeDepth = (-(0.001 * k));
            }
            if (_local_8.@blend.toString().length > 0)
            {
                _arg_2.alpha = int((Number(_local_8.@blend) * 2.55));
            }
            if (_local_8.@flipH.toString().length > 0)
            {
                _arg_2.flipH = ((_local_8.@flipH == "true") || (_local_8.@flipH == "1"));
            }
        }

        private function getBlendMode(k:String):String
        {
            switch (k)
            {
                case "ADD":
                    return BlendMode.ADD;
                case "SUBTRACT":
                    return BlendMode.SUBTRACT;
                case "DARKEN":
                    return BlendMode.DARKEN;
                default:
                    return BlendMode.NORMAL;
            }
        }

        public function dispose():void
        {
            var k:int;
            var _local_2:LayoutRasterizerData;
            this._assetCollection = null;
            this._anchor = null;
            if (this._layouts != null)
            {
                k = 0;
                while (k < this._layouts.length)
                {
                    _local_2 = (this._layouts.getWithIndex(k) as LayoutRasterizerData);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._layouts.dispose();
                this._layouts = null;
            }
        }
    }
}
