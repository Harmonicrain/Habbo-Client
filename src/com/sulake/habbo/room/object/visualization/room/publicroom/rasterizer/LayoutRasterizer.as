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
        private var _graphicsChanged:Boolean = false;
        private var _alphaOverrideTags:Array;
        private var _alphaOverrideValues:Array;

        public function LayoutRasterizer()
        {
            super();
            this._layouts = new Map();
            this._anchor = new Vector3d(-0.5, 0.5, 0);
            this._currentLayout = "";
            this._alphaOverrideTags = [];
            this._alphaOverrideValues = [];
        }

        public function get graphicsChanged():Boolean
        {
            return this._graphicsChanged;
        }

        public function changeElementAlpha(k:String, _arg_2:Number):void
        {
            this._graphicsChanged = true;
            this._alphaOverrideTags.push(k);
            this._alphaOverrideValues.push(_arg_2);
        }

        public function initialize(k:XML):void
        {
            var _local_2:String = String(k.@name);
            this._layouts.add(_local_2, new LayoutRasterizerData(k));
        }

        public function get hasAnimations():Boolean
        {
            var k:LayoutRasterizerData = (this._layouts.getValue(this._currentLayout) as LayoutRasterizerData);
            return (((!(k == null)) && (k.hasAnimations)));
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

        public function setElementToSprite(k:int, _arg_2:IRoomObjectSprite, _arg_3:IRoomGeometry, _arg_4:int=0):void
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
            var _local_9:String = this.getLayerAssetName(_local_8, _arg_4);
            var _local_10:IGraphicAsset = this._assetCollection.getAsset(_local_9);
            if (_local_10 == null)
            {
                return;
            }
            var _local_11:Point = _arg_3.getScreenPoint(new Vector3d(0, 0, 0));
            var _local_12:Point = _arg_3.getScreenPoint(this._anchor);
            _local_12.x = Math.round((_local_12.x - _local_11.x));
            _local_12.y = Math.round((_local_12.y - _local_11.y));
            _arg_2.asset = (_local_10.asset.content as BitmapData);
            _arg_2.assetName = _local_9;
            _arg_2.offsetX = ((int(_local_8.@x) + _local_10.offsetX) + _local_12.x);
            _arg_2.offsetY = ((int(_local_8.@y) + _local_10.offsetY) + _local_12.y);
            _arg_2.blendMode = this.getBlendMode(String(_local_8.@ink));
            _arg_2.clickHandling = false;
            _arg_2.tag = "";
            _arg_2.alphaTolerance = AlphaTolerance.MATCH_NOTHING;
            _arg_2.flipH = false;
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
            var _local_13:String = String(_local_6.@id);
            if (((_local_13.length > 0) && this._graphicsChanged))
            {
                var _local_14:int = this._alphaOverrideTags.indexOf(_local_13);
                if (_local_14 >= 0)
                {
                    _arg_2.alpha = this._alphaOverrideValues[_local_14];
                    this._alphaOverrideTags.splice(_local_14, 1);
                    this._alphaOverrideValues.splice(_local_14, 1);
                    if (this._alphaOverrideTags.length == 0)
                    {
                        this._graphicsChanged = false;
                    }
                }
            }
        }

        private function getLayerAssetName(k:XML, _arg_2:int):String
        {
            var _local_3:String = String(k.@asset);
            var _local_4:String = String(k.@frames);
            if (_local_4.length == 0)
            {
                return _local_3;
            }
            var _local_5:Array = _local_4.split(",");
            if (_local_5.length == 0)
            {
                return _local_3;
            }
            var _local_6:Number = parseInt(k.@frameInterval);
            if (((isNaN(_local_6)) || (_local_6 <= 0)))
            {
                _local_6 = 160;
            }
            var _local_7:int = (int((_arg_2 / _local_6)) % _local_5.length);
            var _local_8:String = String(_local_5[_local_7]);
            if (_local_8.length == 0)
            {
                return _local_3;
            }
            return _local_8;
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
