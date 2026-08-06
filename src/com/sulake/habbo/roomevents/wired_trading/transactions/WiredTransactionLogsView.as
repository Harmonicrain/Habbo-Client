package com.sulake.habbo.roomevents.wired_trading.transactions
{
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogPage;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionInfo;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.utils.LoadingIcon;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;
    import flash.utils.getTimer;
    import __AS3__.vec.Vector;

    /** Exact July full transaction-list interaction adapted to clean TableView. */
    public final class WiredTransactionLogsView implements IDisposable
    {
        private static const REQUEST_PAGE_RATE_LIMIT:uint = 280;
        private static const SAME_PAGE_TIMEOUT:uint = 2000;

        private var _controller:WiredTransactionLogsController;
        private var _window:IFrameWindow;
        private var _table:TableView;
        private var _loading:LoadingIcon;
        private var _pendingPage:int = -1;
        private var _lastRequest:int;
        private var _disposed:Boolean;

        public function WiredTransactionLogsView(
            controller:WiredTransactionLogsController)
        {
            this._controller = controller;
            this._window = controller.windowManager.buildFromXML(XML(
                controller.roomEvents.assets.getAssetByName(
                    "transaction_overview_xml").content), 1) as IFrameWindow;
            this._loading = new LoadingIcon();
            this.pageInput.restrict = "0-9";
            var tableAsset:XmlAsset = controller.roomEvents.assets
                .getAssetByName("table_view_xml") as XmlAsset;
            this._table = new TableView(controller.windowManager,
                this.tableContainer, true, true, tableAsset);
            this._table.initialize(new <TableColumn>[
                new TableColumn("type", this.loc("wiredchests.logs.col.type"), 0.17),
                new TableColumn("timestamp",
                    this.loc("wiredchests.logs.col.timestamp"), 0.15),
                new TableColumn("username",
                    this.loc("wiredchests.logs.col.username"), 0.14),
                new TableColumn("withdraws",
                    this.loc("wiredchests.logs.col.withdraws"), 0.14),
                new TableColumn("deposits",
                    this.loc("wiredchests.logs.col.deposits"), 0.14),
                new TableColumn("chests",
                    this.loc("wiredchests.logs.col.chests"), 0.12),
                new TableColumn("details",
                    this.loc("wiredchests.logs.col.details"), 0.14)
            ], true, true);
            this.firstButton.addEventListener("WME_CLICK", this.onFirst);
            this.previousButton.addEventListener("WME_CLICK", this.onPrevious);
            this.nextButton.addEventListener("WME_CLICK", this.onNext);
            this.lastButton.addEventListener("WME_CLICK", this.onLast);
            this.refreshButton.addEventListener("WME_CLICK", this.onRefresh);
            this.pageInput.addEventListener("WKE_KEY_DOWN", this.onPageKeyDown);
            this.pageInput.addEventListener("WME_CLICK_AWAY", this.onPageClickAway);
            this.closeButton.addEventListener("WME_CLICK", this.onClose);
            this.hide();
        }

        public function displayNewPage():void
        {
            var page:WiredTransactionLogPage = this._controller.page;
            if (page == null) { return; }
            this._loading.setVisible(this.loadingIcon, false);
            if (page.currentPage == this._pendingPage) { this._pendingPage = -1; }
            this.listTypeValue.text = this.loc(
                "wiredchests.logs.type." + page.listType);
            this.idKey.text = this.loc(page.listType == WiredTransactionLogPage.LIST_CHEST
                ? "wiredchests.logs.chest_id" : "wiredchests.logs.room_id");
            this.idValue.text = String(page.listId);
            var last:int = this.lastPage;
            Util.disableSection(this.firstButton, page.currentPage <= 1);
            Util.disableSection(this.previousButton, page.currentPage <= 1);
            Util.disableSection(this.nextButton, page.currentPage >= last);
            Util.disableSection(this.lastButton, page.currentPage >= last);
            var parts:Array = this.loc("wiredchests.logs.bottom_text").split("%page%");
            if (parts.length == 2)
            {
                this.pageTextStart.text = String(parts[0]).replace(
                    "%transaction_count%", page.totalLogs);
                this.pageTextEnd.text = String(parts[1]).replace(
                    "%page_count%", last);
                this.pageInput.text = String(page.currentPage);
            }
            var rows:Vector.<ITableObject> = new Vector.<ITableObject>();
            for each (var info:WiredTransactionInfo in page.logs)
            {
                rows.push(new TransactionTableObject(this._controller, info));
            }
            this._table.setObjects(rows, true);
            this._window.activate();
        }

        public function show():void
        {
            if (this._window.parent == null)
            {
                this._controller.windowManager.getDesktop(1).addChild(this._window);
                this._window.center();
            }
        }

        public function hide():void
        {
            if (this._window.parent != null)
            {
                this._controller.windowManager.getDesktop(1).removeChild(this._window);
            }
        }

        private function onClose(event:WindowMouseEvent):void { this.hide(); }
        private function onFirst(event:WindowMouseEvent):void { this.requestPage(1); }
        private function onPrevious(event:WindowMouseEvent):void
        {
            if (this._controller.page != null)
            {
                this.requestPage(this._controller.page.currentPage - 1);
            }
        }
        private function onNext(event:WindowMouseEvent):void
        {
            if (this._controller.page != null)
            {
                this.requestPage(this._controller.page.currentPage + 1);
            }
        }
        private function onLast(event:WindowMouseEvent):void
        {
            this.requestPage(this.lastPage);
        }
        private function onRefresh(event:WindowMouseEvent):void
        {
            if (this._controller.page != null)
            {
                this.requestPage(this._controller.page.currentPage);
            }
        }
        private function onPageClickAway(event:WindowMouseEvent):void
        {
            this.navigateToInputPage();
        }
        private function onPageKeyDown(event:WindowKeyboardEvent):void
        {
            if (event.keyCode == 13) { this.navigateToInputPage(); }
        }
        private function navigateToInputPage():void
        {
            if (this._controller.page == null) { return; }
            var page:int = Math.max(1, Math.min(this.lastPage, int(this.pageInput.text)));
            this.pageInput.text = String(page);
            if (page != this._controller.page.currentPage)
            {
                this.requestPage(page);
            }
        }
        private function requestPage(page:int):void
        {
            if (this._controller.page == null || page < 1 || page > this.lastPage)
            {
                return;
            }
            var now:int = getTimer();
            if (this._lastRequest > now - REQUEST_PAGE_RATE_LIMIT
                || (page == this._pendingPage
                    && this._lastRequest > now - SAME_PAGE_TIMEOUT))
            {
                return;
            }
            this._pendingPage = page;
            this._lastRequest = now;
            this._controller.requestPage(page);
            this._loading.setVisible(this.loadingIcon, true);
        }
        private function get lastPage():int
        {
            var total:int = this._controller.page == null
                ? 0 : this._controller.page.totalLogs;
            return Math.max(1, int(Math.max(total - 1, 0)
                / TransactionConfig.PAGE_SIZE) + 1);
        }
        private function loc(key:String):String
        {
            return this._controller.localization.getLocalization(key, key);
        }

        private function get closeButton():IWindow
        {
            return this._window.findChildByName("header_button_close");
        }
        private function get listTypeValue():ITextWindow
        {
            return this._window.findChildByName("list_type_value") as ITextWindow;
        }
        private function get idKey():ITextWindow
        {
            return this._window.findChildByName("id_key") as ITextWindow;
        }
        private function get idValue():ITextWindow
        {
            return this._window.findChildByName("id_value") as ITextWindow;
        }
        private function get refreshButton():IButtonWindow
        {
            return this._window.findChildByName("refresh_btn") as IButtonWindow;
        }
        private function get loadingIcon():IIconWindow
        {
            return this._window.findChildByName("searching_icon") as IIconWindow;
        }
        private function get tableContainer():IWindowContainer
        {
            return this._window.findChildByName("table_view") as IWindowContainer;
        }
        private function get firstButton():IWindow
        {
            return this._window.findChildByName("first_page_btn");
        }
        private function get previousButton():IWindow
        {
            return this._window.findChildByName("prev_page_btn");
        }
        private function get nextButton():IWindow
        {
            return this._window.findChildByName("next_page_btn");
        }
        private function get lastButton():IWindow
        {
            return this._window.findChildByName("last_page_btn");
        }
        private function get pageTextStart():ITextWindow
        {
            return this._window.findChildByName("pagina_text_start") as ITextWindow;
        }
        private function get pageInput():ITextFieldWindow
        {
            return this._window.findChildByName("pagina_number_input")
                as ITextFieldWindow;
        }
        private function get pageTextEnd():ITextWindow
        {
            return this._window.findChildByName("pagina_text_end") as ITextWindow;
        }

        public function dispose():void
        {
            if (this._disposed) { return; }
            this._loading.dispose();
            this._loading = null;
            this._table.dispose();
            this._table = null;
            this._window.dispose();
            this._window = null;
            this._controller = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
