package com.sulake.habbo.freeflowchat.viewer.visualization
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class ManualNineSliceSprite extends Sprite
    {
        private static const ZERO_POINT:Point = new Point();

        private var _bitmap:Bitmap;
        private var _patches:Vector.<BitmapData>;
        private var _leftWidth:int;
        private var _centerWidth:int;
        private var _rightWidth:int;
        private var _topHeight:int;
        private var _middleHeight:int;
        private var _bottomHeight:int;
        private var _width:int;
        private var _height:int;

        public function ManualNineSliceSprite(scale9Grid:Rectangle, source:BitmapData)
        {
            super();
            mouseEnabled = false;
            mouseChildren = false;
            _leftWidth = scale9Grid.x;
            _centerWidth = scale9Grid.width;
            _rightWidth = source.width - int(scale9Grid.right);
            _topHeight = scale9Grid.y;
            _middleHeight = scale9Grid.height;
            _bottomHeight = source.height - int(scale9Grid.bottom);
            _width = source.width;
            _height = source.height;
            _patches = createPatches(source);
            _bitmap = new Bitmap(null, "always", false);
            addChild(_bitmap);
            redraw();
        }

        override public function get width():Number
        {
            return _width;
        }

        override public function set width(value:Number):void
        {
            var nextWidth:int = Math.max(_leftWidth + _rightWidth, Math.round(value));
            if (_width == nextWidth)
            {
                return;
            }
            _width = nextWidth;
            redraw();
        }

        override public function get height():Number
        {
            return _height;
        }

        override public function set height(value:Number):void
        {
            var nextHeight:int = Math.max(_topHeight + _bottomHeight, Math.round(value));
            if (_height == nextHeight)
            {
                return;
            }
            _height = nextHeight;
            redraw();
        }

        private function createPatches(source:BitmapData):Vector.<BitmapData>
        {
            var patches:Vector.<BitmapData> = new Vector.<BitmapData>(9, true);
            patches[0] = extractPatch(source, 0, 0, _leftWidth, _topHeight);
            patches[1] = extractPatch(source, _leftWidth, 0, _centerWidth, _topHeight);
            patches[2] = extractPatch(source, _leftWidth + _centerWidth, 0, _rightWidth, _topHeight);
            patches[3] = extractPatch(source, 0, _topHeight, _leftWidth, _middleHeight);
            patches[4] = extractPatch(source, _leftWidth, _topHeight, _centerWidth, _middleHeight);
            patches[5] = extractPatch(source, _leftWidth + _centerWidth, _topHeight, _rightWidth, _middleHeight);
            patches[6] = extractPatch(source, 0, _topHeight + _middleHeight, _leftWidth, _bottomHeight);
            patches[7] = extractPatch(source, _leftWidth, _topHeight + _middleHeight, _centerWidth, _bottomHeight);
            patches[8] = extractPatch(source, _leftWidth + _centerWidth, _topHeight + _middleHeight, _rightWidth, _bottomHeight);
            return patches;
        }

        private function extractPatch(source:BitmapData, x:int, y:int, width:int, height:int):BitmapData
        {
            if (width <= 0 || height <= 0)
            {
                return null;
            }
            var patch:BitmapData = new BitmapData(width, height, true, 0);
            patch.copyPixels(source, new Rectangle(x, y, width, height), ZERO_POINT);
            return patch;
        }

        private function redraw():void
        {
            var bitmapWidth:int = Math.max(_leftWidth + _rightWidth, _width);
            var bitmapHeight:int = Math.max(_topHeight + _bottomHeight, _height);
            var centerWidth:int = bitmapWidth - _leftWidth - _rightWidth;
            var middleHeight:int = bitmapHeight - _topHeight - _bottomHeight;
            var bitmapData:BitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
            drawPatch(bitmapData, _patches[0], 0, 0, _leftWidth, _topHeight);
            drawPatch(bitmapData, _patches[1], _leftWidth, 0, centerWidth, _topHeight);
            drawPatch(bitmapData, _patches[2], _leftWidth + centerWidth, 0, _rightWidth, _topHeight);
            drawPatch(bitmapData, _patches[3], 0, _topHeight, _leftWidth, middleHeight);
            drawPatch(bitmapData, _patches[4], _leftWidth, _topHeight, centerWidth, middleHeight);
            drawPatch(bitmapData, _patches[5], _leftWidth + centerWidth, _topHeight, _rightWidth, middleHeight);
            drawPatch(bitmapData, _patches[6], 0, _topHeight + middleHeight, _leftWidth, _bottomHeight);
            drawPatch(bitmapData, _patches[7], _leftWidth, _topHeight + middleHeight, centerWidth, _bottomHeight);
            drawPatch(bitmapData, _patches[8], _leftWidth + centerWidth, _topHeight + middleHeight, _rightWidth, _bottomHeight);
            if (_bitmap.bitmapData != null)
            {
                _bitmap.bitmapData.dispose();
            }
            _bitmap.bitmapData = bitmapData;
        }

        private function drawPatch(target:BitmapData, patch:BitmapData, x:int, y:int, width:int, height:int):void
        {
            if (patch == null || width <= 0 || height <= 0)
            {
                return;
            }
            if (patch.width == width && patch.height == height)
            {
                target.copyPixels(patch, patch.rect, new Point(x, y));
                return;
            }
            var matrix:Matrix = new Matrix();
            matrix.scale(width / patch.width, height / patch.height);
            matrix.translate(x, y);
            target.draw(patch, matrix, null, null, new Rectangle(x, y, width, height), false);
        }
    }
}
