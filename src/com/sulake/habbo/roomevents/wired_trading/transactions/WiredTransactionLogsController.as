package com.sulake.habbo.roomevents.wired_trading.transactions
{
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogPage;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogsMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions.RequestChestTransactionLogsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions.RequestRoomTransactionLogsMessageComposer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import __AS3__.vec.Vector;

    /** Owns July's full 25-row transaction-log window. */
    public final class WiredTransactionLogsController implements IDisposable
    {
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _messageEvents:Vector.<IMessageEvent>;
        private var _page:WiredTransactionLogPage;
        private var _view:WiredTransactionLogsView;
        private var _disposed:Boolean;

        public function WiredTransactionLogsController(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._messageEvents = new Vector.<IMessageEvent>();
            this.addMessageEvent(new WiredTransactionLogsMessageEvent(this.onLogs));
        }

        private function onLogs(event:WiredTransactionLogsMessageEvent):void
        {
            var page:WiredTransactionLogPage = event.getParser().page;
            if (page == null || page.amount != TransactionConfig.PAGE_SIZE)
            {
                return;
            }
            this._page = page;
            if (this._view == null)
            {
                this._view = new WiredTransactionLogsView(this);
            }
            this._view.displayNewPage();
            this._view.show();
        }

        public function openRoomLogs():void
        {
            this.send(new RequestRoomTransactionLogsMessageComposer(
                TransactionConfig.PAGE_SIZE, TransactionConfig.FIRST_PAGE));
        }

        public function openChestLogs(chestId:int):void
        {
            if (chestId > 0)
            {
                this.send(new RequestChestTransactionLogsMessageComposer(
                    chestId, TransactionConfig.PAGE_SIZE,
                    TransactionConfig.FIRST_PAGE));
            }
        }

        public function requestPage(page:int):void
        {
            if (this._page == null) { return; }
            if (this._page.listType == WiredTransactionLogPage.LIST_CHEST)
            {
                this.send(new RequestChestTransactionLogsMessageComposer(
                    int(this._page.listId), TransactionConfig.PAGE_SIZE, page));
            }
            else
            {
                this.send(new RequestRoomTransactionLogsMessageComposer(
                    TransactionConfig.PAGE_SIZE, page));
            }
        }

        public function send(composer:IMessageComposer):void
        {
            this._roomEvents.send(composer);
        }

        private function addMessageEvent(event:IMessageEvent):void
        {
            this._messageEvents.push(event);
            this._roomEvents.communication.addHabboConnectionMessageEvent(event);
        }

        public function resetRoom():void
        {
            this._page = null;
            if (this._view != null) { this._view.hide(); }
        }

        public function get page():WiredTransactionLogPage { return this._page; }
        public function get localization():IHabboLocalizationManager
        {
            return this._roomEvents.localization;
        }
        public function get windowManager():IHabboWindowManager
        {
            return this._roomEvents.windowManager;
        }
        public function get sessionDataManager():ISessionDataManager
        {
            return this._roomEvents.sessionDataManager;
        }
        public function get roomEvents():HabboUserDefinedRoomEvents { return this._roomEvents; }

        public function dispose():void
        {
            if (this._disposed) { return; }
            if (this._view != null) { this._view.dispose(); this._view = null; }
            for each (var event:IMessageEvent in this._messageEvents)
            {
                this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
            }
            this._messageEvents = null;
            this._page = null;
            this._roomEvents = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
