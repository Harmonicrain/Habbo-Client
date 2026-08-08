package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications
{
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.common.NeighborhoodFloor;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.BitmapViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class FloorDrawingPreset extends WiredUIPreset
    {
        private static const FLOOR_EDITOR_BORDER_NAMES:Array = [
            "floor_editor_border_N", "floor_editor_border_NE",
            "floor_editor_border_E", "floor_editor_border_SE",
            "floor_editor_border_S", "floor_editor_border_SW",
            "floor_editor_border_W", "floor_editor_border_NW"
        ];
        private static const TAKEN_TILE_RGB:Array = [0, 0.4, 0.8];
        private static const UNTAKEN_TILE_RGB:Array = [0.2, 0.2, 0.2];
        private static const DRAW_MODES:Array = ["add_tile", "remove_tile", "set_root_tile"];

        private var _bitmapPreset:BitmapViewPreset;
        private var _onRootTileChanged:Function;
        private var _floorEditorBorders:Array;
        private var _tileImageBase:BitmapData;
        private var _tileImageEntry:BitmapData;
        private var _tileTaken:BitmapData;
        private var _tileUntaken:BitmapData;
        private var _drawing:Boolean;
        private var _lastDrawAddress:Point = new Point(-1000, -1000);
        private var _selectionStartPoint:Point = new Point(-1000, -1000);
        private var _isRectSelect:Boolean;
        private var _drawMode:String = DRAW_MODES[0];
        private var _rootTile:Point = new Point(0, 0);
        private var _floor:NeighborhoodFloor;

        public function FloorDrawingPreset(roomEvents:HabboUserDefinedRoomEvents, presets:PresetManager, style:WiredStyle, onRootTileChanged:Function)
        {
            super(roomEvents, presets, style);
            this._onRootTileChanged = onRootTileChanged;
            this._floorEditorBorders = [];
            for each (var borderName:String in FLOOR_EDITOR_BORDER_NAMES)
            {
                this._floorEditorBorders.push(this.getBitmapAsset(borderName));
            }
            this._tileImageBase = this.getBitmapAsset("floor_editor_tile_base");
            this._tileImageEntry = this.getBitmapAsset("floor_editor_tile_entry");
            this._bitmapPreset = presets.createBitmapViewPreset();
            this._bitmapPreset.bitmapWindow.procedure = this.editorWindowProcedure;
            this._tileTaken = this._tileImageBase.clone();
            this._tileTaken.colorTransform(this._tileImageBase.rect, new ColorTransform(TAKEN_TILE_RGB[0], TAKEN_TILE_RGB[1], TAKEN_TILE_RGB[2]));
            this._tileUntaken = this._tileImageBase.clone();
            this._tileUntaken.colorTransform(this._tileImageBase.rect, new ColorTransform(UNTAKEN_TILE_RGB[0], UNTAKEN_TILE_RGB[1], UNTAKEN_TILE_RGB[2]));
        }

        private function getBitmapAsset(name:String):BitmapData
        {
            var asset:BitmapDataAsset = this._roomEvents.assets.getAssetByName(name)
                as BitmapDataAsset;
            if (asset == null || asset.content == null)
            {
                throw new Error("Missing Wired floor editor asset: " + name);
            }
            return asset.content as BitmapData;
        }

        private static function transformFromScreenSpace(x:int, y:int):Point
        {
            var halfX:Number = x / 16;
            var halfY:Number = y / 8;
            return new Point(int(halfY + halfX - 1), int(halfY - halfX - 1));
        }

        private static function transformToScreenSpace(x:int, y:int):Point
        {
            return new Point(8 * (x - y + 1), 4 * (x + y + 1));
        }

        private static function interpolationPoints(x0:int, y0:int, x1:int, y1:int):Array
        {
            var points:Array = [];
            var dx:int = Math.abs(x1 - x0);
            var dy:int = Math.abs(y1 - y0);
            var sx:int = x0 < x1 ? 1 : -1;
            var sy:int = y0 < y1 ? 1 : -1;
            var error:int = dx - dy;
            while (true)
            {
                points.push(new Point(x0, y0));
                if (x0 == x1 && y0 == y1) break;
                var doubledError:int = 2 * error;
                if (doubledError > -dy) { error -= dy; x0 += sx; }
                if (doubledError < dx) { error += dx; y0 += sy; }
            }
            return points;
        }

        public function setFloor(floor:NeighborhoodFloor):void { this._floor = floor; this.updateView(); }
        public function setRootTile(x:int, y:int):void { this._rootTile.x = x; this._rootTile.y = y; this.updateView(); }
        public function setMode(mode:String):void { this._drawMode = mode; }

        private function editorWindowProcedure(event:WindowEvent, window:IWindow):void
        {
            if (this.bitmapWindow == null || this._floor == null) return;
            if (event.type != WindowMouseEvent.UP && event.type != WindowMouseEvent.UP_OUTSIDE
                    && event.type != WindowMouseEvent.DOWN && !(this._drawing && event.type == WindowMouseEvent.MOVE)) return;

            var mouseEvent:WindowMouseEvent = event as WindowMouseEvent;
            var centerX:int = this.bitmapWindow.width / 2;
            var bitmapHeight:int = this.bitmapWindow.bitmap != null ? this.bitmapWindow.bitmap.height : 0;
            var topY:int = this.bitmapWindow.height / 2 - bitmapHeight / 2;
            var address:Point = transformFromScreenSpace(mouseEvent.localX - centerX, mouseEvent.localY - topY);
            var changed:Boolean = false;

            if (event.type == WindowMouseEvent.UP || event.type == WindowMouseEvent.UP_OUTSIDE)
            {
                this._drawing = false;
                if (this._isRectSelect)
                {
                    this._isRectSelect = false;
                    this._floor.submitTemporaryCache();
                }
            }

            if (event.type == WindowMouseEvent.DOWN)
            {
                this._drawing = true;
                this._lastDrawAddress = new Point(-1000, -1000);
                if (mouseEvent.shiftKey)
                {
                    this._isRectSelect = true;
                    this._selectionStartPoint = address;
                    this._floor.initTemporaryCache();
                }
                this.applyDraw(address.x, address.y);
                changed = true;
                this.updateView();
                this._lastDrawAddress = address;
            }

            if (this._drawing && event.type == WindowMouseEvent.MOVE)
            {
                if (this._isRectSelect && this._drawMode != DRAW_MODES[2])
                {
                    var minX:int = Math.min(this._selectionStartPoint.x, address.x);
                    var maxX:int = Math.max(this._selectionStartPoint.x, address.x);
                    var minY:int = Math.min(this._selectionStartPoint.y, address.y);
                    var maxY:int = Math.max(this._selectionStartPoint.y, address.y);
                    this._floor.clearTemporaryCache();
                    for (var x:int = minX; x <= maxX; x++)
                    {
                        for (var y:int = minY; y <= maxY; y++)
                        {
                            this.applyDraw(x, y);
                            changed = true;
                        }
                    }
                    this.updateView();
                }
                else
                {
                    if (this._lastDrawAddress.x != address.x || this._lastDrawAddress.y != address.y)
                    {
                        this.applyDraw(address.x, address.y);
                        changed = true;
                    }
                    var delta:Object = this.interpolateBetweenLastPointAndDrawPoint(address);
                    if (Math.abs(delta.x) > 0 || Math.abs(delta.y) > 0) this.updateView();
                }
                this._lastDrawAddress = address;
            }

            if (changed) this._floor.occupationHasChanged();
        }

        private function interpolateBetweenLastPointAndDrawPoint(address:Point):Object
        {
            if (this._lastDrawAddress.x == -1000 && this._lastDrawAddress.y == -1000)
            {
                this._lastDrawAddress.x = address.x;
                this._lastDrawAddress.y = address.y;
            }
            var deltaX:int = address.x - this._lastDrawAddress.x;
            var deltaY:int = address.y - this._lastDrawAddress.y;
            for each (var point:Point in interpolationPoints(this._lastDrawAddress.x, this._lastDrawAddress.y, address.x, address.y))
            {
                if (!((this._lastDrawAddress.x == point.x && this._lastDrawAddress.y == point.y)
                        || (address.x == point.x && address.y == point.y))) this.applyDraw(point.x, point.y);
            }
            return {x:deltaX, y:deltaY};
        }

        private function applyDraw(x:int, y:int):Boolean
        {
            if (!this.allowDraw(x, y)) return false;
            var offset:int = NeighborhoodFloor.RADIUS - this._floor.visualizingRadius;
            switch (this._drawMode)
            {
                case DRAW_MODES[0]:
                    this._floor.setOccupied(x + offset, y + offset, true);
                    break;
                case DRAW_MODES[1]:
                    this._floor.setOccupied(x + offset, y + offset, false);
                    break;
                case DRAW_MODES[2]:
                    this.setRootTileInternal(x - this._floor.visualizingRadius, y - this._floor.visualizingRadius);
                    if (this._onRootTileChanged != null) this._onRootTileChanged(this._rootTile.x, this._rootTile.y);
                    break;
            }
            return true;
        }

        private function setRootTileInternal(x:int, y:int):void { this._rootTile.x = x; this._rootTile.y = y; }
        private function allowDraw(x:int, y:int):Boolean { return x >= 0 && y >= 0 && x < this._floor.visualizingDimension && y < this._floor.visualizingDimension; }

        private function updateView():void
        {
            if (this.bitmapWindow == null || this._floor == null) return;
            var layers:Array = [];
            var offset:int = NeighborhoodFloor.RADIUS - this._floor.visualizingRadius;
            var x:int;
            var y:int;
            for (y = 0; y < this._floor.visualizingDimension; y++)
            {
                for (x = 0; x < this._floor.visualizingDimension; x++)
                {
                    layers.push({point:transformToScreenSpace(x, y), image:this._floor.isOccupied(x + offset, y + offset) ? this._tileTaken : this._tileUntaken});
                }
            }

            if (this._rootTile.x >= -this._floor.visualizingRadius && this._rootTile.x <= this._floor.visualizingRadius
                    && this._rootTile.y >= -this._floor.visualizingRadius && this._rootTile.y <= this._floor.visualizingRadius)
            {
                layers.push({point:transformToScreenSpace(this._rootTile.x + this._floor.visualizingRadius, this._rootTile.y + this._floor.visualizingRadius), image:this._tileImageEntry});
            }

            for (x = 0; x < this._floor.visualizingDimension; x++)
            {
                layers.push({point:transformToScreenSpace(x, -1), image:this._floorEditorBorders[0]});
                layers.push({point:transformToScreenSpace(x, this._floor.visualizingDimension), image:this._floorEditorBorders[4]});
            }
            for (y = 0; y < this._floor.visualizingDimension; y++)
            {
                layers.push({point:transformToScreenSpace(-1, y), image:this._floorEditorBorders[6]});
                layers.push({point:transformToScreenSpace(this._floor.visualizingDimension, y), image:this._floorEditorBorders[2]});
            }
            layers.push({point:transformToScreenSpace(-1, -1), image:this._floorEditorBorders[7]});
            layers.push({point:transformToScreenSpace(this._floor.visualizingDimension, -1), image:this._floorEditorBorders[1]});
            layers.push({point:transformToScreenSpace(this._floor.visualizingDimension, this._floor.visualizingDimension), image:this._floorEditorBorders[3]});
            layers.push({point:transformToScreenSpace(-1, this._floor.visualizingDimension), image:this._floorEditorBorders[5]});

            var minX:int = int.MAX_VALUE;
            var minY:int = int.MAX_VALUE;
            var maxX:int = int.MIN_VALUE;
            var maxY:int = int.MIN_VALUE;
            for each (var layer:Object in layers)
            {
                var point:Point = layer.point as Point;
                var rectangle:Rectangle = layer.image.rect;
                minX = Math.min(minX, point.x);
                minY = Math.min(minY, point.y);
                maxX = Math.max(maxX, point.x + rectangle.width);
                maxY = Math.max(maxY, point.y + rectangle.height);
            }

            var bitmap:BitmapData = new BitmapData(maxX - minX, maxY - minY, false, _style.advancedBackgroundColor);
            var translation:Point = new Point(-minX, -minY);
            for each (layer in layers)
            {
                bitmap.copyPixels(layer.image, layer.image.rect, layer.point.add(translation));
            }
            this.bitmapWindow.bitmap = bitmap;
            this._bitmapPreset.setBitmapSize(bitmap.width, bitmap.height);
            resize();
        }

        private function get bitmapWindow():IBitmapWrapperWindow { return this._bitmapPreset != null ? this._bitmapPreset.bitmapWindow : null; }
        override public function get window():IWindow { return this._bitmapPreset.window; }
        override public function resizeToWidth(width:int):void { super.resizeToWidth(width); this._bitmapPreset.resizeToWidth(width); }
        override public function hasStaticWidth():Boolean { return this._bitmapPreset.hasStaticWidth(); }
        override public function get staticWidth():int { return this._bitmapPreset.staticWidth; }
        override protected function get childPresets():Array { return [this._bitmapPreset]; }

        override public function dispose():void
        {
            if (disposed) return;
            super.dispose();
            this._bitmapPreset = null;
            this._onRootTileChanged = null;
            this._floor = null;
        }
    }
}
