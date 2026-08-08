package com.sulake.habbo.roomevents.wired_setup.common
{
    public class NeighborhoodFloor
    {
        public static const RADIUS:int = 10;
        public static const SMALL_RADIUS:int = 5;

        private var _floorPlanCache:Array;
        private var _floorPlanCacheBuffer:Array;
        private var _smallMode:Boolean;
        private var _onChanged:Function;

        public function NeighborhoodFloor(floorPlanCache:Array, smallMode:Boolean, onChanged:Function)
        {
            super();
            this._floorPlanCache = floorPlanCache;
            this._smallMode = smallMode;
            this._onChanged = onChanged;
        }

        public function get floorPlanCache():Array { return this._floorPlanCache; }
        public function setOccupied(x:int, y:int, occupied:Boolean):void { this._floorPlanCache[x][y] = occupied; }
        public function isOccupied(x:int, y:int):Boolean { return this._floorPlanCache[x][y]; }

        public function occupationHasChanged():void
        {
            if (this._onChanged != null) this._onChanged();
        }

        public function set smallMode(value:Boolean):void { this._smallMode = value; }

        public function smallModeAllowed():Boolean
        {
            for (var x:int = -RADIUS; x <= RADIUS; x++)
            {
                for (var y:int = -RADIUS; y <= RADIUS; y++)
                {
                    if ((x < -SMALL_RADIUS || x > SMALL_RADIUS || y < -SMALL_RADIUS || y > SMALL_RADIUS)
                            && this.isOccupied(x + RADIUS, y + RADIUS))
                    {
                        return false;
                    }
                }
            }
            return true;
        }

        public function get visualizingRadius():int { return this._smallMode ? SMALL_RADIUS : RADIUS; }
        public function get visualizingDimension():int { return this.visualizingRadius * 2 + 1; }

        public function initTemporaryCache():void
        {
            this._floorPlanCacheBuffer = this._floorPlanCache;
            this.clearTemporaryCache();
        }

        public function clearTemporaryCache():void
        {
            if (this._floorPlanCacheBuffer == null) return;
            this._floorPlanCache = [];
            for each (var row:Array in this._floorPlanCacheBuffer)
            {
                this._floorPlanCache.push(row.concat());
            }
        }

        public function submitTemporaryCache():void { this._floorPlanCacheBuffer = null; }
    }
}
