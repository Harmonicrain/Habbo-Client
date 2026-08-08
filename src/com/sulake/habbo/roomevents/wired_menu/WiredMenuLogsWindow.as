package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;
    import flash.events.TimerEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;

    /**
     * July-compatible Wired execution log browser. Packet transport stays in
     * WiredMenuController; this class owns only the dedicated window state.
     */
    public final class WiredMenuLogsWindow implements IDisposable
    {
        private static const PAGE_SIZE:int = 50;
        private static const AUTO_REFRESH_MS:int = 2500;

        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _requestCallback:Function;
        private var _window:IFrameWindow;
        private var _table:TableView;
        private var _timer:Timer;
        private var _page:int = 1;
        private var _total:int;
        private var _disposed:Boolean;

        public function WiredMenuLogsWindow(roomEvents:HabboUserDefinedRoomEvents,
                                            requestCallback:Function)
        {
            this._roomEvents = roomEvents;
            this._requestCallback = requestCallback;
            this._timer = new Timer(AUTO_REFRESH_MS);
            this._timer.addEventListener(TimerEvent.TIMER, this.onAutoRefresh);
        }

        public function show():void
        {
            this.ensureWindow();
            if (this._window == null)
            {
                return;
            }
            this._window.visible = true;
            this._window.activate();
            this.requestPage(this._page);
        }

        public function applyPage(parser:Object):void
        {
            if (parser == null)
            {
                return;
            }
            this.ensureWindow();
            this._total = Math.max(0, int(parser.total));
            this._page = Math.max(1, int(parser.page));
            var rows:Vector.<com.sulake.habbo.window.utils.tableview.ITableObject> =
                new Vector.<com.sulake.habbo.window.utils.tableview.ITableObject>();
            var entry:Object;
            var index:int;
            for each (entry in parser.entries)
            {
                rows.push(new WiredMenuTableObject("log_" + entry.id + "_" + index++, {
                    "time": entry.timestampText,
                    "level": this.loc("wiredmenu.logs_overview.log_level." + entry.level,
                        String(entry.level)),
                    "source": this.loc("wiredmenu.logs_overview.log_source." + entry.source,
                        String(entry.source)),
                    "message": entry.message
                }, entry));
            }
            if (this._table != null)
            {
                this._table.setObjects(rows, true);
            }
            this.updatePagination();
            this.applyResponseFilters(parser);
        }

        public function close():void
        {
            this._timer.stop();
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER, this.onAutoRefresh);
            if (this._table != null)
            {
                this._table.dispose();
                this._table = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._requestCallback = null;
            this._roomEvents = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        private function ensureWindow():void
        {
            if (this._window != null || this._disposed)
            {
                return;
            }
            this._window = this._roomEvents.getXmlWindow(
                "wired_menu_logs_overview") as IFrameWindow;
            if (this._window == null)
            {
                return;
            }
            this._roomEvents.windowManager.getDesktop(1).addChild(this._window);
            this._window.center();
            var close:IWindow = this._window.findChildByTag("close");
            if (close != null)
            {
                close.addEventListener(WindowMouseEvent.CLICK, this.onClose);
            }
            this.bindClick("first_page_btn", this.onFirstPage);
            this.bindClick("prev_page_btn", this.onPreviousPage);
            this.bindClick("next_page_btn", this.onNextPage);
            this.bindClick("last_page_btn", this.onLastPage);
            var input:ITextFieldWindow =
                this._window.findChildByName("filter_input") as ITextFieldWindow;
            if (input != null)
            {
                input.maxChars = 64;
                input.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN,
                    this.onFilterKey);
            }
            var pageInput:ITextFieldWindow =
                this._window.findChildByName("pagina_number_input") as ITextFieldWindow;
            if (pageInput != null)
            {
                pageInput.restrict = "0-9";
                pageInput.maxChars = 6;
                pageInput.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN,
                    this.onPageKey);
            }
            var source:IDropMenuWindow =
                this._window.findChildByName("log_source_menu") as IDropMenuWindow;
            var level:IDropMenuWindow =
                this._window.findChildByName("log_level_menu") as IDropMenuWindow;
            if (source != null)
            {
                source.selection = 0;
                source.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onFilterChanged);
            }
            if (level != null)
            {
                level.selection = 0;
                level.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onFilterChanged);
            }
            var autoRefresh:ICheckBoxWindow =
                this._window.findChildByName("auto_refresh_cbx") as ICheckBoxWindow;
            if (autoRefresh != null)
            {
                autoRefresh.select();
                autoRefresh.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onAutoRefreshChanged);
                autoRefresh.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED,
                    this.onAutoRefreshChanged);
                this._timer.start();
            }
            var tableParent:IWindowContainer =
                this._window.findChildByName("table_view") as IWindowContainer;
            var tableAsset:XmlAsset =
                this._roomEvents.assets.getAssetByName("table_view_xml") as XmlAsset;
            if (tableParent != null && tableAsset != null)
            {
                this._table = new TableView(this._roomEvents.windowManager,
                    tableParent, true, false, tableAsset);
                this._table.initialize(new <TableColumn>[
                    new TableColumn("time", this.loc("wiredmenu.logs_overview.col.timestamp",
                        "Timestamp"), 0.20, "left"),
                    new TableColumn("level", this.loc("wiredmenu.logs_overview.col.level",
                        "Level"), 0.12, "left"),
                    new TableColumn("source", this.loc("wiredmenu.logs_overview.col.source",
                        "Source"), 0.16, "left"),
                    new TableColumn("message", this.loc("wiredmenu.logs_overview.col.message",
                        "Message"), 0.52, "left")
                ], true, false);
            }
        }

        private function bindClick(name:String, callback:Function):void
        {
            var window:IWindow = this._window.findChildByName(name);
            if (window != null)
            {
                window.addEventListener(WindowMouseEvent.CLICK, callback);
            }
        }

        private function requestPage(page:int):void
        {
            if (this._requestCallback == null)
            {
                return;
            }
            var source:IDropMenuWindow =
                this._window.findChildByName("log_source_menu") as IDropMenuWindow;
            var level:IDropMenuWindow =
                this._window.findChildByName("log_level_menu") as IDropMenuWindow;
            var input:ITextFieldWindow =
                this._window.findChildByName("filter_input") as ITextFieldWindow;
            this._requestCallback(Math.max(1, page), PAGE_SIZE,
                level == null ? -1 : level.selection - 1,
                source == null ? -1 : source.selection - 1,
                input == null ? "" : input.text.substr(0, 64));
        }

        private function updatePagination():void
        {
            if (this._window == null)
            {
                return;
            }
            var pageCount:int = Math.max(1, Math.ceil(this._total / PAGE_SIZE));
            this._page = Math.min(Math.max(1, this._page), pageCount);
            var start:ITextWindow =
                this._window.findChildByName("pagina_text_start") as ITextWindow;
            var end:ITextWindow =
                this._window.findChildByName("pagina_text_end") as ITextWindow;
            var input:ITextFieldWindow =
                this._window.findChildByName("pagina_number_input") as ITextFieldWindow;
            if (start != null)
            {
                start.text = this._total + " logs found. Showing page";
            }
            if (input != null)
            {
                input.text = String(this._page);
            }
            if (end != null)
            {
                end.text = "of " + pageCount;
            }
            this.setEnabled("first_page_btn", this._page > 1);
            this.setEnabled("prev_page_btn", this._page > 1);
            this.setEnabled("next_page_btn", this._page < pageCount);
            this.setEnabled("last_page_btn", this._page < pageCount);
        }

        private function applyResponseFilters(parser:Object):void
        {
            if (this._window == null)
            {
                return;
            }
            if (parser.hasOwnProperty("levelFilter"))
            {
                var level:IDropMenuWindow =
                    this._window.findChildByName("log_level_menu")
                    as IDropMenuWindow;
                if (level != null)
                {
                    level.selection = int(parser.levelFilter) + 1;
                }
            }
            if (parser.hasOwnProperty("sourceFilter"))
            {
                var source:IDropMenuWindow =
                    this._window.findChildByName("log_source_menu")
                    as IDropMenuWindow;
                if (source != null)
                {
                    source.selection = int(parser.sourceFilter) + 1;
                }
            }
            if (parser.hasOwnProperty("query"))
            {
                var input:ITextFieldWindow =
                    this._window.findChildByName("filter_input")
                    as ITextFieldWindow;
                if (input != null)
                {
                    input.text = String(parser.query);
                }
            }
        }

        private function setEnabled(name:String, enabled:Boolean):void
        {
            var window:IWindow = this._window.findChildByName(name);
            if (window != null)
            {
                if (enabled) window.enable(); else window.disable();
            }
        }

        private function loc(key:String, fallback:String):String
        {
            return this._roomEvents.localization.getLocalization(key, fallback);
        }

        private function onClose(event:WindowMouseEvent):void { this.close(); }
        private function onFirstPage(event:WindowMouseEvent):void { this.requestPage(1); }
        private function onPreviousPage(event:WindowMouseEvent):void
        {
            this.requestPage(Math.max(1, this._page - 1));
        }
        private function onNextPage(event:WindowMouseEvent):void
        {
            this.requestPage(this._page + 1);
        }
        private function onLastPage(event:WindowMouseEvent):void
        {
            this.requestPage(Math.max(1, Math.ceil(this._total / PAGE_SIZE)));
        }
        private function onFilterChanged(event:WindowEvent):void
        {
            this.requestPage(1);
        }
        private function onFilterKey(event:WindowKeyboardEvent):void
        {
            if (event.charCode == Keyboard.ENTER)
            {
                this.requestPage(1);
            }
        }
        private function onPageKey(event:WindowKeyboardEvent):void
        {
            if (event.charCode != Keyboard.ENTER)
            {
                return;
            }
            var input:ITextFieldWindow = event.window as ITextFieldWindow;
            this.requestPage(Math.max(1, int(input.text)));
        }
        private function onAutoRefreshChanged(event:WindowEvent):void
        {
            var checkbox:ICheckBoxWindow = event.window as ICheckBoxWindow;
            if (checkbox != null && checkbox.Selected)
            {
                this._timer.start();
            }
            else
            {
                this._timer.stop();
            }
        }
        private function onAutoRefresh(event:TimerEvent):void
        {
            if (this._window != null && this._window.visible)
            {
                this.requestPage(this._page);
            }
        }
    }
}
