package com.sulake.core.window.graphics.renderer
{
    import flash.geom.ColorTransform;

    public class HsvLayerColor
    {
        public static function configureTransform(transform:ColorTransform, color:uint, shade:Number):void
        {
            var derived:uint = deriveColor(color, shade);
            transform.redMultiplier = (((derived & 0xFF0000) >> 16) / 0xFF);
            transform.greenMultiplier = (((derived & 0xFF00) >> 8) / 0xFF);
            transform.blueMultiplier = ((derived & 0xFF) / 0xFF);
            transform.alphaMultiplier = 1;
            transform.redOffset = 0;
            transform.greenOffset = 0;
            transform.blueOffset = 0;
            transform.alphaOffset = 0;
        }

        public static function deriveColor(color:uint, shade:Number):uint
        {
            if (isNaN(shade))
            {
                shade = 0;
            }
            var r:Number = (((color & 0xFF0000) >> 16) / 0xFF);
            var g:Number = (((color & 0xFF00) >> 8) / 0xFF);
            var b:Number = ((color & 0xFF) / 0xFF);
            var hsv:Object = rgbToHsv(r, g, b);
            if (hsv.s == 0)
            {
                hsv.s = 0;
                hsv.v = (hsv.v - shade);
            }
            else
            {
                hsv.s = clamp01(hsv.s + shade);
                hsv.v = clamp01(hsv.v - (shade / 2));
            }
            return hsvToRgb(hsv.h, hsv.s, hsv.v);
        }

        private static function rgbToHsv(r:Number, g:Number, b:Number):Object
        {
            var max:Number = Math.max(r, Math.max(g, b));
            var min:Number = Math.min(r, Math.min(g, b));
            var delta:Number = (max - min);
            var h:Number = 0;
            var s:Number = ((max == 0) ? 0 : (delta / max));
            if (delta != 0)
            {
                if (max == r)
                {
                    h = ((g - b) / delta);
                    if (g < b)
                    {
                        h = (h + 6);
                    }
                }
                else
                {
                    if (max == g)
                    {
                        h = (((b - r) / delta) + 2);
                    }
                    else
                    {
                        h = (((r - g) / delta) + 4);
                    }
                }
                h = (h / 6);
            }
            return {
                "h": h,
                "s": s,
                "v": max
            };
        }

        private static function hsvToRgb(h:Number, s:Number, v:Number):uint
        {
            h = (h - Math.floor(h));
            if (s == 0)
            {
                return toColor(v, v, v);
            }
            var scaled:Number = (h * 6);
            var sector:int = Math.floor(scaled);
            var frac:Number = (scaled - sector);
            var p:Number = (v * (1 - s));
            var q:Number = (v * (1 - (s * frac)));
            var t:Number = (v * (1 - (s * (1 - frac))));
            switch (sector % 6)
            {
                case 0:
                    return toColor(v, t, p);
                case 1:
                    return toColor(q, v, p);
                case 2:
                    return toColor(p, v, t);
                case 3:
                    return toColor(p, q, v);
                case 4:
                    return toColor(t, p, v);
                default:
                    return toColor(v, p, q);
            }
        }

        private static function toColor(r:Number, g:Number, b:Number):uint
        {
            return (((toByte(r) << 16) | (toByte(g) << 8)) | toByte(b));
        }

        private static function toByte(value:Number):uint
        {
            return uint(Math.round(clamp01(value) * 0xFF));
        }

        private static function clamp01(value:Number):Number
        {
            if (((isNaN(value)) || (value < 0)))
            {
                return 0;
            }
            if (value > 1)
            {
                return 1;
            }
            return value;
        }
    }
}
