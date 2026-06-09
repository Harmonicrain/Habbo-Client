package com.sulake.habbo.window.utils.floorplaneditor
{
    import com.sulake.habbo.communication.messages.incoming.room.engine.FloorHeightMapEvent;
    import com.sulake.habbo.communication.messages.incoming.room.layout.RoomOccupiedTilesMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.layout.RoomOccupiedTilesMessageParser;
    import flash.geom.Point;

    public class FloorPlanCache
    {
        private const MAX_AXIS_LENGTH:uint = 100;

        private var _bcFloorPlanEditor:BCFloorPlanEditor;
        private var _floorWidth:int;
        private var _floorHeight:int;
        private var _floorPlanCache:Array;
        private var _floorPlanCacheBuffer:Array = null;
        private var _reservedTiles:Array;
        private var _entryPoint:Point;
        private var _entryPointDir:uint;
        private var _showedPopup:Boolean;

        public function FloorPlanCache(k:BCFloorPlanEditor)
        {
            this._bcFloorPlanEditor = k;
        }

        public function onFloorHeightMap(k:FloorHeightMapEvent):void
        {
            this.updateFloorPlanCache(k.getParser().text);
            this._showedPopup = false;
        }

        public function onOccupiedTiles(k:RoomOccupiedTilesMessageEvent):void
        {
            var parser:RoomOccupiedTilesMessageParser;
            var tile:Object;
            if (this._floorPlanCache)
            {
                parser = k.getParser();
                this.resetReservedTiles();
                for each (tile in parser.occupiedTiles)
                {
                    this._reservedTiles[tile.y][tile.x] = true;
                }
            }
        }

        private function resetReservedTiles():void
        {
            var x:int;
            this._reservedTiles = [];
            var y:int;
            while (y < this.floorHeight)
            {
                this._reservedTiles.push([]);
                x = 0;
                while (x < this.floorWidth)
                {
                    this._reservedTiles[y].push(false);
                    x++;
                }
                y++;
            }
        }

        private function updateFloorPlanCache(k:String=""):void
        {
            var row:String;
            var rows:Array = k.split("\r");
            this._floorPlanCache = [];
            for each (row in rows)
            {
                if (row.length > 0)
                {
                    this._floorPlanCache.push(row);
                }
            }
            this.checkDimensions();
        }

        private function checkDimensions():Boolean
        {
            var row:String;
            this._floorWidth = -1;
            this._floorHeight = -1;
            if (this._floorPlanCache.length == 0)
            {
                return false;
            }
            var width:int = String(this._floorPlanCache[0]).length;
            var height:int;
            for each (row in this._floorPlanCache)
            {
                if (row.length == 0)
                {
                    break;
                }
                height++;
            }
            this._floorWidth = width;
            this._floorHeight = height;
            return true;
        }

        private function allowDrawAt(x:int, y:int):Boolean
        {
            if (((this._floorPlanCache == null) || (!this.checkSizeLimits(y + 1, x + 1))))
            {
                return false;
            }
            if (((x == 0) || (y == 0)))
            {
                return this.isDoorTileAllowedAt(x, y);
            }
            return true;
        }

        private function isDoorTileAllowedAt(x:int, y:int):Boolean
        {
            return (this.isFirstColumnZeroOrHasDoorAt(x, y)) && (this.isFirstRowZeroOrHasDoorAt(x, y));
        }

        private function isFirstColumnZeroOrHasDoorAt(x:int, y:int):Boolean
        {
            var i:int;
            while (i < this._floorHeight)
            {
                if (((!(i == y)) && (!(this._floorPlanCache[i].substr(0, 1) == "x"))))
                {
                    return false;
                }
                i++;
            }
            return true;
        }

        private function isFirstRowZeroOrHasDoorAt(x:int, y:int):Boolean
        {
            var i:int;
            while (i < this._floorWidth)
            {
                if (((!(i == x)) && (!(this._floorPlanCache[0].substr(i, 1) == "x"))))
                {
                    return false;
                }
                i++;
            }
            return true;
        }

        public function setHeightAt(x:int, y:int, height:int):Boolean
        {
            if (((x < 0) || (y < 0)))
            {
                return false;
            }
            if (!this.allowDrawAt(x, y))
            {
                return false;
            }
            while (x >= this._floorWidth)
            {
                if (!this.addColumn())
                {
                    return false;
                }
            }
            while (y >= this._floorHeight)
            {
                if (!this.addRow())
                {
                    return false;
                }
            }
            if (this.isTileReserved(x, y))
            {
                return false;
            }
            this._floorPlanCache[y] = this.setCharAt(String(this._floorPlanCache[y]), ((height < 0) ? "x" : height.toString(33)), x);
            return true;
        }

        public function _Str_13296(x:int, y:int, height:int):Boolean
        {
            return this.setHeightAt(x, y, height);
        }

        public function getHeightAt(x:int, y:int):int
        {
            if ((((((this._floorPlanCache == null) || (x < 0)) || (x >= this._floorWidth)) || (y < 0)) || (y >= this._floorHeight)))
            {
                return -1;
            }
            var value:String = String(this._floorPlanCache[y]).charAt(x);
            return (value == "x") ? -1 : parseInt(value, 33);
        }

        public function _Str_4203(x:int, y:int):int
        {
            return this.getHeightAt(x, y);
        }

        private function setCharAt(k:String, value:String, index:int):String
        {
            return (k.substr(0, index) + value) + k.substr((index + 1));
        }

        public function get floorWidth():int
        {
            return this._floorWidth;
        }

        public function get _Str_17437():int
        {
            return this._floorWidth;
        }

        public function get floorHeight():int
        {
            return this._floorHeight;
        }

        public function getData():String
        {
            var data:String = "";
            var i:int;
            while (i < this._floorPlanCache.length)
            {
                data = ((data + this._floorPlanCache[i]) + "\r");
                i++;
            }
            return data;
        }

        public function _Str_21406():String
        {
            return this.getData();
        }

        public function isTileReserved(x:int, y:int):Boolean
        {
            if (!this._reservedTiles)
            {
                return false;
            }
            if (this._reservedTiles.length < (y + 1))
            {
                return false;
            }
            if (this._reservedTiles[y].length < (x + 1))
            {
                return false;
            }
            return this._reservedTiles[y][x];
        }

        public function _Str_19261(x:int, y:int):Boolean
        {
            return this.isTileReserved(x, y);
        }

        public function isEntryPoint(x:int, y:int):Boolean
        {
            if (!this._entryPoint)
            {
                return false;
            }
            return (this._entryPoint.x == x) && (this._entryPoint.y == y);
        }

        public function _Str_21855(x:int, y:int):Boolean
        {
            return this.isEntryPoint(x, y);
        }

        public function get entryPoint():Point
        {
            return this._entryPoint;
        }

        public function set entryPoint(k:Point):void
        {
            this._entryPoint = k;
        }

        public function get _Str_7642():Point
        {
            return this._entryPoint;
        }

        public function set _Str_7642(k:Point):void
        {
            this._entryPoint = k;
        }

        public function get entryPointDir():int
        {
            return this._entryPointDir;
        }

        public function set entryPointDir(k:int):void
        {
            if (k < 0)
            {
                k = 7;
            }
            if (k > 7)
            {
                k = 0;
            }
            this._entryPointDir = k;
        }

        public function get _Str_6184():int
        {
            return this._entryPointDir;
        }

        public function set _Str_6184(k:int):void
        {
            this.entryPointDir = k;
        }

        private function addColumn(silent:Boolean=false):Boolean
        {
            var y:int;
            if (!this.checkSizeLimits((this._floorWidth + 1), this._floorHeight))
            {
                if (((!this._showedPopup) && (!silent)))
                {
                    this._bcFloorPlanEditor.windowManager.simpleAlert("${floor.plan.editor.alert}", null, "${floor.plan.editor.size.limit.exceeded}");
                    this._bcFloorPlanEditor.heightMapEditor.drawing = false;
                    this._showedPopup = true;
                }
                return false;
            }
            y = 0;
            while (y < this._floorHeight)
            {
                if (String(this._floorPlanCache[y]).length > 0)
                {
                    this._floorPlanCache[y] = (this._floorPlanCache[y] + "x");
                    this._reservedTiles[y].push(false);
                }
                y++;
            }
            this._floorWidth++;
            return true;
        }

        private function addRow(silent:Boolean=false):Boolean
        {
            var x:int;
            if (!this.checkSizeLimits(this._floorWidth, (this._floorHeight + 1)))
            {
                if (((!this._showedPopup) && (!silent)))
                {
                    this._bcFloorPlanEditor.windowManager.simpleAlert("${floor.plan.editor.alert}", null, "${floor.plan.editor.size.limit.exceeded}");
                    this._bcFloorPlanEditor.heightMapEditor.drawing = false;
                    this._showedPopup = true;
                }
                return false;
            }
            var row:String = "";
            x = 0;
            while (x < this._floorWidth)
            {
                row = row + "x";
                x++;
            }
            this._floorPlanCache.push(row);
            var reserved:Array = [];
            x = 0;
            while (x < this._floorWidth)
            {
                reserved.push(false);
                x++;
            }
            this._reservedTiles.push(reserved);
            this._floorHeight++;
            return true;
        }

        public function attemptExpandColumns(x:int):Boolean
        {
            while (x >= this.floorWidth)
            {
                if (!this.addColumn(true))
                {
                    return false;
                }
            }
            return true;
        }

        public function attemptExpandRows(y:int):Boolean
        {
            while (y >= this.floorHeight)
            {
                if (!this.addRow(true))
                {
                    return false;
                }
            }
            return true;
        }

        private function checkSizeLimits(width:uint, height:uint):Boolean
        {
            return !((width > this.MAX_AXIS_LENGTH) || (height > this.MAX_AXIS_LENGTH));
        }

        public function initTemporaryCache():void
        {
            this._floorPlanCacheBuffer = this._floorPlanCache;
            this.clearTemporaryCache();
        }

        public function clearTemporaryCache():void
        {
            var i:int;
            if (this._floorPlanCacheBuffer != null)
            {
                this._floorPlanCache = [];
                i = 0;
                while (i < this._floorPlanCacheBuffer.length)
                {
                    this._floorPlanCache.push(this._floorPlanCacheBuffer[i]);
                    i++;
                }
                this.checkDimensions();
            }
        }

        public function submitTemporaryCache():void
        {
            this._floorPlanCacheBuffer = null;
        }
    }
}
