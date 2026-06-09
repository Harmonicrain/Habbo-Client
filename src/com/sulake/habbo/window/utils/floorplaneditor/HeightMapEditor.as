package com.sulake.habbo.window.utils.floorplaneditor
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.utils.floorplaneditor.images.*;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    public class HeightMapEditor
    {
        public static const LEVELS:int = 30;

        public static var floor_editor_tile_base:Class = FloorEditorTileBase;
        public static var floor_editor_tile_entry:Class = FloorEditorTileEntry;
        public static var floor_editor_tile_base_large:Class = FloorEditorTileBaseLarge;
        public static var floor_editor_tile_entry_large:Class = FloorEditorTileEntryLarge;

        private var _bcFloorPlanEditor:BCFloorPlanEditor;
        private var _drawing:Boolean = false;
        private var _drawingHeight:int = 0;
        private var _tileImageBase:BitmapData;
        private var _tileImageEntry:BitmapData;
        private var _tileImageBaseLarge:BitmapData;
        private var _tileImageEntryLarge:BitmapData;
        private var _heigthColorMap:Vector.<Array>;
        private var _occupiedHeigthColorMap:Vector.<Array>;
        private var _bitmapElement:IBitmapWrapperWindow;
        private var _lastDrawAddress:Point;
        private var _floorPlan:FloorPlanCache;
        private var _colorPickMode:Boolean = false;
        private var _zoomLevel:int = 1;
        private var _coloredTiles:Dictionary;
        private var _coloredOccupiedTiles:Dictionary;
        private var _coloredTilesLarge:Dictionary;
        private var _coloredOccupiedTilesLarge:Dictionary;
        private var _selectionStartPoint:Point;
        private var _isRectSelect:Boolean = false;

        public function HeightMapEditor(k:BCFloorPlanEditor)
        {
            var index:int;
            var hue:Number;
            this._lastDrawAddress = new Point(-1000, -1000);
            this._selectionStartPoint = new Point(-1000, -1000);
            super();
            this._bcFloorPlanEditor = k;
            this._bcFloorPlanEditor.heightMapBitmapElement.procedure = this.editorWindowProcedure;
            this._bcFloorPlanEditor.heightMapMouseCapturer.procedure = this.editorWindowProcedure;
            this._floorPlan = k.floorPlanCache;
            this._tileImageBase = Bitmap(new floor_editor_tile_base()).bitmapData;
            this._tileImageEntry = Bitmap(new floor_editor_tile_entry()).bitmapData;
            this._tileImageBaseLarge = Bitmap(new floor_editor_tile_base_large()).bitmapData;
            this._tileImageEntryLarge = Bitmap(new floor_editor_tile_entry_large()).bitmapData;
            this._heigthColorMap = new Vector.<Array>();
            this._occupiedHeigthColorMap = new Vector.<Array>();
            this._coloredOccupiedTiles = new Dictionary();
            this._coloredTiles = new Dictionary();
            this._coloredTilesLarge = new Dictionary();
            this._coloredOccupiedTilesLarge = new Dictionary();
            while (index < LEVELS)
            {
                hue = 0.6 - ((index / Number(LEVELS)) * 0.85);
                if (hue < 0)
                {
                    hue = 1 + hue;
                }
                this._heigthColorMap.push(hslToRgb(hue, 1, 0.5));
                this._occupiedHeigthColorMap.push(hslToRgb(hue, 0.33, 0.4));
                index++;
            }
        }

        public static function hslToRgb(h:Number, s:Number, l:Number):Array
        {
            var r:Number;
            var g:Number;
            var b:Number;
            var q:Number;
            var p:Number;
            if (s == 0)
            {
                r = (g = (b = l));
            }
            else
            {
                var hue2rgb:Function = function (p:Number, q:Number, t:Number):Number
                {
                    if (t < 0)
                    {
                        t += 1;
                    }
                    if (t > 1)
                    {
                        t -= 1;
                    }
                    if (t < (1 / 6))
                    {
                        return p + (((q - p) * 6) * t);
                    }
                    if (t < (1 / 2))
                    {
                        return q;
                    }
                    if (t < (2 / 3))
                    {
                        return p + (((q - p) * ((2 / 3) - t)) * 6);
                    }
                    return p;
                }
                q = ((l < 0.5) ? (l * (1 + s)) : ((l + s) - (l * s)));
                p = ((2 * l) - q);
                r = hue2rgb(p, q, (h + (1 / 3)));
                g = hue2rgb(p, q, h);
                b = hue2rgb(p, q, (h - (1 / 3)));
            }
            return [r, g, b];
        }

        public function get heigthColorMap():Vector.<Array>
        {
            return this._heigthColorMap;
        }

        public function get _Str_17977():Vector.<Array>
        {
            return this._heigthColorMap;
        }

        public function set drawingHeight(k:int):void
        {
            this._drawingHeight = Math.min(LEVELS, Math.max(0, k));
        }

        public function get drawingHeight():int
        {
            return this._drawingHeight;
        }

        public function set _Str_9167(k:int):void
        {
            this.drawingHeight = k;
        }

        public function get _Str_9167():int
        {
            return this._drawingHeight;
        }

        public function set drawing(k:Boolean):void
        {
            this._drawing = k;
        }

        public function set _Str_22137(k:Boolean):void
        {
            this._drawing = k;
        }

        public function refreshFromCache():void
        {
            this._bitmapElement = this._bcFloorPlanEditor.heightMapBitmapElement;
            this._lastDrawAddress = new Point(-1000, -1000);
            this.updateView();
        }

        public function _Str_9032():void
        {
            this.refreshFromCache();
        }

        private function editorWindowProcedure(k:WindowEvent, window:IWindow):void
        {
            var tile:Point;
            var maxX:int;
            var minX:int;
            var minY:int;
            var maxY:int;
            var canExpandColumns:Boolean;
            var canExpandRows:Boolean;
            var drawX:int;
            var drawY:int;
            var delta:Object;
            var mouseEvent:WindowMouseEvent = k as WindowMouseEvent;
            if (mouseEvent == null)
            {
                return;
            }
            if (this._colorPickMode)
            {
                if (k.type == WindowMouseEvent.CLICK)
                {
                    tile = this.getTileAddressFromMousePoint(mouseEvent, window);
                    this._drawingHeight = this._bcFloorPlanEditor.floorPlanCache.getHeightAt(tile.x, tile.y);
                    this._bcFloorPlanEditor.updateColorSliderTrack(this._drawingHeight);
                }
            }
            else if (((((k.type == WindowMouseEvent.UP) || (k.type == WindowMouseEvent.UP_OUTSIDE)) || (k.type == WindowMouseEvent.DOWN)) || ((this._drawing) && (k.type == WindowMouseEvent.MOVE))))
            {
                tile = this.getTileAddressFromMousePoint(mouseEvent, window);
                if (((k.type == WindowMouseEvent.UP) || (k.type == WindowMouseEvent.UP_OUTSIDE)))
                {
                    this._drawing = false;
                    if (this._isRectSelect)
                    {
                        this._isRectSelect = false;
                        this._bcFloorPlanEditor.floorPlanCache.submitTemporaryCache();
                    }
                }
                if (k.type == WindowMouseEvent.DOWN)
                {
                    this._drawing = true;
                    this._lastDrawAddress = new Point(-1000, -1000);
                    if (mouseEvent.shiftKey)
                    {
                        this._isRectSelect = true;
                        this._selectionStartPoint = tile;
                        this._bcFloorPlanEditor.floorPlanCache.initTemporaryCache();
                    }
                    this.applyDraw(tile.x, tile.y);
                    this.updateView();
                    this._lastDrawAddress = tile;
                }
                if (((this._drawing) && (k.type == WindowMouseEvent.MOVE)))
                {
                    if (this._isRectSelect)
                    {
                        minX = Math.min(this._selectionStartPoint.x, tile.x);
                        maxX = Math.max(this._selectionStartPoint.x, tile.x);
                        minY = Math.min(this._selectionStartPoint.y, tile.y);
                        maxY = Math.max(this._selectionStartPoint.y, tile.y);
                        canExpandColumns = this._bcFloorPlanEditor.floorPlanCache.attemptExpandColumns(maxX);
                        canExpandRows = this._bcFloorPlanEditor.floorPlanCache.attemptExpandRows(maxY);
                        if (((!canExpandColumns) && (!canExpandRows)))
                        {
                            return;
                        }
                        while (((maxY >= minY) && (!canExpandRows)))
                        {
                            maxY--;
                            canExpandRows = this._bcFloorPlanEditor.floorPlanCache.attemptExpandRows(maxY);
                        }
                        while (((maxX >= minX) && (!canExpandColumns)))
                        {
                            maxX--;
                            canExpandColumns = this._bcFloorPlanEditor.floorPlanCache.attemptExpandColumns(maxX);
                        }
                        if (((!canExpandColumns) || (!canExpandRows)))
                        {
                            return;
                        }
                        this._bcFloorPlanEditor.floorPlanCache.clearTemporaryCache();
                        this._bcFloorPlanEditor.floorPlanCache.attemptExpandRows(maxY);
                        this._bcFloorPlanEditor.floorPlanCache.attemptExpandColumns(maxX);
                        drawX = minX;
                        while (drawX <= maxX)
                        {
                            drawY = minY;
                            while (drawY <= maxY)
                            {
                                this.applyDraw(drawX, drawY);
                                drawY++;
                            }
                            drawX++;
                        }
                        this.updateView();
                    }
                    else
                    {
                        if (((!(this._lastDrawAddress.x == tile.x)) || (!(this._lastDrawAddress.y == tile.y))))
                        {
                            this.applyDraw(tile.x, tile.y);
                        }
                        delta = this.interpolateBetweenLastPointAndDrawPoint(tile);
                        if (((Math.abs(delta.x) > 0) || (Math.abs(delta.y) > 0)))
                        {
                            this.updateView();
                        }
                    }
                    this._lastDrawAddress = tile;
                }
            }
        }

        private function getMousePositionRelativeToBitmap(k:WindowMouseEvent, window:IWindow):Point
        {
            var point:Point = new Point(k.localX, k.localY);
            window.convertPointFromLocalToGlobalSpace(point);
            this._bcFloorPlanEditor.heightMapBitmapElement.convertPointFromGlobalToLocalSpace(point);
            return point;
        }

        private function getTileAddressFromMousePoint(k:WindowMouseEvent, window:IWindow):Point
        {
            var point:Point = this.getMousePositionRelativeToBitmap(k, window);
            return this.transformFromScreenSpace(point.x, point.y);
        }

        private function interpolateBetweenLastPointAndDrawPoint(k:Point):Object
        {
            var points:Array;
            var point:Point;
            if (((this._lastDrawAddress.x == -1000) && (this._lastDrawAddress.y == -1000)))
            {
                this._lastDrawAddress.x = k.x;
                this._lastDrawAddress.y = k.y;
            }
            var deltaX:int = k.x - this._lastDrawAddress.x;
            var deltaY:int = k.y - this._lastDrawAddress.y;
            points = interpolationPoints(this._lastDrawAddress.x, this._lastDrawAddress.y, k.x, k.y);
            for each (point in points)
            {
                if ((!((this._lastDrawAddress.x == point.x) && (this._lastDrawAddress.y == point.y))) && (!((k.x == point.x) && (k.y == point.y))))
                {
                    this.applyDraw(point.x, point.y);
                }
            }
            return ({
                "x":deltaX,
                "y":deltaY
            });
        }

        private static function interpolationPoints(x0:int, y0:int, x1:int, y1:int):Array
        {
            var points:Array = [];
            var dx:int = Math.abs(x1 - x0);
            var dy:int = Math.abs(y1 - y0);
            var sx:int = x0 < x1 ? 1 : -1;
            var sy:int = y0 < y1 ? 1 : -1;
            var err:int = dx - dy;
            var e2:int;
            while (true)
            {
                points.push(new Point(x0, y0));
                if (((x0 == x1) && (y0 == y1)))
                {
                    break;
                }
                e2 = 2 * err;
                if (e2 > -dy)
                {
                    err -= dy;
                    x0 += sx;
                }
                if (e2 < dx)
                {
                    err += dx;
                    y0 += sy;
                }
            }
            return points;
        }

        private function applyDraw(x:int, y:int):void
        {
            var height:int;
            switch (this._bcFloorPlanEditor.drawMode)
            {
                case this._bcFloorPlanEditor.drawModes[0]:
                    this._bcFloorPlanEditor.floorPlanCache.setHeightAt(x, y, this._drawingHeight);
                    break;
                case this._bcFloorPlanEditor.drawModes[1]:
                    this._bcFloorPlanEditor.floorPlanCache.setHeightAt(x, y, -1);
                    break;
                case this._bcFloorPlanEditor.drawModes[2]:
                    height = this._bcFloorPlanEditor.floorPlanCache.getHeightAt(x, y);
                    if (height >= 0)
                    {
                        this._bcFloorPlanEditor.floorPlanCache.setHeightAt(x, y, Math.min((LEVELS - 1), (height + 1)));
                    }
                    break;
                case this._bcFloorPlanEditor.drawModes[3]:
                    height = this._bcFloorPlanEditor.floorPlanCache.getHeightAt(x, y);
                    if (height >= 0)
                    {
                        this._bcFloorPlanEditor.floorPlanCache.setHeightAt(x, y, Math.max(0, (height - 1)));
                    }
                    break;
                case this._bcFloorPlanEditor.drawModes[4]:
                    height = this._bcFloorPlanEditor.floorPlanCache.getHeightAt(x, y);
                    if (height >= 0)
                    {
                        this._bcFloorPlanEditor.floorPlanCache.entryPoint = new Point(x, y);
                    }
                    break;
            }
        }

        private function updateView():void
        {
            var x:int;
            var y:int;
            var image:BitmapData;
            var point:Point;
            var height:int;
            var item:Object;
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
                    point = this.transformToScreenSpace(x, y);
                    minX = Math.min(minX, point.x);
                    minY = Math.min(minY, point.y);
                    maxX = Math.max(maxX, point.x);
                    maxY = Math.max(maxY, point.y);
                    if (this._floorPlan.isEntryPoint(x, y))
                    {
                        image = this.getEntryTile();
                        tiles.push({
                            "point":point,
                            "image":image
                        });
                    }
                    else
                    {
                        height = Math.min(this._floorPlan.getHeightAt(x, y), (LEVELS - 1));
                        if (height >= 0)
                        {
                            image = this.getColoredTile(height, this._floorPlan.isTileReserved(x, y));
                            tiles.push({
                                "point":point,
                                "image":image
                            });
                        }
                    }
                    x++;
                }
                y++;
            }
            var bitmap:BitmapData = new BitmapData(((maxX - minX) + 18), ((maxY - minY) + 27), false, 0);
            var offset:Point = new Point(-minX, -minY);
            for each (item in tiles)
            {
                bitmap.copyPixels(item.image, item.image.rect, item.point.add(offset));
            }
            this._bcFloorPlanEditor.heightMapBitmapElement.bitmap = bitmap;
        }

        private function getColoredTile(height:int, occupied:Boolean):BitmapData
        {
            var cache:Dictionary = occupied ? ((this._zoomLevel == 1) ? this._coloredOccupiedTiles : this._coloredOccupiedTilesLarge) : ((this._zoomLevel == 1) ? this._coloredTiles : this._coloredTilesLarge);
            if (cache[height] != null)
            {
                return cache[height];
            }
            var color:Array = occupied ? this._occupiedHeigthColorMap[height] : this._heigthColorMap[height];
            var bitmap:BitmapData = ((this._zoomLevel == 1) ? this._tileImageBase : this._tileImageBaseLarge).clone();
            bitmap.colorTransform(bitmap.rect, new ColorTransform(color[0], color[1], color[2]));
            cache[height] = bitmap;
            return bitmap;
        }

        private function getEntryTile():BitmapData
        {
            return (this._zoomLevel == 1) ? this._tileImageEntry : this._tileImageEntryLarge;
        }

        private function transformFromScreenSpace(x:int, y:int):Point
        {
            var localX:Number = ((x / 16) / this._zoomLevel);
            var localY:Number = ((y / 8) / this._zoomLevel);
            var height:Number = this._floorPlan.floorHeight;
            var tileX:int = localY + (localX - (height / 2));
            var tileY:int = localY - (localX - (height / 2));
            return new Point(tileX, tileY);
        }

        private function transformToScreenSpace(x:int, y:int):Point
        {
            return new Point(((this._zoomLevel * 8) * (x - y)), ((this._zoomLevel * 4) * (x + y)));
        }

        public function get colorPickMode():Boolean
        {
            return this._colorPickMode;
        }

        public function set colorPickMode(k:Boolean):void
        {
            this._colorPickMode = k;
        }

        public function get _Str_12874():Boolean
        {
            return this._colorPickMode;
        }

        public function set _Str_12874(k:Boolean):void
        {
            this._colorPickMode = k;
        }

        public function get zoomLevel():int
        {
            return this._zoomLevel;
        }

        public function set zoomLevel(k:int):void
        {
            if (((k < 1) || (k > 2)))
            {
                return;
            }
            this._zoomLevel = k;
        }
    }
}
