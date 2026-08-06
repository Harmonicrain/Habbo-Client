package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.elements.MenuItem;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.elements.MenuSpacer;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.menu.views.MenuItemView;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.geom.Point;

    public class MenuPreset extends WiredUIPreset
    {
        public static const SPACER:MenuSpacer = new MenuSpacer();

        private var _container:IWindowContainer;
        private var _menuItemTemplate:IRegionWindow;
        private var _spacerTemplate:IWindow;
        private var _items:Vector.<MenuItemView>;
        private var _anchor:IWindow;

        public function MenuPreset(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle, elements:Array, anchor:IWindow)
        {
            super(roomEvents, presetManager, style);
            this._anchor = anchor;
            this._container = style.createQuickMenu();
            var list:IItemListWindow = this.menuList;
            var widthPadding:int = this._container.width - list.width;
            var heightPadding:int = this._container.height - list.height;
            this._menuItemTemplate = list.removeListItem(list.getListItemByName("menu_item_template")) as IRegionWindow;
            this._spacerTemplate = list.removeListItem(list.getListItemByName("spacer_template"));
            this._items = new Vector.<MenuItemView>();
            var requestedWidth:int = 0;
            for each (var element:* in elements)
            {
                if (element is MenuItem)
                {
                    var itemView:MenuItemView = new MenuItemView(this, element as MenuItem);
                    this._items.push(itemView);
                    list.addListItem(itemView.window);
                    requestedWidth = Math.max(requestedWidth, itemView.requestedMinWidth);
                }
                else if (element is MenuSpacer)
                {
                    list.addListItem(this._spacerTemplate.clone());
                }
            }
            this._container.width = requestedWidth + widthPadding + style.menuRightOffset;
            this._container.height = list.height + heightPadding;
            this._container.addEventListener(WindowEvent.WINDOW_EVENT_DEACTIVATED, this.onDeactivate);
        }

        private function onDeactivate(event:WindowEvent):void { this.requestClose(); }

        public function requestOpen():void
        {
            var desktop:IDesktopWindow = this._roomEvents.windowManager.getDesktop(1);
            if (desktop != null) { desktop.addChild(this._container); }
            var point:Point = new Point();
            this._anchor.getGlobalPosition(point);
            this._container.x = point.x;
            this._container.y = point.y + this._anchor.height;
            this._container.visible = true;
            this._container.activate();
        }

        public function requestClose():void
        {
            var desktop:IDesktopWindow = this._roomEvents.windowManager.getDesktop(1);
            if (desktop != null && this._container.parent == desktop) { desktop.removeChild(this._container); }
        }

        public function setSelected(index:int, value:Boolean):void { this._items[index].selected = value; }
        public function getSelected(index:int):Boolean { return this._items[index].selected; }
        public function setDisabled(index:int, value:Boolean):void { this._items[index].disabled = value; }
        public function getDisabled(index:int):Boolean { return this._items[index].disabled; }
        override public function get window():IWindow { return this._container; }
        override protected function get childPresets():Array { return []; }
        public function get menuItemTemplate():IRegionWindow { return this._menuItemTemplate; }
        private function get menuList():IItemListWindow { return this._container.findChildByName("menu_list") as IItemListWindow; }

        override public function dispose():void
        {
            if (disposed) { return; }
            this.requestClose();
            for each (var item:MenuItemView in this._items) { item.dispose(); }
            this._items = null;
            this._container.dispose();
            this._container = null;
            this._menuItemTemplate.dispose();
            this._menuItemTemplate = null;
            this._spacerTemplate.dispose();
            this._spacerTemplate = null;
            this._anchor = null;
            super.dispose();
        }
    }
}
