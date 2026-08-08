package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualization;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectController;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.GlowFilter;

    /** Room-object highlighting used by July's variable overview. */
    public final class WiredMenuHolderHighlighter
    {
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _filters:Array;
        private var _furniIds:Array = [];
        private var _userIds:Array = [];

        public function WiredMenuHolderHighlighter(
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._filters = [
                new ColorMatrixFilter([
                    0.9, 0, 0, 0, 0,
                    0, 1, 0, 0, 40,
                    0, 0, 1, 0, 80,
                    0, 0, 0, 0.85, 0
                ]),
                new GlowFilter(12318714, 1, 4, 4, 4, 1, true, false)
            ];
        }

        public function show(target:int, holderIds:Array):void
        {
            this.clear();
            if (holderIds == null || holderIds.length > 200)
            {
                return;
            }
            for each (var holderId:int in holderIds)
            {
                if (target == 0)
                {
                    this.highlightFurni(holderId);
                }
                else if (target == 1)
                {
                    this.highlightUser(holderId);
                }
            }
        }

        private function highlightFurni(id:int):void
        {
            var category:int = id < 0 ? 20 : 10;
            var objectId:int = id < 0 ? -id : id;
            var object:IRoomObject = this._roomEvents.roomEngine.getRoomObject(
                this._roomEvents.roomId, objectId, category);
            var visualization:FurnitureVisualization = object == null ? null :
                object.getVisualization() as FurnitureVisualization;
            if (visualization == null)
            {
                return;
            }
            var filters:Array =
                visualization.filters == null ? [] :
                visualization.filters.slice();
            for each (var filter:Object in this._filters)
            {
                if (filters.indexOf(filter) < 0)
                {
                    filters.push(filter);
                }
            }
            visualization.filters = filters;
            this._furniIds.push(id);
        }

        private function highlightUser(id:int):void
        {
            var object:IRoomObject = this._roomEvents.roomEngine.getRoomObject(
                this._roomEvents.roomId, id, 100);
            if (object == null)
            {
                return;
            }
            (object as IRoomObjectController).getModelController().setNumber(
                "figure_highlight_variable_holder", 1);
            this._userIds.push(id);
        }

        public function clear():void
        {
            for each (var id:int in this._furniIds)
            {
                var category:int = id < 0 ? 20 : 10;
                var objectId:int = id < 0 ? -id : id;
                var object:IRoomObject =
                    this._roomEvents.roomEngine.getRoomObject(
                        this._roomEvents.roomId, objectId, category);
                var visualization:FurnitureVisualization =
                    object == null ? null :
                    object.getVisualization() as FurnitureVisualization;
                if (visualization != null && visualization.filters != null)
                {
                    var filters:Array = visualization.filters.slice();
                    for each (var filter:Object in this._filters)
                    {
                        var index:int = filters.indexOf(filter);
                        if (index >= 0)
                        {
                            filters.splice(index, 1);
                        }
                    }
                    visualization.filters = filters;
                }
            }
            for each (id in this._userIds)
            {
                object = this._roomEvents.roomEngine.getRoomObject(
                    this._roomEvents.roomId, id, 100);
                if (object != null)
                {
                    (object as IRoomObjectController).getModelController()
                        .setNumber("figure_highlight_variable_holder", 0);
                }
            }
            this._furniIds = [];
            this._userIds = [];
        }

        public function dispose():void
        {
            this.clear();
            this._roomEvents = null;
            this._filters = null;
        }
    }
}
