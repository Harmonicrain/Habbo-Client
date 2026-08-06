package com.sulake.habbo.roomevents.wired_trading.transactions
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionDetails;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionDetailsMessageEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import __AS3__.vec.Vector;

    /** Owns July's retained transaction-details response and window. */
    public final class WiredTransactionDetailsController implements IDisposable
    {
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _messageEvents:Vector.<IMessageEvent>;
        private var _details:WiredTransactionDetails;
        private var _view:WiredTransactionDetailsView;
        private var _disposed:Boolean;

        public function WiredTransactionDetailsController(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._messageEvents = new Vector.<IMessageEvent>();
            var event:IMessageEvent =
                new WiredTransactionDetailsMessageEvent(this.onDetails);
            this._messageEvents.push(event);
            roomEvents.communication.addHabboConnectionMessageEvent(event);
        }

        private function onDetails(event:WiredTransactionDetailsMessageEvent):void
        {
            this._details = event.getParser().details;
            if (this._details == null) { return; }
            if (this._view == null)
            {
                this._view = new WiredTransactionDetailsView(this);
            }
            this._view.updateUI();
            this._view.show();
        }

        public function resetRoom():void
        {
            this._details = null;
            if (this._view != null) { this._view.hide(); }
        }

        public function get details():WiredTransactionDetails { return this._details; }
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
            this._details = null;
            this._roomEvents = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
