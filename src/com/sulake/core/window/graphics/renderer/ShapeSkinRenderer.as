package com.sulake.core.window.graphics.renderer
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ShapeController;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.geom.Rectangle;

    public class ShapeSkinRenderer extends SkinRenderer
    {
        private static const SHAPE:Shape = new Shape();

        public function ShapeSkinRenderer(k:String)
        {
            super(k);
        }

        public static function alphaFromColor(color:uint):Number
        {
            var alpha:uint = uint(((color >>> 24) & 0xFF));
            return ((alpha == 0) ? 1 : (alpha / 0xFF));
        }

        private static function cornerRadius(radius:Number, width:Number, height:Number):int
        {
            if (((isNaN(radius)) || (isNaN(width)) || (isNaN(height)) || (radius <= 0) || (width <= 0) || (height <= 0)))
            {
                return 0;
            }
            return int(Math.min(Math.round(radius), Math.floor(width / 2), Math.floor(height / 2)));
        }

        private static function snap(value:Number):int
        {
            return (isNaN(value) ? 0 : int(Math.round(value)));
        }

        private static function snappedThickness(value:Number):int
        {
            return (((isNaN(value)) || (value <= 0)) ? 0 : int(Math.max(1, Math.round(value))));
        }

        private static function roundRectContainsPixel(px:int, py:int, left:int, top:int, right:int, bottom:int, radius:int):Boolean
        {
            var nearestX:Number;
            var nearestY:Number;
            var dx:Number;
            var dy:Number;
            var r:Number = radius;
            var cx:Number = (px + 0.5);
            var cy:Number = (py + 0.5);
            if (((cx < left) || (cy < top) || (cx >= right) || (cy >= bottom)))
            {
                return false;
            }
            if (r <= 0)
            {
                return true;
            }
            nearestX = ((cx < (left + r)) ? (left + r) : ((cx >= (right - r)) ? (right - r) : cx));
            nearestY = ((cy < (top + r)) ? (top + r) : ((cy >= (bottom - r)) ? (bottom - r) : cy));
            dx = (cx - nearestX);
            dy = (cy - nearestY);
            return (((dx * dx) + (dy * dy)) <= (r * r));
        }

        private static function argbFromColor(color:uint):uint
        {
            var alpha:uint = uint(((color >>> 24) & 0xFF));
            return ((((alpha == 0) ? 0xFF : alpha) << 24) | (color & 0xFFFFFF));
        }

        private static function blendPixel(target:BitmapData, px:int, py:int, color:uint, coverage:Number):void
        {
            if (coverage <= 0)
            {
                return;
            }
            if (coverage > 1)
            {
                coverage = 1;
            }
            var alphaByte:uint = uint(((color >>> 24) & 0xFF));
            var srcAlpha:Number = ((((alphaByte == 0) ? 0xFF : alphaByte) / 0xFF) * coverage);
            if (srcAlpha >= 1)
            {
                target.setPixel32(px, py, (0xFF000000 | (color & 0xFFFFFF)));
                return;
            }
            var dst:uint = target.getPixel32(px, py);
            var dstAlpha:Number = (((dst >>> 24) & 0xFF) / 0xFF);
            var outAlpha:Number = (srcAlpha + (dstAlpha * (1 - srcAlpha)));
            if (outAlpha <= 0)
            {
                target.setPixel32(px, py, 0);
                return;
            }
            var srcR:Number = ((color >>> 16) & 0xFF);
            var srcG:Number = ((color >>> 8) & 0xFF);
            var srcB:Number = (color & 0xFF);
            var dstR:Number = ((dst >>> 16) & 0xFF);
            var dstG:Number = ((dst >>> 8) & 0xFF);
            var dstB:Number = (dst & 0xFF);
            var outR:uint = Math.min(0xFF, Math.round((((srcR * srcAlpha) + ((dstR * dstAlpha) * (1 - srcAlpha))) / outAlpha)));
            var outG:uint = Math.min(0xFF, Math.round((((srcG * srcAlpha) + ((dstG * dstAlpha) * (1 - srcAlpha))) / outAlpha)));
            var outB:uint = Math.min(0xFF, Math.round((((srcB * srcAlpha) + ((dstB * dstAlpha) * (1 - srcAlpha))) / outAlpha)));
            var outA:uint = Math.min(0xFF, Math.round(outAlpha * 0xFF));
            target.setPixel32(px, py, ((((outA << 24) | (outR << 16)) | (outG << 8)) | outB));
        }

        private static function fillPixelRect(target:BitmapData, left:int, top:int, right:int, bottom:int, color:uint):void
        {
            left = Math.max(0, left);
            top = Math.max(0, top);
            right = Math.min(target.width, right);
            bottom = Math.min(target.height, bottom);
            if (((right <= left) || (bottom <= top)))
            {
                return;
            }
            target.fillRect(new Rectangle(left, top, (right - left), (bottom - top)), argbFromColor(color));
        }

        private static function drawRectFill(target:BitmapData, x:Number, y:Number, width:Number, height:Number, color:uint):void
        {
            fillPixelRect(target, snap(x), snap(y), snap(x + width), snap(y + height), color);
        }

        private static function drawRectStroke(target:BitmapData, x:Number, y:Number, width:Number, height:Number, thickness:Number, color:uint):void
        {
            var px:int;
            var py:int;
            var left:int = snap(x);
            var top:int = snap(y);
            var right:int = snap(x + width);
            var bottom:int = snap(y + height);
            var snapped:int = snappedThickness(thickness);
            var clipLeft:int = Math.max(0, left);
            var clipTop:int = Math.max(0, top);
            var clipRight:int = Math.min(target.width, right);
            var clipBottom:int = Math.min(target.height, bottom);
            if (((snapped <= 0) || (right <= left) || (bottom <= top)))
            {
                return;
            }
            py = clipTop;
            while (py < clipBottom)
            {
                px = clipLeft;
                while (px < clipRight)
                {
                    if (((px < (left + snapped)) || (px >= (right - snapped)) || (py < (top + snapped)) || (py >= (bottom - snapped))))
                    {
                        blendPixel(target, px, py, color, 1);
                    }
                    px++;
                }
                py++;
            }
        }

        public static function drawRectStrokeSides(target:BitmapData, x:Number, y:Number, width:Number, height:Number, thickness:Number, color:uint, top:Boolean, right:Boolean, bottom:Boolean, left:Boolean):void
        {
            var leftEdge:int = snap(x);
            var topEdge:int = snap(y);
            var rightEdge:int = snap(x + width);
            var bottomEdge:int = snap(y + height);
            var snapped:int = snappedThickness(thickness);
            if (((target == null) || (snapped <= 0) || (rightEdge <= leftEdge) || (bottomEdge <= topEdge)))
            {
                return;
            }
            if (top)
            {
                fillPixelRect(target, leftEdge, topEdge, rightEdge, (topEdge + snapped), color);
            }
            if (right)
            {
                fillPixelRect(target, (rightEdge - snapped), topEdge, rightEdge, bottomEdge, color);
            }
            if (bottom)
            {
                fillPixelRect(target, leftEdge, (bottomEdge - snapped), rightEdge, bottomEdge, color);
            }
            if (left)
            {
                fillPixelRect(target, leftEdge, topEdge, (leftEdge + snapped), bottomEdge, color);
            }
        }

        private static function drawRoundRectFill(target:BitmapData, x:Number, y:Number, width:Number, height:Number, radius:Number, color:uint):void
        {
            var px:int;
            var py:int;
            var left:int = snap(x);
            var top:int = snap(y);
            var right:int = snap(x + width);
            var bottom:int = snap(y + height);
            var r:int = cornerRadius(radius, (right - left), (bottom - top));
            var clipLeft:int = Math.max(0, left);
            var clipTop:int = Math.max(0, top);
            var clipRight:int = Math.min(target.width, right);
            var clipBottom:int = Math.min(target.height, bottom);
            if (((right <= left) || (bottom <= top)))
            {
                return;
            }
            py = clipTop;
            while (py < clipBottom)
            {
                px = clipLeft;
                while (px < clipRight)
                {
                    if (roundRectContainsPixel(px, py, left, top, right, bottom, r))
                    {
                        blendPixel(target, px, py, color, 1);
                    }
                    px++;
                }
                py++;
            }
        }

        public static function drawRoundRectStroke(target:BitmapData, x:Number, y:Number, width:Number, height:Number, radius:Number, thickness:Number, color:uint):void
        {
            var clipLeft:int;
            var clipTop:int;
            var clipRight:int;
            var clipBottom:int;
            var px:int;
            var py:int;
            var left:int = snap(x);
            var top:int = snap(y);
            var right:int = snap(x + width);
            var bottom:int = snap(y + height);
            var snapped:int = snappedThickness(thickness);
            var outerRadius:int = cornerRadius(radius, (right - left), (bottom - top));
            var innerLeft:int = (left + snapped);
            var innerTop:int = (top + snapped);
            var innerRight:int = (right - snapped);
            var innerBottom:int = (bottom - snapped);
            var innerRadius:int = cornerRadius(Math.max(0, (radius - snapped)), (innerRight - innerLeft), (innerBottom - innerTop));
            if (((target == null) || (snapped <= 0) || (right <= left) || (bottom <= top)))
            {
                return;
            }
            clipLeft = Math.max(0, left);
            clipTop = Math.max(0, top);
            clipRight = Math.min(target.width, right);
            clipBottom = Math.min(target.height, bottom);
            py = clipTop;
            while (py < clipBottom)
            {
                px = clipLeft;
                while (px < clipRight)
                {
                    if (((roundRectContainsPixel(px, py, left, top, right, bottom, outerRadius)) && (!(roundRectContainsPixel(px, py, innerLeft, innerTop, innerRight, innerBottom, innerRadius)))))
                    {
                        blendPixel(target, px, py, color, 1);
                    }
                    px++;
                }
                py++;
            }
        }

        private static function rhombusContainsPixel(px:int, py:int, left:int, top:int, right:int, bottom:int):Boolean
        {
            var width:int = (right - left);
            var height:int = (bottom - top);
            if (((px < left) || (py < top) || (px >= right) || (py >= bottom) || (width <= 0) || (height <= 0)))
            {
                return false;
            }
            var centerX:Number = (width / 2);
            var centerY:Number = (height / 2);
            var halfWidth:Number = (width / 2);
            var halfHeight:Number = (height / 2);
            var localX:Number = ((px - left) + 0.5);
            var localY:Number = ((py - top) + 0.5);
            return (((Math.abs(localX - centerX) / halfWidth) + (Math.abs(localY - centerY) / halfHeight)) <= 1);
        }

        private static function drawRhombusFill(target:BitmapData, x:Number, y:Number, width:Number, height:Number, color:uint):void
        {
            var px:int;
            var py:int;
            var left:int = snap(x);
            var top:int = snap(y);
            var right:int = snap(x + width);
            var bottom:int = snap(y + height);
            var clipLeft:int = Math.max(0, left);
            var clipTop:int = Math.max(0, top);
            var clipRight:int = Math.min(target.width, right);
            var clipBottom:int = Math.min(target.height, bottom);
            if (((right <= left) || (bottom <= top)))
            {
                return;
            }
            py = clipTop;
            while (py < clipBottom)
            {
                px = clipLeft;
                while (px < clipRight)
                {
                    if (rhombusContainsPixel(px, py, left, top, right, bottom))
                    {
                        blendPixel(target, px, py, color, 1);
                    }
                    px++;
                }
                py++;
            }
        }

        private static function drawRhombusStroke(target:BitmapData, x:Number, y:Number, width:Number, height:Number, thickness:Number, color:uint):void
        {
            var px:int;
            var py:int;
            var left:int = snap(x);
            var top:int = snap(y);
            var right:int = snap(x + width);
            var bottom:int = snap(y + height);
            var snapped:int = snappedThickness(thickness);
            var innerLeft:int = (left + snapped);
            var innerTop:int = (top + snapped);
            var innerRight:int = (right - snapped);
            var innerBottom:int = (bottom - snapped);
            var clipLeft:int = Math.max(0, left);
            var clipTop:int = Math.max(0, top);
            var clipRight:int = Math.min(target.width, right);
            var clipBottom:int = Math.min(target.height, bottom);
            if (((snapped <= 0) || (right <= left) || (bottom <= top)))
            {
                return;
            }
            py = clipTop;
            while (py < clipBottom)
            {
                px = clipLeft;
                while (px < clipRight)
                {
                    if (((rhombusContainsPixel(px, py, left, top, right, bottom)) && (!(rhombusContainsPixel(px, py, innerLeft, innerTop, innerRight, innerBottom)))))
                    {
                        blendPixel(target, px, py, color, 1);
                    }
                    px++;
                }
                py++;
            }
        }

        override public function draw(k:IWindow, _arg_2:BitmapData, _arg_3:Rectangle, _arg_4:uint, _arg_5:Boolean):void
        {
            var shapeWindow:ShapeController = (k as ShapeController);
            if (((shapeWindow == null) || (_arg_2 == null) || (_arg_3 == null) || (_arg_3.width <= 0) || (_arg_3.height <= 0)))
            {
                return;
            }
            var thickness:int = snappedThickness(shapeWindow.strokeThickness);
            var strokeColor:uint = ((shapeWindow.strokeHsvShade != 0) ? HsvLayerColor.deriveColor(k.color, shapeWindow.strokeHsvShade) : shapeWindow.strokeColor);
            var gfx:Graphics = SHAPE.graphics;
            _arg_2.fillRect(_arg_3, 0);
            if (shapeWindow.shape == ShapeController.SHAPE_ROUND_RECTANGLE)
            {
                drawRoundRectFill(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, shapeWindow.radius, k.color);
                if (thickness > 0)
                {
                    drawRoundRectStroke(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, shapeWindow.radius, thickness, strokeColor);
                }
                return;
            }
            if (shapeWindow.shape == ShapeController.SHAPE_RECTANGLE)
            {
                drawRectFill(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, k.color);
                if (thickness > 0)
                {
                    drawRectStroke(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, thickness, strokeColor);
                }
                return;
            }
            if (shapeWindow.shape == ShapeController.SHAPE_RHOMBUS)
            {
                drawRhombusFill(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, k.color);
                if (thickness > 0)
                {
                    drawRhombusStroke(_arg_2, _arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height, thickness, strokeColor);
                }
                return;
            }
            gfx.clear();
            gfx.beginFill((k.color & 0xFFFFFF), alphaFromColor(k.color));
            if (thickness > 0)
            {
                gfx.lineStyle(thickness, (strokeColor & 0xFFFFFF), alphaFromColor(strokeColor));
            }
            if (shapeWindow.shape == ShapeController.SHAPE_ELLIPSE)
            {
                gfx.drawEllipse((_arg_3.x + (thickness / 2)), (_arg_3.y + (thickness / 2)), Math.max(0, (_arg_3.width - thickness)), Math.max(0, (_arg_3.height - thickness)));
            }
            else
            {
                gfx.drawRect(_arg_3.x, _arg_3.y, _arg_3.width, _arg_3.height);
            }
            gfx.endFill();
            _arg_2.draw(SHAPE, null, null, null, _arg_3);
            gfx.clear();
        }

        override public function isStateDrawable(k:uint):Boolean
        {
            return true;
        }
    }
}
