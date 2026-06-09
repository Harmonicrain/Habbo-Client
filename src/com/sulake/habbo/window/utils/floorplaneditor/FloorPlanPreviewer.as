package com.sulake.habbo.window.utils.floorplaneditor
{
    import com.sulake.core.utils.profiler.tracking.TrackedBitmapData;
    import com.sulake.habbo.window.utils.floorplaneditor.images.*;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Point;

    public class FloorPlanPreviewer
    {
        public static var tile_preview_0:Class = FloorPlanPreviewer_tile_preview_0;
        public static var tile_preview_1:Class = FloorPlanPreviewer_tile_preview_1;
        public static var tile_preview_2:Class = FloorPlanPreviewer_tile_preview_2;
        public static var tile_preview_3:Class = FloorPlanPreviewer_tile_preview_3;
        public static var tile_preview_4:Class = FloorPlanPreviewer_tile_preview_4;
        public static var tile_preview_5:Class = FloorPlanPreviewer_tile_preview_5;
        public static var tile_preview_6:Class = FloorPlanPreviewer_tile_preview_6;
        public static var tile_preview_7:Class = FloorPlanPreviewer_tile_preview_7;
        public static var tile_preview_8:Class = FloorPlanPreviewer_tile_preview_8;
        public static var tile_preview_9:Class = FloorPlanPreviewer_tile_preview_9;
        public static var tile_preview_a:Class = FloorPlanPreviewer_tile_preview_a;
        public static var tile_preview_b:Class = FloorPlanPreviewer_tile_preview_b;
        public static var tile_preview_c:Class = FloorPlanPreviewer_tile_preview_c;
        public static var tile_preview_d:Class = FloorPlanPreviewer_tile_preview_d;
        public static var tile_preview_e:Class = FloorPlanPreviewer_tile_preview_e;
        public static var tile_preview_f:Class = FloorPlanPreviewer_tile_preview_f;
        public static var tile_preview_entry:Class = FloorPlanPreviewer_tile_preview_entry;

        private var _bcFloorPlanEditor:BCFloorPlanEditor;
        private var _tileImages:Vector.<BitmapData>;
        private var _floorPlan:FloorPlanCache;

        public function FloorPlanPreviewer(k:BCFloorPlanEditor)
        {
            this._bcFloorPlanEditor = k;
            this._floorPlan = k.floorPlanCache;
            this._tileImages = new Vector.<BitmapData>(0);
            this._tileImages.push(Bitmap(new tile_preview_0()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_1()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_2()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_3()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_4()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_5()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_6()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_7()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_8()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_9()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_a()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_b()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_c()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_d()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_e()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_f()).bitmapData);
            this._tileImages.push(Bitmap(new tile_preview_entry()).bitmapData);
        }

        private static function getCanvasPoint(x:int, y:int, z:int):Point
        {
            return new Point((8 * (x - y)), ((4 * (x + y)) - (8 * z)));
        }

        public function updatePreview():void
        {
            var x:int;
            var y:int;
            var tile:Object;
            var height:int;
            var point:Point;
            var topLeft:int;
            var top:int;
            var topRight:int;
            var left:int;
            var right:int;
            var bottomLeft:int;
            var bottom:int;
            var bottomRight:int;
            var nextHeight:int;
            var type:int;
            var tiles:Array = [];
            var minX:int = int.MAX_VALUE;
            var minY:int = int.MAX_VALUE;
            var maxX:int = int.MIN_VALUE;
            var maxY:int = int.MIN_VALUE;
            y = 0;
            while (y < this._floorPlan.floorHeight)
            {
                x = 0;
                while (x < this._floorPlan.floorWidth)
                {
                    height = this._floorPlan.getHeightAt(x, y);
                    if (height >= 0)
                    {
                        point = getCanvasPoint(x, y, height);
                        minX = Math.min(minX, point.x);
                        minY = Math.min(minY, point.y);
                        maxX = Math.max(maxX, point.x);
                        maxY = Math.max(maxY, point.y);
                        topLeft = this._floorPlan.getHeightAt((x - 1), (y - 1));
                        top = this._floorPlan.getHeightAt(x, (y - 1));
                        topRight = this._floorPlan.getHeightAt((x + 1), (y - 1));
                        left = this._floorPlan.getHeightAt((x - 1), y);
                        right = this._floorPlan.getHeightAt((x + 1), y);
                        bottomLeft = this._floorPlan.getHeightAt((x - 1), (y + 1));
                        bottom = this._floorPlan.getHeightAt(x, (y + 1));
                        bottomRight = this._floorPlan.getHeightAt((x + 1), (y + 1));
                        nextHeight = height + 1;
                        type = ((((((((topLeft == nextHeight) || (top == nextHeight)) || (left == nextHeight)) ? 1 : 0) | ((((topRight == nextHeight) || (top == nextHeight)) || (right == nextHeight)) ? 2 : 0)) | ((((bottomLeft == nextHeight) || (bottom == nextHeight)) || (left == nextHeight)) ? 4 : 0)) | ((((bottomRight == nextHeight) || (bottom == nextHeight)) || (right == nextHeight)) ? 8 : 0)));
                        if (type == 15)
                        {
                            type = 0;
                        }
                        if (this._floorPlan.isEntryPoint(x, y))
                        {
                            type = this._tileImages.length - 1;
                        }
                        tiles.push({
                            "point":point,
                            "type":type
                        });
                    }
                    x++;
                }
                y++;
            }
            var width:int = Math.min(((maxX - minX) + 18), TrackedBitmapData.MIN_HEIGHT);
            var heightPixels:int = Math.min(((maxY - minY) + 18), TrackedBitmapData.MIN_HEIGHT);
            var bitmap:BitmapData = new BitmapData(width, heightPixels, false, 0xFFFFFFFF);
            var offset:Point = new Point(-minX, -minY);
            for each (tile in tiles)
            {
                bitmap.copyPixels(this._tileImages[tile.type], this._tileImages[tile.type].rect, tile.point.add(offset));
            }
            this._bcFloorPlanEditor.updatePreviewBitmap(bitmap);
        }
    }
}
