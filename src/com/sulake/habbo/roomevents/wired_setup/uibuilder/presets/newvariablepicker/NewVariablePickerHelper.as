package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker
{
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Per-room recent-selection history and pooled node views used by July's picker. */
    public class NewVariablePickerHelper
    {
        private static const MAX_HISTORY:int = 20;

        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _history:Map = new Map();
        private var _templates:Map = new Map();
        private var _templateOwners:Map = new Map();
        private var _pooledViews:Map = new Map();

        public function NewVariablePickerHelper(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
        }

        public function addToHistory(variable:WiredVariable):void
        {
            if (variable == null || this._roomEvents.roomId == 0) { return; }
            var roomId:int = this._roomEvents.roomId;
            if (!this._history.hasKey(roomId)) { this._history.add(roomId, new Map()); }
            var roomHistory:Map = this._history.getValue(roomId) as Map;
            if (!roomHistory.hasKey(variable.variableTarget))
            {
                roomHistory.add(variable.variableTarget, new Vector.<String>());
            }
            var values:Vector.<String> = roomHistory.getValue(variable.variableTarget) as Vector.<String>;
            var index:int = values.indexOf(variable.variableId);
            if (index >= 0) { values.splice(index, 1); }
            values.unshift(variable.variableId);
            if (values.length > MAX_HISTORY) { values.pop(); }
        }

        public function getHistory(variableTarget:int):Vector.<String>
        {
            var roomHistory:Map = this._history.getValue(this._roomEvents.roomId) as Map;
            if (roomHistory == null || !roomHistory.hasKey(variableTarget)) { return new Vector.<String>(); }
            return Vector.<String>(roomHistory.getValue(variableTarget)).concat();
        }

        public function acquireNodeView(style:WiredStyle):IRegionWindow
        {
            var pool:Vector.<IRegionWindow> = this._pooledViews.getValue(style.name) as Vector.<IRegionWindow>;
            if (pool != null && pool.length > 0) { return pool.pop(); }
            if (!this._templates.hasKey(style.name))
            {
                var layout:IWindowContainer = this._roomEvents.wiredCtrl.presetManager.createLayout("search_tree_dropdown") as IWindowContainer;
                this._templates.add(style.name, layout.findChildByName("node_template"));
                this._templateOwners.add(style.name, layout);
            }
            return IRegionWindow(this._templates.getValue(style.name)).clone() as IRegionWindow;
        }

        public function releaseNodeView(style:WiredStyle, view:IRegionWindow):void
        {
            var pool:Vector.<IRegionWindow> = this._pooledViews.getValue(style.name) as Vector.<IRegionWindow>;
            if (pool == null)
            {
                pool = new Vector.<IRegionWindow>();
                this._pooledViews.add(style.name, pool);
            }
            pool.push(view);
        }

        public function dispose():void
        {
            for each (var owner:IWindow in this._templateOwners.getValues()) { owner.dispose(); }
            for each (var pool:Vector.<IRegionWindow> in this._pooledViews.getValues())
            {
                for each (var view:IRegionWindow in pool) { view.dispose(); }
            }
            this._history.dispose();
            this._templates.dispose();
            this._templateOwners.dispose();
            this._pooledViews.dispose();
            this._roomEvents = null;
        }
    }
}
