package com.sulake.habbo.window.utils
{
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.BitmapData;
    import flash.geom.Point;

    /** July six-digit plaque number renderer used by chest inventory overlays. */
    public final class ChestItemOverlayNumberBitmapGenerator
    {
        private static const GLYPH_PREFIX:String =
            "unique_item_number_glyph_";

        public static function createBitmap(assets:IAssetLibrary, value:int,
            width:int, height:int):BitmapData
        {
            var output:BitmapData = new BitmapData(width, height, true, 0);
            if (value < 0 || value > 999999)
            {
                return output;
            }

            var digits:Array = [];
            var divisor:int = 100000;
            var started:Boolean = false;
            var totalWidth:int = 0;
            while (divisor >= 1)
            {
                var digit:int = int(value / divisor) % 10;
                if (digit > 0 || started || divisor == 1)
                {
                    started = true;
                    var glyph:BitmapDataAsset = BitmapDataAsset(
                        assets.getAssetByName(GLYPH_PREFIX + digit));
                    digits.push(glyph);
                    totalWidth += glyph.rectangle.width;
                }
                divisor /= 10;
            }

            totalWidth--;
            var point:Point = new Point((width - totalWidth) / 2, 0);
            for each (glyph in digits)
            {
                output.copyPixels(BitmapData(glyph.content),
                    glyph.rectangle, point);
                point.x += glyph.rectangle.width;
            }
            return output;
        }
    }
}
