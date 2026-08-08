package com.sulake.habbo.roomevents.userdefinedroomevents
{
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualization;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.userdefinedroomevents.binaryData.SelectionShader;
    import com.sulake.room.object.IRoomObject;
    import flash.display.Shader;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.GlowFilter;
    import flash.filters.ShaderFilter;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    public class UserDefinedRoomEventsVisualizer
    {
        private var _userDefinedRoomEvents:HabboUserDefinedRoomEvents;
        private var _filterBW:Array;
        private var _filterBWWall:Array;
        private var _activeWiredFilter:Array;
        private var _dualPicking1Filter:Array;
        private var _dualPicking2Filter:Array;

        public function UserDefinedRoomEventsVisualizer(k:HabboUserDefinedRoomEvents)
        {
            var shaderClass:Class;
            var shader:Shader;
            var shaderFilter:ShaderFilter;
            var tint:Number = 154;
            var strength:Number = 0.75;
            var greenOffset:Number = 25.5;
            var blueOffset:Number = 25.5;
            var bwMatrix:Array = [
                1 - strength, 0, 0, 0, strength * tint,
                0, 1 - strength, 0, 0, strength * tint + greenOffset,
                0, 0, 1 - strength, 0, strength * tint + blueOffset,
                0, 0, 0, 1, 0
            ];
            var activeMatrix:Array = [
                0.9, 0, 0, 0, 0,
                0, 1, 0, 0, 40,
                0, 0, 1, 0, 80,
                0, 0, 0, 0.8, 0
            ];
            var dual1Matrix:Array = [
                1.13, 0, 0, 0, 35,
                0, 1.13, 0, 0, 35,
                0, 0, 1, 0, 0,
                0, 0, 0, 1, 0
            ];
            var dual2Matrix:Array = [
                1, 0, 0, 0, 0,
                0, 1, 0, 0, 0,
                0, 0, 1.15, 0, 40,
                0, 0, 0, 1, 0
            ];

            super();
            this._userDefinedRoomEvents = k;
            shaderClass = SelectionShader;
            shader = new Shader((new shaderClass() as ByteArray));
            shaderFilter = new ShaderFilter(shader);
            this._filterBW = [new ColorMatrixFilter(bwMatrix), shaderFilter];
            this._filterBWWall = [new ColorMatrixFilter(bwMatrix), shaderFilter, new GlowFilter(0xFFFFFF, 1, 5, 5, 3, 1, true, false)];
            this._activeWiredFilter = [new ColorMatrixFilter(activeMatrix)];
            this._dualPicking1Filter = [new ColorMatrixFilter(dual1Matrix)];
            this._dualPicking2Filter = [new ColorMatrixFilter(dual2Matrix)];
        }

        public static function addFiltersToFurni(k:IRoomObject, filters:Array, prepend:Boolean = false):void
        {
            if ((k == null) || hasFilters(k, filters))
            {
                return;
            }
            var visualization:FurnitureVisualization = k.getVisualization() as FurnitureVisualization;
            if (visualization == null)
            {
                return;
            }
            var current:Array = (visualization.filters == null) ? [] : visualization.filters.slice();
            visualization.filters = prepend ? filters.concat(current) : current.concat(filters);
        }

        public static function removeFiltersFromFurni(k:IRoomObject, filters:Array):void
        {
            var index:int;
            if (k == null)
            {
                return;
            }
            var visualization:FurnitureVisualization = k.getVisualization() as FurnitureVisualization;
            if ((visualization == null) || (visualization.filters == null))
            {
                return;
            }
            var current:Array = visualization.filters.slice();
            for each (var filter:Object in filters)
            {
                index = current.indexOf(filter);
                if (index != -1)
                {
                    current.splice(index, 1);
                }
            }
            visualization.filters = (current.length == 0) ? null : current;
        }

        public static function hasFilters(k:IRoomObject, filters:Array):Boolean
        {
            if (k == null)
            {
                return false;
            }
            var visualization:FurnitureVisualization = k.getVisualization() as FurnitureVisualization;
            if ((visualization == null) || (visualization.filters == null))
            {
                return false;
            }
            var current:Array = visualization.filters;
            for each (var filter:Object in filters)
            {
                if (current.indexOf(filter) != -1)
                {
                    return true;
                }
            }
            return false;
        }

        public function hide(k:int, dual:Boolean = false, pickSet:int = 0):void
        {
            this.inactivateFurni(this.getFurni(k), k < 0, dual, pickSet);
        }

        public function _Str_21701(k:Dictionary, dual:Boolean = false, pickSet:int = 0):void
        {
            this.hideAll(k, dual, pickSet);
        }

        public function hideAll(k:Dictionary, dual:Boolean, pickSet:int):void
        {
            var id:int;
            for (var key:String in k)
            {
                id = parseInt(key);
                this.inactivateFurni(this.getFurni(id), id < 0, dual, pickSet);
            }
        }

        public function show(k:int, dual:Boolean = false, pickSet:int = 0):void
        {
            this.activateFurni(this.getFurni(k), k < 0, dual, pickSet);
        }

        public function _Str_25313(k:Dictionary, dual:Boolean = false, pickSet:int = 0):void
        {
            this.showAll(k, dual, pickSet);
        }

        public function showAll(k:Dictionary, dual:Boolean, pickSet:int):void
        {
            var id:int;
            for (var key:String in k)
            {
                id = parseInt(key);
                this.activateFurni(this.getFurni(id), id < 0, dual, pickSet);
            }
        }

        public function highlightActiveWired(k:int):void
        {
            addFiltersToFurni(this.getFurni(k), this._activeWiredFilter);
        }

        public function unhighlightActiveWired(k:int):void
        {
            removeFiltersFromFurni(this.getFurni(k), this._activeWiredFilter);
        }

        private function getFurni(k:int):IRoomObject
        {
            if (k < 0)
            {
                return this._userDefinedRoomEvents.roomEngine.getRoomObject(this._userDefinedRoomEvents.roomId, -k, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            }
            return this._userDefinedRoomEvents.roomEngine.getRoomObject(this._userDefinedRoomEvents.roomId, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
        }

        private function activateFurni(k:IRoomObject, isWall:Boolean, dual:Boolean, pickSet:int):void
        {
            addFiltersToFurni(k, isWall ? this._filterBWWall : this._filterBW, true);
            if (dual)
            {
                addFiltersToFurni(k, pickSet == 1 ? this._dualPicking1Filter : this._dualPicking2Filter);
            }
        }

        private function inactivateFurni(k:IRoomObject, isWall:Boolean, dual:Boolean, pickSet:int):void
        {
            removeFiltersFromFurni(k, isWall ? this._filterBWWall : this._filterBW);
            if (dual)
            {
                removeFiltersFromFurni(k, pickSet == 1 ? this._dualPicking1Filter : this._dualPicking2Filter);
                if (hasFilters(k, pickSet == 1 ? this._dualPicking2Filter : this._dualPicking1Filter))
                {
                    addFiltersToFurni(k, isWall ? this._filterBWWall : this._filterBW, true);
                }
            }
        }
    }
}
